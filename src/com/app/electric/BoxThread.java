package com.app.electric;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectOutputStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import com.app.electric.iecrole.IEC104APDU;
import com.app.sys.DB;

import com.app.utility.DataTypeChangeHelper;
import net.wimpi.modbus.ModbusIOException;
import net.wimpi.modbus.io.ModbusTransport;
import net.wimpi.modbus.msg.ModbusMessage;
import net.wimpi.modbus.msg.ModbusResponse;
import net.wimpi.modbus.net.*;

public class BoxThread extends Thread {
	public Socket socket;
	public String boxID;
	public String boxName;
	private ModbusTransport mt;
	public volatile boolean exit = false; 
	public Map<String, DevicesThread> devicesThreads = new HashMap<String, DevicesThread>(); // key device_id
	public BoxThread() {
		super();
	}

	public BoxThread(Socket socket) {
		this.socket = socket;
	}
	
	public void close(){
		try {
			System.out.println("Preper to close BOX:"+boxID);
			if (this.equals(ElectricManager.boxsSockets.get(boxID))){
				ElectricManager.boxsSockets.remove(boxID);
				System.out.println("ElectricManager.boxsSockets.remove(BoxID);"+boxID+this);
			}			
			this.exit = true;
			this.socket.close();
			System.out.println("Closed BOX:"+boxID);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void run() {
		int connect_port = socket.getLocalPort();
		System.out.println("Client connection accepted");
		System.out.println("Reading box_num...");
		String box_num ="";
		try {
			// 获取盒子编号，要求配置盒子连接后首先发送盒子编号
			byte[] b = new byte[6];
			socket.setSoTimeout(10000);
			int len = socket.getInputStream().read(b);

            System.out.println("Read Box data:"+DataTypeChangeHelper.bytesToHexString(b));

			if (len == 4) {  // 自定义数字，带校验
				if (b[0] == ~b[2] && b[1] == ~b[3]) {
					box_num = String.valueOf(((b[0] & 0xFF) << 8) | (b[1] & 0xFF));
				}
			}else if (len == 6) {  // Mac 地址
				box_num = DataTypeChangeHelper.bytesToHexString(b);
				box_num = box_num.substring(8,12); //只判断后4位
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Read box_num timed out");
		}
		try {
			// 根据盒子连接的服务器端口以及盒子编号来定位盒子
			System.out.println("Client connection accepted from " + socket.getInetAddress() + ":" + socket.getPort() + " - " + box_num + " to "
					+ socket.getLocalAddress() + ":" + connect_port);
			Map<String, Object> where = new HashMap<String, Object>();
			where.put("CONNECT_PORT", connect_port);
			where.put("BOX_NUM", box_num);
			List<Map<String, Object>> datas = DB.seleteByColumn("ELE_BOX", where);
			if (datas.size() == 1) {
				boxID = (String) datas.get(0).get("BOX_ID");
				boxName = (String) datas.get(0).get("BOX_NAME");
				if (ElectricManager.boxsSockets.containsKey(boxID)){
					System.out.println("Client box "+boxID+" already connect");
					//表示上一个连接已经失效，重新连接，所以盒子编号不能设置为一样的，防止两个盒子互相抢资源
					ElectricManager.ReflashDevice(boxID, true);
				}
				ElectricManager.boxsSockets.put(boxID, this);
				System.out.println("ElectricManager.boxsSockets.put(BoxID, this);"+boxID+this);
				ProcessDevices();
			} else {
				System.err.println("Client box_num can't recognize");
				Thread.sleep(60000);
				this.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("thread.exit "+this);		
	}

	// 按盒子连接的设备分别启动设备线程来发起请求
	public void ProcessDevices() throws Exception {
		for (String key:devicesThreads.keySet()){
			if (!devicesThreads.get(key).isAlive()){
				devicesThreads.remove(key);
			}
		}
		Map<String, Object> where = new HashMap<String, Object>();
		where.put("BOX_ID", boxID);
		List<Map<String, Object>> devices = DB.seleteByColumn("ELE_DEVICE", where);
		for (Map<String, Object> device : devices) {
			if (exit) break;
			String device_id = (String) device.get("DEVICE_ID");
			if (!devicesThreads.containsKey(device_id)){
				DevicesThread dt = new DevicesThread(this, device);
				devicesThreads.put(device_id, dt);
				dt.start();
			}
		}
	}	

	// 盒子连接是半双工的需要排队发送数据(MODBUS TCP)
	public synchronized ModbusResponse sendMessage(ModbusMessage msg) throws Exception {
		if (mt == null){
			TCPSlaveConnection tc = new TCPSlaveConnection(socket);
			mt = tc.getModbusTransport();
		}
		try {
			mt.writeMessage(msg);
		} catch (ModbusIOException e) {  //无法写数据，表示盒子已经断开连接，需要关闭盒子进程
			e.printStackTrace();
			this.close();
		}
		return mt.readResponse();
	}
	
	private short ack, send, recv;
	
	// 发送数据(IEC104TCP)
	public synchronized void sendMessage(IEC104APDU msg) throws Exception {
//		ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
		msg.apci.setCount(send++, recv);
//		oos.writeObject(msg.code());
		socket.setSoTimeout(10000);
		socket.getOutputStream().write(msg.code());
		socket.getOutputStream().flush();
	}
	
	//接收数据(IEC104TCP)
	public synchronized IEC104APDU getMessage() throws Exception {
		int b ;
		InputStream ip = socket.getInputStream();
		socket.setSoTimeout(0);
		while((b = ip.read()) != -1){
			if (b == 0x68){
				socket.setSoTimeout(10000);
				int len = ip.read();
				if (len == -1){
					socket.setSoTimeout(0);
					continue;
				}
				byte[] msg = new byte[len];
				msg[0] = 0x68;
				msg[1] = (byte) len;				
				int i = ip.read(msg, 2, len-2);
				if (i == -1){
					socket.setSoTimeout(0);
					continue;
				}
				IEC104APDU apdu = new IEC104APDU();
				apdu.decode(msg);
				
				recv ++;
				
				return apdu;
			}
		}
		return null;
	}
}
