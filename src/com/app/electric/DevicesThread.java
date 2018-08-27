package com.app.electric;

import com.app.electric.iecrole.IEC104APDU;
import com.app.electric.iecrole.IECTools;
import com.app.sys.DB;
import com.app.sys.JsonUtil;
import com.app.sys.WebSocketManager;
import com.app.utility.Machine;
import com.app.utility.MessageUtil;
import com.app.utility.Tools;
import net.wimpi.modbus.msg.*;
import net.wimpi.modbus.procimg.InputRegister;
import net.wimpi.modbus.procimg.Register;
import net.wimpi.modbus.procimg.SimpleRegister;
import net.wimpi.modbus.util.BitVector;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.Socket;
import java.net.SocketException;
import java.util.*;

//设备线程
public class DevicesThread extends Thread {
	static ScriptEngine jse = new ScriptEngineManager().getEngineByName("JavaScript");
	private static String ip = "127.0.0.1";
	private static int port = 8850;
	private static Socket socket = null;

	static {
		try {
			ip = Machine.getPropertie("api.ip");
			port = Integer.parseInt(Machine.getPropertie("api.port"));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	boolean iec103tcp_init = false;
	private BoxThread processSocketData;
	private String device_id;
	private String device_name;
	private String box_id;
	private String device_type_id;
	private String protocol_id;
	private int break_second;
	private int device_num;
	private Map<String,Date> warningTimeRecord = new HashMap<String,Date>();  //key REGISTER_ID
	private Map<String,Date> sendTimeRecord = new HashMap<String,Date>();  //key REGISTER_ID_(SMS/EMAIL)

	public DevicesThread(BoxThread processSocketData, Map<String, Object> device) throws Exception {
		this.processSocketData = processSocketData;
		device_id = (String) device.get("DEVICE_ID");
		device_name = (String) device.get("DEVICE_NAME");
		box_id = (String) device.get("BOX_ID");
		device_type_id = (String) device.get("DEVICE_TYPE_ID");
		break_second = (Integer) device.get("BREAK_SECOND");
		device_num = (Integer) device.get("DEVICE_NUM");

	}

	//api发送给其它系统
	public void sendApi(Map<String, Object> data) throws IOException {
		try {
			ServerSocketListener.pushClient.sendMessage(makeApiData(data));
		} catch (Exception e) {
			e.printStackTrace();
			if (socket != null) {
				socket.close();
			}
		}
	}

	//组合数据
	//			字段	字段名	字段说明	举例
	//			device_id	设备编号	每一个采集器的唯一编号	T0001
	//			device_name	设备名称	采集器的别称	发电机1采集器
	//			register_id	探头类型	同一型号采集器的探头类型	HWWD：红外温度  ZDL：震动量
	//			record_time	采集时间	时间格式yyyy-MM-dd HH:mm:ss	2018-07-26 09:38:02
	//			record_data	采集数据	采集数据内容	27.5
	//			register_unit	数据单位	采集数据单位	°C
	//			level_id	预警级别	如果超过警戒点，根据设置的级别进行判断，如果没有预警此处传空	L1：一级预警L2：二级预警L3：三级预警
	//			举例：
	//			T0001&发电机1采集器&HWWD&2018-07-26 09:38:02&27.5&°C&L1
	//			T0001&发电机1采集器&HWWD&2018-07-26 09:38:02&27.5&°C&
	static public String makeApiData(Map<String, Object> data){
		StringBuffer senddata = new StringBuffer();
		senddata.append(data.get("DEVICE_ID") + "&");
		senddata.append(data.get("DEVICE_NAME") + "&");
		senddata.append(data.get("REGISTER_ID") + "&");
		senddata.append(data.get("RECORD_TIME") + "&");
		senddata.append(data.get("RECORD_DATA") + "&");
		senddata.append(data.get("REGISTER_UNIT") + "&");
		senddata.append(data.get("LEVEL_ID") + "\n");
		return senddata.toString();
	}
	
	public void run() {
		try {
			Map<String, Object> where = new HashMap<String, Object>();
			where.put("DEVICE_TYPE_ID", device_type_id);
			List<Map<String, Object>> deviceTypes = DB.seleteByKey("ELE_DEVICE_TYPE", where);
			if (deviceTypes.size() == 1) {
				protocol_id = (String) deviceTypes.get(0).get("PROTOCOL_ID");
			}
			where.put("REGISTER_BREAK", "true");
			List<Map<String, Object>> registers = DB.seleteByColumn("ELE_DEVICE_TYPE_REGISTER", where);
			while (true) {
				//父线程退出了，子线程也退出
				if (processSocketData.exit){
					break;
				}
				try {
					if (protocol_id.startsWith("MODBUS") && !registers.isEmpty()) {
						processMODBUSTCP(registers, protocol_id.endsWith("TCP"));
					} else if ("IEC104".equalsIgnoreCase(protocol_id)) {
						processIEC104(registers);
					} else {
						break;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				Thread.sleep(break_second * 1000);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("thread.exit "+this);
	}
	
	private void processIEC104(List<Map<String, Object>> registers) throws Exception {
		if (iec103tcp_init == false) {
			//子站和主站间TCP 连接建立后就开始了应用层的初始化过程,首先启动监听消息线程
			IEC103TCPThread thread = new IEC103TCPThread();
			thread.registers = registers;
			//thread.start();

			//主站可以先发ASDU20一般命令，子站响应ASDU5 返回设备标识（此步骤可选）
			IEC104APDU msg = new IEC104APDU();
			byte[] info = new byte[]{(byte) 255, 3, 0, 0};
			msg.asdu.build(0x14,0x81,0x14,device_num,info);
			processSocketData.sendMessage(msg);

//			召唤通用分类各组数据的属性,读一个组的描述ASDU21
			int[] kods = new int[]{2, 3, 5, 6, 7, 8, 9, 10};
			for (int g=0; g<1; g++){
				for (int kod : kods){
					msg = new IEC104APDU();
					info = new byte[]{(byte) 254,(byte) 241, 0, 1,(byte) g, 0x0,(byte) kod};
					msg.asdu.build(21,0x81,42,device_num,info);
					processSocketData.sendMessage(msg);
					Thread.sleep(1000);
				}
			}
			//主站发ASDU7 总查询以维护数据库的完整性

			iec103tcp_init = true;
		}else{
			for (Map<String, Object> register : registers) {
				IEC104APDU msg = new IEC104APDU();
				byte[] gin = Tools.hexStringToBytes((String) register.get("register_address"));
				byte[] info = new byte[]{(byte) 254,(byte) 241, 0, 1, gin[0], gin[1], 1};
				msg.asdu.build(21,0x81,42,device_num,info);
				processSocketData.sendMessage(msg);
			}
		}
	}
	
	private void processMODBUSTCP(List<Map<String, Object>> registers, boolean isTCP) throws Exception{
		for (Map<String, Object> register : registers) {
			String record_data = this.readMODBUSTCP(register, isTCP);
			checkWarning(register,record_data);
		}
	}
	
	public String readMODBUSTCP(Map<String, Object> register, boolean isTCP) throws Exception{
		String record_data = "";
		switch ((Integer) register.get("REGISTER_TYPE")) {
		case 1:
			ReadCoilsRequest readCoilsRequest = new ReadCoilsRequest();
			readCoilsRequest.setUnitID(device_num);
			readCoilsRequest.setReference((Integer) register.get("REGISTER_ADDRESS"));
			readCoilsRequest.setBitCount((Integer) register.get("REGISTER_LENGTH"));
			ReadCoilsResponse readCoilsResponse = (ReadCoilsResponse) processSocketData.sendMessage(readCoilsRequest, isTCP);
			BitVector readCoils = readCoilsResponse.getCoils();
			for (int i=0; i<readCoils.size(); i++){
				record_data += readCoils.getBit(i) + " ";
			}
			break;
		case 2:
			ReadInputDiscretesRequest readInputDiscretesRequest = new ReadInputDiscretesRequest();
			readInputDiscretesRequest.setUnitID(device_num);
			readInputDiscretesRequest.setReference((Integer) register.get("REGISTER_ADDRESS"));
			readInputDiscretesRequest.setBitCount((Integer) register.get("REGISTER_LENGTH"));
			ReadInputDiscretesResponse readInputDiscretesResponse = (ReadInputDiscretesResponse) processSocketData
					.sendMessage(readInputDiscretesRequest, isTCP);
			BitVector readInputDiscretes = readInputDiscretesResponse.getDiscretes();
			for (int i=0; i<readInputDiscretes.size(); i++){
				record_data += readInputDiscretes.getBit(i) + " ";
			}
			break;
		case 3:
			ReadMultipleRegistersRequest readMultipleRegistersRequest = new ReadMultipleRegistersRequest();
			readMultipleRegistersRequest.setUnitID(device_num);
			readMultipleRegistersRequest.setReference((Integer) register.get("REGISTER_ADDRESS"));
			readMultipleRegistersRequest.setWordCount((Integer) register.get("REGISTER_LENGTH"));
			ReadMultipleRegistersResponse readMultipleRegistersResponse = (ReadMultipleRegistersResponse) processSocketData
					.sendMessage(readMultipleRegistersRequest, isTCP);
			Register[] readMultipleRegisters = readMultipleRegistersResponse.getRegisters();
			for (Register outRegister:readMultipleRegisters){
				record_data += outRegister.getValue() + " ";
			}
			break;
		case 4:
			ReadInputRegistersRequest readInputRegistersRequest = new ReadInputRegistersRequest();
			readInputRegistersRequest.setUnitID(device_num);
			readInputRegistersRequest.setReference((Integer) register.get("REGISTER_ADDRESS"));
			readInputRegistersRequest.setWordCount((Integer) register.get("REGISTER_LENGTH"));
			ReadInputRegistersResponse readInputRegistersResponse = (ReadInputRegistersResponse) processSocketData
					.sendMessage(readInputRegistersRequest, isTCP);
			InputRegister[] readInputRegisters = readInputRegistersResponse.getRegisters();
			for (InputRegister outRegister:readInputRegisters){
				record_data += outRegister.getValue() + " ";
			}
			break;
		}
		return record_data;
	}

	public String writeMODBUSTCP(Map<String, Object> register, boolean isTCP) throws Exception{
		String record_data = "";
		String register_value = (String) register.get("REGISTER_VALUE");
		switch ((Integer) register.get("REGISTER_TYPE")) {
		case 1:
			WriteCoilRequest writeCoilRequest = new WriteCoilRequest();
			writeCoilRequest.setUnitID(device_num);
			writeCoilRequest.setReference((Integer) register.get("REGISTER_ADDRESS"));
			writeCoilRequest.setCoil(register_value.equalsIgnoreCase("ON"));
			WriteCoilResponse writeCoilResponse = (WriteCoilResponse) processSocketData.sendMessage(writeCoilRequest, isTCP);
			record_data = writeCoilResponse.getCoil()?"ON":"OFF";
			break;
		case 2:
			throw new Exception("不支持的寄存器类型!");
		case 3:
			WriteSingleRegisterRequest writeSingleRegisterRequest = new WriteSingleRegisterRequest();
			writeSingleRegisterRequest.setUnitID(device_num);
			writeSingleRegisterRequest.setReference((Integer) register.get("REGISTER_ADDRESS"));
			writeSingleRegisterRequest.setRegister(new SimpleRegister(Integer.parseInt(register_value)));
			WriteSingleRegisterResponse writeSingleRegisterResponse = (WriteSingleRegisterResponse) processSocketData
					.sendMessage(writeSingleRegisterRequest, isTCP);
			record_data = String.valueOf(writeSingleRegisterResponse.getRegisterValue());
			break;
		case 4:
			throw new Exception("不支持的寄存器类型!");
		}
		return record_data;
	}

	private void checkWarning(Map<String, Object> register, String record_data) throws Exception{
		//记录结果
		record_data = record_data.trim();
		//跳过无效数值
		if (!record_data.isEmpty() && !record_data.equals(register.get("REGISTER_ERR"))){
			Map<String, Object> data = new HashMap<String, Object>();
			data.put("DEVICE_ID", device_id);
			data.put("DEVICE_NAME", device_name);
			data.put("REGISTER_ID", register.get("REGISTER_ID"));
			data.put("REGISTER_UNIT", register.get("REGISTER_UNIT"));
			data.put("RECORD_TIME", Machine.getSystemDateTime().get("SystemDateTime"));
			String maxLevel = "";
			//预警
			try{
				//单一数值处理
				BigDecimal num_data = new BigDecimal(record_data);
				String register_multiply = (String) register.get("REGISTER_MULTIPLY");
				//num_data = register_multiply.multiply(num_data);//.multiply(new BigDecimal(RandomUtils.nextInt(1000)));

				//折算单位
				if (register_multiply != null && !register_multiply.isEmpty()) {
					Double num_out = (Double) jse.eval(register_multiply.replaceAll("X", record_data).replaceAll("x", record_data));
					num_data = new BigDecimal(num_out);
					num_data = num_data.setScale(4, BigDecimal.ROUND_HALF_UP);
					record_data = num_data.stripTrailingZeros().toPlainString();
				}

				data.put("RECORD_DATA", record_data);

				boolean warning = false;
				if (num_data.doubleValue() > (Integer) register.get("MONITOR_MAX")){
					data.put("WARNING_TYPE", "MONITOR_MAX");
					warning = true;
				}
				if (num_data.doubleValue() < (Integer) register.get("MONITOR_MIN")){
					data.put("WARNING_TYPE", "MONITOR_MIN");
					warning = true;
				}
				if (warning){
					data.putAll(register);
					WebSocketManager.SendMessage("ELE_WARNING", null, JsonUtil.object2json(data));
					maxLevel = sendWarning(data);
					warningTimeRecord.put((String) register.get("REGISTER_ID"), new Date());
				}else{
					warningTimeRecord.remove(register.get("REGISTER_ID"));
				}
			}catch(NumberFormatException e){

			}

			data.put("LEVEL_ID", maxLevel);
			data.put("RECORD_DATA", record_data);

			//api发送给其它系统
			sendApi(data);

			//记录数据库
			DB.insert("ELE_REGISTER_RECORD", data );
			WebSocketManager.SendMessage("ELE_DEV_" + device_id, null, JsonUtil.object2json(data));

		}
	}

	private String sendWarning(Map<String, Object> data) {
		List<Map<String, Object>> level_ids = checkWarningLevel(data);

		//判断最大的level
		String level = "";
		for (Map<String, Object> level_id : level_ids) {
			level = (String) level_id.get("LEVEL_ID");
			break;
		}

		try {
			if (level_ids.isEmpty()) return level;

			List<Map<String, Object>> treeDatas = DB.query("select concat('ARE_',area_id) as node_id, area_name as node_name, case when upper_area_id='' then '' else concat('ARE_',upper_area_id) end as upper_node_id from ele_area union "
					+ "select concat('BOX_',box_id), box_name,concat('ARE_',area_id) from ele_box union "
					+ "select concat('DEV_',device_id), device_name, concat('BOX_',box_id) from ele_device");
			String device_id = (String) data.get("DEVICE_ID");
			List<String> node_ids = getUpperNodeId(treeDatas, "DEV_"+device_id);
			if (node_ids.isEmpty()) return level;

			for (Map<String, Object> level_id : level_ids) {
				for (String node_id : node_ids) {
					Map<String, Object> where = new HashMap<String, Object>();
					where.put("NODE_ID", node_id);
					where.put("LEVEL_ID", level_id.get("LEVEL_ID"));
					List<Map<String, Object>> ele_warning_settings = DB.seleteByColumn("ELE_WARNING_SETTING", where);
					for (Map<String, Object> ele_warning_setting : ele_warning_settings) {
						String contact = (String) ele_warning_setting.get("CONTACT");
						String phone = (String) ele_warning_setting.get("PHONE");
						String email = (String) ele_warning_setting.get("EMAIL");
						data.putAll(level_id);
						String message = changeWarningMessage(data);

						boolean record = false;

						String register_id = (String) data.get("REGISTER_ID");
						if (!phone.isEmpty()) {
							long continue_time = Long.MAX_VALUE;
							if (sendTimeRecord.containsKey(register_id+"_SMS")){
								Date lastSendTime = sendTimeRecord.get(register_id+"_SMS");
								continue_time = ((new Date()).getTime() - lastSendTime.getTime())/60000;
							}
							if (continue_time >= Integer.parseInt(ElectricManager.getEleSetting("blank_sms"))) {
								MessageUtil.sendSms(phone, contact+"你好："+message);
								sendTimeRecord.put(register_id+"_SMS", new Date());
								record = true;
							}
						}
						if (!phone.isEmpty()){
							long continue_time = Long.MAX_VALUE;
							if (sendTimeRecord.containsKey(register_id+"_EMAIL")){
								Date lastSendTime = sendTimeRecord.get(register_id+"_EMAIL");
								continue_time = ((new Date()).getTime() - lastSendTime.getTime())/60000;
							}
							if (continue_time >= Integer.parseInt(ElectricManager.getEleSetting("blank_email"))) {
								MessageUtil.sendEmail(email, "电网检测云服务平台"+level_id.get("LEVEL_NAME"), contact+":<br>  你好,<br>  "+message);
								sendTimeRecord.put(register_id+"_EMAIL", new Date());
								record = true;
							}
						}

						if (record){
							data.put("LEVEL_ID", level_id.get("LEVEL_ID"));
							data.put("CONTACT", contact);
							DB.insert("ELE_WARNING_RECORD", data );
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return level;
	}
	
	private String changeWarningMessage(Map<String, Object> data) throws Exception {
		String message = "";
		List<Object> par = new ArrayList<Object>();
		par.add(device_id);
		List<Map<String, Object>> infos = DB.query("SELECT * from appdata.ele_area,appdata.ele_box,appdata.ele_device "
				+ "where ele_area.area_id=ele_box.area_id and ele_box.box_id=ele_device.box_id and ele_device.device_id=?", par);
		for (Map<String, Object> info : infos) {
			info.putAll(data);
			message += "在RECORD_TIME发生级别为LEVEL_NAME的警告，位于AREA_NAME的BOX_NAME所连接的DEVICE_NAME设备中REGISTER_NAME值为RECORD_DATAREGISTER_UNIT，正常范围为MONITOR_MINREGISTER_UNIT至MONITOR_MAXREGISTER_UNIT。";
			message = MessageUtil.replaceValue(message, info);
		}

		return message;
	}
	
	private List<String> getUpperNodeId(List<Map<String, Object>> treeDatas, String node_id){
		List<String> node_ids = new ArrayList<String>();
		if (!node_id.isEmpty()){
			node_ids.add(node_id);
			for (Map<String, Object> treeData : treeDatas) {
				if (node_id.equals(treeData.get("NODE_ID"))){
					String upper_node_id = (String) treeData.get("UPPER_NODE_ID");
					node_ids.addAll(getUpperNodeId(treeDatas, upper_node_id));
				}
			}
		}
		return node_ids;
	}
	
	private List<Map<String, Object>> checkWarningLevel(Map<String, Object> data){
		List<Map<String, Object>> re_data = new ArrayList<Map<String, Object>>();
		try {
			List<Map<String, Object>> levels = DB.seleteByColumn("ELE_WARNING_LEVEL", new HashMap());
			if (levels.isEmpty()) return re_data;

			double overflow_balance = 0;
			BigDecimal num_data = new BigDecimal((String)data.get("RECORD_DATA"));
			int monitor_min = (Integer) data.get("MONITOR_MIN");
			int monitor_max = (Integer) data.get("MONITOR_MAX");
			String warning_type = (String) data.get("WARNING_TYPE");
			if ("MONITOR_MIN".equals(warning_type)){
				overflow_balance = (monitor_min - num_data.doubleValue()) / (monitor_max - monitor_min) * 100;
			}else if ("MONITOR_MAX".equals(warning_type)){
				overflow_balance = (num_data.doubleValue() - monitor_max) / (monitor_max - monitor_min) * 100;
			}

			long continue_time = 0;
			if (warningTimeRecord.containsKey(data.get("REGISTER_ID"))){
				Date lastWarningTime = warningTimeRecord.get(data.get("REGISTER_ID"));
				continue_time = ((new Date()).getTime() - lastWarningTime.getTime())/1000;
			}

			for (Map<String, Object> level : levels) {
				if (continue_time >= (Integer)level.get("CONTINUE_TIME") && overflow_balance >= (Integer)level.get("OVERFLOW_BALANCE")){
					re_data.add(level);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return re_data;
	}

	class IEC103TCPThread extends Thread {
		public List<Map<String, Object>> registers;
		private Map<String, Map<String, Object>> ginRegMap = new HashMap<String, Map<String, Object>>();

		public void run() {
			//将registers转变为以register_address做KEY代表GIN
			for (Map<String, Object> register : registers) {
				ginRegMap.put((String) register.get("register_address"), register);
			}

			while (true) {
				try {
					IEC104APDU apdu = processSocketData.getMessage();
					//子站响应ASDU5 返回设备标识

					//子站进行相应回答通用分类各组数据的属性
					if (apdu.asdu.dui.typ == 10) {
						byte[] io = apdu.asdu.io;
						int index = 0;
						index += 3;
						int ngd = io[index];
						Map<String, Object> data = new HashMap<String, Object>();
						data.put("device_type_id", device_type_id);
						DB.delete("ele_device_type_gin", data);
						for (int i = 0; i < ngd; i++) {
							byte g = io[++index];
							byte n = io[++index];
							String gin = Tools.bytesToHexString(new byte[]{g, n});
							int kod = io[++index];
							int datatype = io[++index];
							int datasize = io[++index];
							int number = new Byte((byte) (io[++index] & 0x7F));
							boolean cont = new Boolean(((io[index] & 0x80) >> 7) != 0);
							String gid = "";
							for (int num = 0; num < number; num++) {
								gid += IECTools.gidToString(Arrays.copyOfRange(io, ++index, datasize), datatype) + ";";
							}
							data.put("gin", gin);
							data.put("kod", kod);
							data.put("gid", gid);
							DB.insert("ele_device_type_gin", data);

							//实际值的记录
							if (kod == 1) {
								checkWarning(ginRegMap.get(gin), gid);
							}
						}
					}

					//装置响应各种实时测量数据（状态量、测量量、压板等）
				} catch (SocketException e) {
					e.printStackTrace();
					break;
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
}
