package com.app.snaker;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.session.Session;
import org.snaker.engine.SnakerEngine;
import org.snaker.engine.access.QueryFilter;
import org.snaker.engine.access.transaction.TransactionInterceptor;
import org.snaker.engine.entity.HistoryOrder;
import org.snaker.engine.entity.HistoryTask;
import org.snaker.engine.entity.Order;
import org.snaker.engine.entity.Process;
import org.snaker.engine.entity.Task;
import org.snaker.engine.helper.AssertHelper;
import org.snaker.engine.helper.StreamHelper;
import org.snaker.engine.helper.StringHelper;
import org.snaker.engine.model.ProcessModel;

import com.app.utility.Machine;

public class SnakerServer {
	public Map<String, Object> process(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		
		String user = (String) map.get("PRINCIPAL");
		
		SnakerEngine engine = SnakerHelper.getEngine();
		
		if (action.equals("delete")){
			engine.process().undeploy((String) map.get("processId"));
		}else if (action.equals("save-flow")){
			String model = (String) map.get("model");
			String xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n" + SnakerHelper.convertXml(model);
			engine.process().deploy(StreamHelper.getStreamFromString(xml));
		}else if (action.equals("get-flow")){
			String processId = (String) map.get("process");			
			if(!"null".equals(processId) && StringUtils.isNotEmpty(processId)) {
				Process process = engine.process().getProcessById(processId);
				AssertHelper.notNull(process);
				ProcessModel processModel = process.getModel();
				if(processModel != null) {
					String json = SnakerHelper.getModelJson(processModel);
					returnmap.put("content", json);
				}
				returnmap.put("processId", processId);
			}
			return returnmap;
		}else if (action.equals("start")){
			engine.startInstanceById((String) map.get("processId"),user);
		}
		
		List<Process> list = engine.process().getProcesss(new QueryFilter().setState(1));	    
	    List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
		for (Process process : list) {
			Map<String, Object> taskmap = Machine.putValue(process);
			rows.add(taskmap);
		}
	    
	    returnmap.put("Rows",rows);
		return returnmap;
	}
	
	
	public Map<String, Object> task(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		
		String user = (String) map.get("PRINCIPAL");
		Session session = (Session) map.get("SESSION");
		List<String> roles = (List<String>) session.getAttribute("ROLE_CODE");
		List<String> inss = (List<String>) session.getAttribute("INS_CODE");
		List<String> all = new ArrayList<String>();
		all.add(user);
		all.addAll(roles);
		all.addAll(inss);
		String[] operators = (String[]) all.toArray(new String[0]);
		
		SnakerEngine engine = SnakerHelper.getEngine();
		
		String taskid = (String)map.get("id");
		
		if (action.equals("approve")){
			engine.executeTask(taskid,user);
		}else if (action.equals("reject")){
			Map<String, Object> args = new HashMap<String, Object>();
			args.put("Reject-Reason", map.get("reason"));
			engine.executeAndJumpTask(taskid, user, args, null);
		}
		
		List<Task> list = engine.query().getActiveTasks(new QueryFilter().setOperators(operators));	    
	    List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
		for (Task task : list) {
			Map<String, Object> taskmap = Machine.putValue(task);
			rows.add(taskmap);
		}
	    
	    returnmap.put("Rows",rows);
		return returnmap;
	}
	
	public Map<String, Object> order(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		String user = (String) map.get("PRINCIPAL");		
		String orderid = (String)map.get("id");
		
		SnakerEngine engine = SnakerHelper.getEngine();
	    List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();

		if (action.equals("history")){
			List<HistoryTask> list = engine.query().getHistoryTasks(new QueryFilter().setOrderId(orderid));
			for (HistoryTask task : list) {
				Map<String, Object> taskmap = Machine.putValue(task);
				rows.add(taskmap);
			}
			returnmap.put("Rows",rows);
			return returnmap;
		}else if (action.equals("delete")){
		}else if (action.equals("modify")){
			
		}
		
		List<Order> list = engine.query().getActiveOrders(new QueryFilter());	    
		for (Order order : list) {
			List<HistoryTask> ht = engine.query().getHistoryTasks(new QueryFilter().setOrderId(order.getId()).setOperator(user));
			if (user.equals(order.getCreator()) || ht.size()>0){
				Map<String, Object> taskmap = Machine.putValue(order);
				Process process = engine.process().getProcessById(order.getProcessId());
				taskmap.put("processDisplayName", process.getDisplayName());
				rows.add(taskmap);
			}
		}
	    
	    returnmap.put("Rows",rows);
		return returnmap;
	}
	
	public Map<String, Object> hisorder(Map<String, Object> map) throws Exception
	{
		Map<String, Object> returnmap = new HashMap<String, Object>();
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		String user = (String) map.get("PRINCIPAL");		
		String orderid = (String)map.get("id");
		
		SnakerEngine engine = SnakerHelper.getEngine();
	    List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();

		if (action.equals("history")){
			List<HistoryTask> list = engine.query().getHistoryTasks(new QueryFilter().setOrderId(orderid));
			for (HistoryTask task : list) {
				Map<String, Object> taskmap = Machine.putValue(task);
				rows.add(taskmap);
			}
			returnmap.put("Rows",rows);
			return returnmap;
		}else if (action.equals("delete")){
		}else if (action.equals("modify")){
			
		}
		
		List<HistoryOrder> list = engine.query().getHistoryOrders(new QueryFilter());	    
		for (HistoryOrder order : list) {
			List<HistoryTask> ht = engine.query().getHistoryTasks(new QueryFilter().setOrderId(order.getId()).setOperator(user));
			if (user.equals(order.getCreator()) || ht.size()>0){
				Map<String, Object> taskmap = Machine.putValue(order);
				Process process = engine.process().getProcessById(order.getProcessId());
				taskmap.put("processDisplayName", process.getDisplayName());
				rows.add(taskmap);
			}
		}
	    
	    returnmap.put("Rows",rows);
		return returnmap;
	}
	
}
