package com.app.electric;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

import javax.servlet.ServletContext;

/**
 * 自定义一个Socket线程类继承自线程类，重写run()方法，用于接收客户端socket请求报文
 */
public class SocketThread extends Thread {
	private ServerSocket serverSocket;

	public SocketThread(ServerSocket serverSocket) {
		this.serverSocket = serverSocket;
	}

	public void run() {
		// 有盒子连接上了就启动新线程进行处理
		System.out.println("Server socket listening on " + serverSocket.getLocalSocketAddress());
		while (!this.isInterrupted()) {
			try {
				Socket socket = serverSocket.accept();
				if (socket != null)
					new BoxThread(socket).start();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void closeServerSocket() {
		try {
			if (serverSocket != null && !serverSocket.isClosed())
				serverSocket.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}