package com.app.electric;

import java.net.Socket;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.app.sys.DB;

public class ElectricManager {
	public static Map<String, BoxThread> boxsSockets = new HashMap<String, BoxThread>(); // key
																							// box_id

	/**
	 * 刷新盒子监听端口
	 * 
	 * @throws Exception
	 */
	public static void ReflashBox() throws Exception {
		ServerSocketListener.processBox();
	}

	/**
	 * 刷新盒子连接的设备
	 * 
	 * @param box_id
	 * @param disconnect
	 * @throws Exception
	 */
	public static void ReflashDevice(String box_id, boolean disconnect) throws Exception {
		if (boxsSockets.containsKey(box_id)) {
			if (disconnect) {
				boxsSockets.get(box_id).close();
			} else {
				boxsSockets.get(box_id).ProcessDevices();
			}
		}
	}
	
	public static String getEleSetting(String setting_id) throws Exception{
		String setting_value = "";
		Map<String, Object> where = new HashMap<String, Object>();
		where.put("SETTING_ID", setting_id);
		List<Map<String, Object>> settings = DB.seleteByKey("ELE_SETTING", where);
		if (settings.size() == 1) {
			setting_value = (String) settings.get(0).get("SETTING_VALUE");
		}
		return setting_value;
	}

}
