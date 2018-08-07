package com.app.sys;

import java.io.IOException;

import javax.websocket.CloseReason;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import com.app.sys.WebSocketManager;

@ServerEndpoint(value="/websocket", configurator=WebSocketConfigurator.class)
public class WebSocket {

	
	@OnMessage
    public void onMessage(Session session, String message) 
    	throws IOException, InterruptedException {
		// Print the client message for testing purposes
		System.out.println("Received: " + message);
    }
	
	@OnOpen
    public void onOpen (Session session, EndpointConfig conf) {
        System.out.println("Client connected");
		session.getUserProperties().putAll(conf.getUserProperties());
        session.getUserProperties().putAll(session.getRequestParameterMap());
        WebSocketManager.peers.add(session);
    }

    @OnClose
    public void onClose (Session session, CloseReason reason) {
    	System.out.println("Connection closed : "+session.getUserProperties());
    	WebSocketManager.peers.remove(session);
    }
    
    @OnError
    public void onError(Session session, Throwable error) {
    	System.out.println("Connection error : "+session.getUserProperties() + " - " + error.getMessage());
    	WebSocketManager.peers.remove(session);
    }
}
