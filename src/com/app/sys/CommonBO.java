package com.app.sys;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.snaker.engine.SnakerEngine;
import org.snaker.engine.entity.Order;

import com.app.snaker.SnakerHelper;
import com.app.utility.Machine;
import com.ibm.json.java.JSONArray;
import com.ibm.json.java.JSONObject;

public class CommonBO {
	public static Map<String, Object> common(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		
		String tableName = (String) map.get("TABLE");
		String subTableName = (String) map.get("SUBTABLE");
		
		for (String key : map.keySet()){
			Object data = map.get(key);
			if (data instanceof String){
				if (((String) data).startsWith("UUID")){
					map.put(key, UUID.randomUUID().toString());
				}else if (((String) data).startsWith("TIME")){
					map.put(key, Machine.getSystemDateTime().get("SystemDateTime"));
				}
			}
		}
		
		//获取主表的主键数据
		List<String> mainkey = DB.getKey(tableName);
		Map<String, Object> mainKeyData = new HashMap<String, Object>();
		for (String key:mainkey){
			if (map.containsKey(key)){
				mainKeyData.put(key, map.get(key));
			}
		}
		
		//获取主表的数据
		Map<String, Integer> maincol = DB.getColumn(tableName);
		Map<String, Object> mainData = new HashMap<String, Object>();
		for (String key:maincol.keySet()){
			if (map.containsKey(key)){
				mainData.put(key, map.get(key));
			}
		}
		
		//获取子表的数据
		boolean contianSubData = false;
		List<Map<String,Object>> multiData = new ArrayList<Map<String,Object>>();
		if (map.containsKey("SUBDATA")){
			contianSubData = true;
			String subdata = (String) map.get("SUBDATA");
			JSONArray array = JSONArray.parse(subdata);
			for (int i=0; i<array.size(); i++){
				JSONObject jo = (JSONObject) array.get(i);
				Map<String, Object> insertmap = new HashMap<String, Object>();
				Iterator it = jo.keySet().iterator();
				while(it.hasNext()){
					String key = (String) it.next();
					insertmap.put(key, jo.get(key));
				}
				insertmap.putAll(mainKeyData);
				multiData.add(insertmap);
			}
		}		
		
		String actions[] = action.split("\\|");
		
		for (String act: actions){
			if (act.equals("add")){
				DB.insert(tableName, mainData);
				if (contianSubData){
					DB.insert(subTableName, multiData);
				}
			}else if (act.equals("delete")){
				DB.delete(tableName, mainData);
				if (contianSubData){
					DB.delete(subTableName, mainKeyData);
				}
			}else if (act.equals("modify")){
				DB.update(tableName, mainData);
				if (contianSubData){
					DB.delete(subTableName, mainKeyData);
					DB.insert(subTableName, multiData);
				}
			}else if (act.equals("select")){
				returnmap.put("Rows", DB.seleteByColumn(tableName, mainData));
				return returnmap;
			}else if (act.equals("select-key")){
				returnmap.put("Rows", DB.seleteByKey(tableName, mainData));
				return returnmap;
			}else if (act.equals("select-all")){
				returnmap.put("Rows", DB.seleteByColumn(tableName,new HashMap()));		
				return returnmap;
			}else if (act.equals("select-page")){
				String wheresql = (String)map.get("where");
				wheresql = changeWhereToSQL(wheresql);
				returnmap.put("Rows", DB.seleteByColumn(tableName,new HashMap(),"*"
						,(String)map.get("pagesize"),(String)map.get("page"),(String)map.get("sortname"),(String)map.get("sortorder"),wheresql));	
				Map<String, Object> mapdata = (Map<String, Object>) DB.seleteByColumn(tableName,new HashMap(),"COUNT(*) ROWCOUNT",wheresql,null, null, null).get(0);
				returnmap.put("Total", mapdata.get("ROWCOUNT"));
				return returnmap;
			}else if (act.equals("select-sub")){
				returnmap.put("Rows", DB.seleteByColumn(subTableName, mainKeyData));		
				return returnmap;
			}else if (act.equals("select-sub-key")){
				returnmap.put("Rows", DB.seleteByKey(subTableName, mainKeyData));		
				return returnmap;
			}else if (act.equals("start-process")){
//				ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
//				RuntimeService runtimeService = processEngine.getRuntimeService();
				SnakerEngine engine = SnakerHelper.getEngine();
				String id = (String) map.get("PROKEY");
				String operator = (String) map.get("PRINCIPAL");
//			    ProcessInstance processInstance = runtimeService.startProcessInstanceByKey(processDefinitionKey, map);
				Order order = engine.startInstanceById(id, operator, mainKeyData);
				returnmap.put("OrderNo", order.getOrderNo());
			}
		}
		
		return returnmap;		
	}	
	
	//转换高级查询的where条件
	public static String changeWhereToSQL(String where) throws Exception{
		if (where == null) return where;
		Map<String, Object> map = JSONObject.parse(where);
		String sqlWhere = subChange(map);
		return sqlWhere;
	}
	
	private static String subChange(Map<String, Object> map){
		String sql = "";
		String op = (String) map.get("op");
		List<Map<String, Object>> rules = (List<Map<String, Object>>) map.get("rules");
		for (Map<String, Object> rule: rules){
			sql += " " + op + " " + rule.get("field");
			String c = "";
			if (rule.get("type").equals("string") || rule.get("type").equals("text")){
				c = "'";		
			}
			String value = (String) rule.get("value");
			if (rule.get("op").equals("equal")){
				sql += " = " + c + value + c;
			}else if (rule.get("op").equals("notequal")){
				sql += " != " + c + value + c;
			}else if (rule.get("op").equals("greater")){
				sql += " > " + c + value + c;
			}else if (rule.get("op").equals("greaterorequal")){
				sql += " >= " + c + value + c;
			}else if (rule.get("op").equals("less")){
				sql += " < " + c + value + c;
			}else if (rule.get("op").equals("lessorequal")){
				sql += " <= " + c + value + c;
			}else if (rule.get("op").equals("like")){
				sql += " like " + c +"%"+ value +"%"+ c;
			}else if (rule.get("op").equals("startwith")){
				sql += " like " + c + value +"%"+ c;
			}else if (rule.get("op").equals("endwith")){
				sql += " like " + c +"%"+ value + c;
			}else if (rule.get("op").equals("in")){
				String[] values = value.split(",");
				String pv = "";
				for (String v: values){
					pv += c + v + c + ",";
				}
				if (pv.endsWith(",")) pv = pv.substring(0, pv.length()-1);
				sql += " in ("+pv+")";
			}else if (rule.get("op").equals("notin")){
				String[] values = value.split(",");
				String pv = "";
				for (String v: values){
					pv += "," + c + v + c;
				}
				if (pv.startsWith(",")) pv = pv.substring(1, pv.length());
				sql += " not in ("+pv+")";
			}
		}
		if (map.containsKey("groups")){
			List<Map<String, Object>> groups = (List<Map<String, Object>>) map.get("groups");
			for (Map<String, Object> group : groups){
				sql += " " + op + " (" + subChange(group) + ")";
			}			
		}
		if (sql.startsWith(" " + op + " ")) sql = sql.substring((" " + op + " ").length(), sql.length());		
		return sql;
	}
}
