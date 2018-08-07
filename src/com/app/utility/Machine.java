package com.app.utility;

import java.io.InputStream;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * 获取系统日期与时间
 * 
 * @author HuangKai
 * 
 */
public class Machine {
	//当前日期 yyyymmdd
	public static final String SYSTEM_DATE = "SystemDate";
	//当前时间 hhmmss
	public static final String SYSTEM_TIME = "SystemTime";
	//当前具体时间  yyyy-mm-dd hh:mm:ss
	public static final String SYSTEM_DATETIME = "SystemDateTime";
	
	public static SimpleDateFormat formatdate=new SimpleDateFormat("yyyyMMdd");
	public static SimpleDateFormat formattime=new SimpleDateFormat("HHmmss");
	public static SimpleDateFormat formatdatetime=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	public static String getDate(){
		return getSystemDateTime().get(SYSTEM_DATE);
	}
	public static String getTime(){
		return getSystemDateTime().get(SYSTEM_TIME);
	}
	public static String getDateTime(){
		return getSystemDateTime().get(SYSTEM_DATETIME);
	}
	
	/**
	 * 获取系统日期与时间
	 * 
	 * @return SystemDate 系统日期，SystemTime 系统时间
	 * 
	 */
	public static Map<String,String> getSystemDateTime() {
		String str_SystemDate, str_SystemTime, str_month, str_date;
		Map<String,String> htl_SystemDateTime = new HashMap<String,String>();

		Calendar obj_Calendar = Calendar.getInstance();

		/* 取得系統日期 格式: yyyymmdd */
		if ((obj_Calendar.get(Calendar.MONTH) + 1) < 10) {
			str_month = "0" + (obj_Calendar.get(Calendar.MONTH) + 1);
		} else {
			str_month = String.valueOf(obj_Calendar.get(Calendar.MONTH) + 1);
		}

		if (obj_Calendar.get(Calendar.DATE) < 10) {
			str_date = "0" + obj_Calendar.get(Calendar.DATE);
		} else {
			str_date = String.valueOf(obj_Calendar.get(Calendar.DATE));
		}

		str_SystemDate = obj_Calendar.get(Calendar.YEAR) + str_month + str_date;

		/* 取得系統時間 格式(24小時進制): hhmmss */
		String str_hour, str_minute, str_second;
		if (obj_Calendar.get(Calendar.HOUR) < 10
				&& obj_Calendar.get(Calendar.AM_PM) == Calendar.AM) {
			str_hour = "0" + obj_Calendar.get(Calendar.HOUR);
		} else if (obj_Calendar.get(Calendar.AM_PM) == Calendar.PM) {
			str_hour = String.valueOf(obj_Calendar.get(Calendar.HOUR) + 12);
		} else {
			str_hour = String.valueOf(obj_Calendar.get(Calendar.HOUR));
		}

		if (obj_Calendar.get(Calendar.MINUTE) < 10) {
			str_minute = "0" + obj_Calendar.get(Calendar.MINUTE);
		} else {
			str_minute = String.valueOf(obj_Calendar.get(Calendar.MINUTE));
		}

		if (obj_Calendar.get(Calendar.SECOND) < 10) {
			str_second = "0" + obj_Calendar.get(Calendar.SECOND);
		} else {
			str_second = String.valueOf(obj_Calendar.get(Calendar.SECOND));
		}

		str_SystemTime = str_hour + str_minute + str_second;

		htl_SystemDateTime.put(SYSTEM_DATE, str_SystemDate);
		htl_SystemDateTime.put(SYSTEM_TIME, str_SystemTime);

		String SystemDateTime = obj_Calendar.get(Calendar.YEAR) + "-"
				+ str_month + "-" + str_date + " ";

		SystemDateTime += str_hour + ":" + str_minute + ":" + str_second;

		htl_SystemDateTime.put(SYSTEM_DATETIME, SystemDateTime);

		return htl_SystemDateTime;
	}
	public static void main(String[] args){
		try {
			System.out.println(getDate());
			System.out.println(getTime());
			System.out.println(getDateTime());
			System.out.println(getPropertie("jdbc.name"));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	public static HashMap putValue(Object inputClass) throws Exception{
		HashMap subdata = new HashMap();
		Method[] methods = inputClass.getClass().getMethods();
		for (Method met : methods){
			String methodName = met.getName();			
			if (methodName.startsWith("get") && !methodName.equals("getClass")){
//				System.out.println("putValue methodName:"+methodName);
				if (methodName.length()<=3) continue;
				String valueName = lowerFirstChar(methodName.substring(3));
				Object value = null;
				Class<?> rt = met.getReturnType();
				value = met.invoke(inputClass, new Object[0]);
				if (value != null){
					if (rt == BigDecimal.class){
						value = ((BigDecimal) value).doubleValue();
					}else if (rt == Long.class){
						value = ((Long) value).intValue();
					}		
				}
				subdata.put(valueName, value);
			}			
		}
		return subdata;
	}
	
	//首字母大写
	public static String upperFirstChar(String value){
		return String.valueOf(value.charAt(0)).toUpperCase()+value.substring(1);
	}
	
	//首字母小写
	public static String lowerFirstChar(String value){
		return String.valueOf(value.charAt(0)).toLowerCase()+value.substring(1);
	}
	
	//读取配置
	public static String getPropertie(String key) throws Exception{
		Properties prop = new Properties();   
        InputStream in = Machine.class.getResourceAsStream("/setting.properties");   
        prop.load(in);
        return prop.getProperty(key).trim();
	}
	
	//合并多个数组
	public static byte[] concatAll(byte[] first, byte[]... rest) {
		int totalLength = first.length;
		for (byte[] array : rest) {
			totalLength += array.length;
		}
		byte[] result = Arrays.copyOf(first, totalLength);
		int offset = first.length;
		for (byte[] array : rest) {
			System.arraycopy(array, 0, result, offset, array.length);
			offset += array.length;
		}
		return result;
	}
	
}
