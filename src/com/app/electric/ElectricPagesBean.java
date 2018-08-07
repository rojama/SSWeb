package com.app.electric;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.wimpi.modbus.ModbusIOException;
import net.wimpi.modbus.msg.ReadCoilsRequest;
import net.wimpi.modbus.msg.ReadCoilsResponse;
import net.wimpi.modbus.msg.ReadInputDiscretesRequest;
import net.wimpi.modbus.msg.ReadInputDiscretesResponse;
import net.wimpi.modbus.msg.ReadInputRegistersRequest;
import net.wimpi.modbus.msg.ReadInputRegistersResponse;
import net.wimpi.modbus.msg.ReadMultipleRegistersRequest;
import net.wimpi.modbus.msg.ReadMultipleRegistersResponse;
import net.wimpi.modbus.msg.WriteCoilRequest;
import net.wimpi.modbus.msg.WriteCoilResponse;
import net.wimpi.modbus.msg.WriteSingleRegisterRequest;
import net.wimpi.modbus.msg.WriteSingleRegisterResponse;
import net.wimpi.modbus.procimg.InputRegister;
import net.wimpi.modbus.procimg.Register;
import net.wimpi.modbus.procimg.SimpleRegister;
import net.wimpi.modbus.util.BitVector;

import org.apache.shiro.session.Session;

import com.app.sys.CommonBO;
import com.app.sys.DB;
import com.app.utility.Machine;

public class ElectricPagesBean {
	
	public Object select(Map<String, Object> map) throws Exception
	{
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		if (action.equals("area-tree")){
			String icon = "../../images/icons/some/world.png";
			return DB.query("select area_id as node_id, area_name as node_name, upper_area_id as upper_node_id , '"+icon+"' as icon from ele_area");
		}else if (action.equals("box-list")){
			return DB.seleteByColumn("ELE_BOX", new HashMap());
		}else if (action.equals("device-type-list")){
			return DB.seleteByColumn("ELE_DEVICE_TYPE", new HashMap());
		}else if (action.equals("warning-level-list")){
			return DB.seleteByColumn("ELE_WARNING_LEVEL", new HashMap());
		}else if (action.equals("ins-tree")){
			String icon = "../../images/icons/some/house.png";
			return DB.query("select INS_ID as node_id, INS_CODE as node_value, INS_NAME as node_name, INS_SUPER_ID as upper_node_id , '"+icon+"' as icon from aut_institution");
		}
		return null;
	}
	
	public Map<String, Object> ele_box(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		map.put("TABLE", "ELE_BOX");
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		
		returnmap = CommonBO.common(map);
		
		if (action.equals("add") || action.equals("modify")){
			ElectricManager.ReflashBox();
		}else if (action.equals("refresh")){
			ElectricManager.ReflashDevice((String)map.get("BOX_ID"), true);
		}
		return returnmap;
	}
	
	public Map<String, Object> monitor(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		
		if (action.equals("select-menu")){
			
			String area = "../../images/icons/some/world.png";
			String box = "../../images/icons/some/box.png";
			String device = "../../images/icons/some/drive.png";
			List<Map<String, Object>> treeDatas = DB.query("select concat('ARE_',area_id) as node_id, area_name as node_name, case when upper_area_id='' then '' else concat('ARE_',upper_area_id) end as upper_node_id , '"+area+"' as icon, ins_code from ele_area union "
					+ "select concat('BOX_',box_id), box_name,concat('ARE_',area_id) , '"+box+"' as icon, '' from ele_box union "
					+ "select concat('DEV_',device_id), device_name, concat('BOX_',box_id) , '"+device+"' as icon, '' from ele_device");
						
			Session session= (Session) map.get("SESSION");
			List<String> ins_codes = (List<String>) session.getAttribute("INS_CODE");			
			treeDatas = filterAreaByInsCodes(treeDatas, ins_codes);
			
			returnmap.put("Rows", treeDatas);	
			return returnmap;
		}else if (action.equals("select-device")){
			String node_id = (String) map.get("NODE_ID");
			List<Object> par = new ArrayList<Object>();
			par.add(node_id.substring(4));
			if (node_id.startsWith("ARE_")){
				returnmap.put("Rows", DB.query("select * from ele_area, ele_box, ele_device, ele_device_type where ele_area.area_id=ele_box.area_id and ele_box.box_id =ele_device.box_id and ele_device_type.device_type_id=ele_device.device_type_id and ele_area.area_id = ?", par));
			}else if (node_id.startsWith("BOX_")){
				returnmap.put("Rows", DB.query("select * from ele_area, ele_box, ele_device, ele_device_type where ele_area.area_id=ele_box.area_id and ele_box.box_id =ele_device.box_id and ele_device_type.device_type_id=ele_device.device_type_id and ele_box.box_id = ?", par));
			}else if (node_id.startsWith("DEV_")){
				returnmap.put("Rows", DB.query("select * from ele_area, ele_box, ele_device, ele_device_type where ele_area.area_id=ele_box.area_id and ele_box.box_id =ele_device.box_id and ele_device_type.device_type_id=ele_device.device_type_id and ele_device.device_id = ?", par));
			}
			for (Map<String, Object> row : (List<Map<String, Object>>) returnmap.get("Rows")){
				Map<String, Object> where = new HashMap<String, Object>();
				where.put("DEVICE_TYPE_ID", row.get("DEVICE_TYPE_ID"));
				where.put("REGISTER_BREAK", "true");
				List<Map<String, Object>> registers = DB.seleteByColumn("ELE_DEVICE_TYPE_REGISTER", where);
				row.put("ELE_DEVICE_TYPE_REGISTER", registers);
			}
			return returnmap;
		} 
		return returnmap;
	}
	
