package com.app.sys;

import java.nio.channels.ClosedChannelException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.websocket.Session;

public class WebSocketManager {
	public static Set<Session> peers = Collections.synchronizedSet(new HashSet<Session>());
	
//	参数一和客户端一致，代表发送的信息类型编号
//	参数二代表接收的用户ID，null代表所有用户
//	参数三是消息，可以用json格式来传输数据。
	public static void SendMessage(String wscode, String principal, String message) throws Exception {
		Iterator<Session> peers_it = peers.iterator();  
		while(peers_it.hasNext()){
			Session session = peers_it.next();
        	Map<String, Object> sessionMap = session.getUserProperties();
        	if (sessionMap.containsKey("WSCODE")){
        		
        		for (String code : (List<String>) sessionMap.get("WSCODE")){
        			if (code.equals(wscode) && (principal == null || sessionMap.get("PRINCIPAL").equals(principal))){
        				//System.out.println("SendMessage to "+principal+" on "+wscode+": "+message);
        				try {
							session.getBasicRemote().sendText(message);
						} catch (ClosedChannelException e) {
							e.printStackTrace();
							peers_it.remove();
						}
        				continue;
        			}
        		}
        	}
        }
		
    }
}
