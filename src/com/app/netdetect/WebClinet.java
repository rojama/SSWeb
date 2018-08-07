package com.app.netdetect;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;

import com.app.netdetect.ws.WebInterface;
import com.app.netdetect.ws.WebInterfaceService;
import com.google.gson.Gson;

public class WebClinet {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			sendCode();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void sendCode() throws Exception{
		Gson gson = new Gson();
		String ip = "127.0.0.1";
        URL baseUrl = com.app.netdetect.ws.WebInterfaceService.class.getResource(".");
        URL url = new URL(baseUrl, "http://"+ip+":8989/WS_Server?wsdl");       
		WebInterfaceService factory = new WebInterfaceService(url);
		WebInterface wsImpl = factory.getWebInterfacePort();
        String password = "";
		List<String> lists = new ArrayList();
		String id = "1";
		String time = "";
		String type = "udp-test";
		Map map = new HashMap();
		map.put("dd", "dddddd");
		map.put("kk", "kkksds");
		String args = gson.toJson(map);
		lists.add(id);
		lists.add(time);
		lists.add(type);
		lists.add(args);
		
		String resResult = wsImpl.processCode(password, lists);
        
        System.out.println("调用WebService的sayHello方法返回的结果是："+resResult);
	}
}
