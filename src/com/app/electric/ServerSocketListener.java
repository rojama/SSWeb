package com.app.electric;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.app.sys.DB;

public class ServerSocketListener implements ServletContextListener {
	private static Map<Integer, SocketThread> socketThreads;
	private static int defPort;

	public void contextDestroyed(ServletContextEvent e) {
		for (Integer key : socketThreads.keySet()) {
			SocketThread socketThread = socketThreads.get(key);
			if (socketThread != null && socketThread.isInterrupted()) {
				socketThread.closeServerSocket();
				socketThread.interrupt();
			}
		}
	}

	// 根据盒子维护的端口进行监听
	public void contextInitialized(ServletContextEvent e) {
		try {
			ServletContext servletContext = e.getServletContext();
			if (socketThreads == null) {
				socketThreads = new HashMap<Integer, SocketThread>();
				defPort = Integer.parseInt(servletContext.getInitParameter("SocketPort"));
				processBox();
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}

	public static void processBox() throws Exception {
		List<Map<String, Object>> datas;
		datas = DB.query("SELECT DISTINCT CONNECT_PORT FROM ELE_BOX");
		for (Map<String, Object> data : datas) {
			int port = (Integer) data.get("CONNECT_PORT");
			if (port == 0) { // 端口维护0就获取默认端口
				port = defPort;
			}
			if (!socketThreads.containsKey(port)) {
				ServerSocket serverSocket = new ServerSocket(port);				
				SocketThread socketThread = new SocketThread(serverSocket);
				socketThreads.put(port, socketThread);
				socketThread.start();
			}
		}
	}
}