	private List<Map<String, Object>> filterAreaByInsCodes(List<Map<String, Object>> area_data, List<String> ins_codes)
	{
		List<Map<String, Object>> returnMap = new ArrayList<Map<String, Object>>();
		for (Map<String, Object> data:area_data){	
			boolean has = false;
			String node_id = (String) data.get("NODE_ID");
			for (String ins_code:ins_codes){
				has |= checkNode(true, area_data, node_id, ins_code) ||
						checkNode(false, area_data, node_id, ins_code);
			}
			if (has){
				returnMap.add(data);
			}
		}
		
		return returnMap;
		
	}
	
	private boolean checkNode(boolean up, List<Map<String, Object>> area_data, String node_id, String ins_code){
		if (up){
			boolean has = false;
			for (Map<String, Object> data:area_data){				
				if (data.get("NODE_ID").equals(node_id)){
					has |= data.get("INS_CODE").equals(ins_code) || checkNode(up,area_data,(String)data.get("UPPER_NODE_ID"),ins_code);
				}				
			}
			return has;			
		}else{
			boolean has = false;
			for (Map<String, Object> data:area_data){				
				if (data.get("UPPER_NODE_ID").equals(node_id)){
					has |= data.get("INS_CODE").equals(ins_code) || checkNode(up,area_data,(String)data.get("NODE_ID"),ins_code);
				}				
			}
			return has;
		}
	}
	
	public Map<String, Object> templet(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		if (action.equals("get-top-record")){
			List<Map<String, Object>> datas = DB.seleteByColumn("ELE_REGISTER_RECORD", map, "RECORD_TIME,RECORD_DATA", ElectricManager.getEleSetting("point_count"), "1", "RECORD_TIME", "DESC", "");
			for (Map<String, Object> data:datas){
				Date date = Machine.formatdatetime.parse((String) data.get("RECORD_TIME"));
				data.put("x", date.getTime());
				String value = (String) data.get("RECORD_DATA");
				data.put("y", Double.parseDouble(value));
			}
			Collections.reverse(datas);
			returnmap.put("Rows", datas);
		}
		
		return returnmap;
	}
	
	public Map<String, Object> ele_warning_setting(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		map.put("TABLE", "ELE_WARNING_SETTING");
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		if (action.equals("select-menu")){
			returnmap = this.monitor(map);
		}else if (action.equals("select")){
			returnmap = CommonBO.common(map);
		}else {
			CommonBO.common(map);
			map.remove("CONTACT");
			map.remove("PHONE");
			map.remove("EMAIL");
			map.put("ACTION", "select");
			returnmap = CommonBO.common(map);
		}		
		return returnmap;
	}
	
	public Map<String, Object> ele_register(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		if (action.equals("select-menu")){
			returnmap = this.monitor(map);
		}else if (action.equals("select")){
			String node_id = (String) map.get("NODE_ID");
			List<Object> par = new ArrayList<Object>();
			par.add(node_id.substring(4));
			if (node_id.startsWith("ARE_")){
				returnmap.put("Rows", DB.query("select * from ele_area, ele_box, ele_device, ele_device_type, ele_device_type_register where ele_area.area_id=ele_box.area_id and ele_box.box_id =ele_device.box_id and ele_device_type.device_type_id=ele_device.device_type_id and ele_device.device_type_id=ele_device_type_register.device_type_id and ele_area.area_id = ?", par));
			}else if (node_id.startsWith("BOX_")){
				returnmap.put("Rows", DB.query("select * from ele_area, ele_box, ele_device, ele_device_type, ele_device_type_register where ele_area.area_id=ele_box.area_id and ele_box.box_id =ele_device.box_id and ele_device_type.device_type_id=ele_device.device_type_id and ele_device.device_type_id=ele_device_type_register.device_type_id and ele_box.box_id = ?", par));
			}else if (node_id.startsWith("DEV_")){
				returnmap.put("Rows", DB.query("select * from ele_area, ele_box, ele_device, ele_device_type, ele_device_type_register where ele_area.area_id=ele_box.area_id and ele_box.box_id =ele_device.box_id and ele_device_type.device_type_id=ele_device.device_type_id and ele_device.device_type_id=ele_device_type_register.device_type_id and ele_device.device_id = ?", par));
			}			
		}else if (action.equals("read") || action.equals("write")){
			BoxThread processSocketData = ElectricManager.boxsSockets.get(map.get("BOX_ID"));
			if (processSocketData == null){
				throw new Exception("盒子未连接!");
			}
			DevicesThread devicesThread = processSocketData.devicesThreads.get(map.get("DEVICE_ID"));
			if (devicesThread == null){
				throw new Exception("设备未连接!");
			}
			String record_data = "";
			Map<String, Object> where = new HashMap<String, Object>();
			where.put("DEVICE_TYPE_ID", map.get("DEVICE_TYPE_ID"));
			where.put("REGISTER_ID", map.get("REGISTER_ID"));
			List<Map<String, Object>> registers = DB.seleteByColumn("ELE_DEVICE_TYPE_REGISTER", where);			
			for (Map<String, Object> register : registers) {
				register.put("REGISTER_VALUE", map.get("REGISTER_VALUE"));
				if ("MODBUS".equalsIgnoreCase((String)map.get("PROTOCOL_ID"))) {
					if (action.equals("read")){
						record_data = devicesThread.readMODBUSTCP(register);
					}else if (action.equals("write")){
						record_data = devicesThread.writeMODBUSTCP(register);	
					}									
				} else {
					break;
				}				
			}
			returnmap.put("RECORD_DATA", record_data);
		}		
		return returnmap;
	}
	
}
