package com.app.electric;

/**
 * Created by Rojama on 2018/8/9.
 */

import com.app.sys.DB;
import com.app.utility.Machine;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.LinkedList;
import java.util.logging.Logger;

public class PushServer {

    Logger logger = Logger.getLogger("PushServer");

    private Socket client;
    private Socket clientSupply;

    private OutputStream os;
    private OutputStream osSupply;

    private LinkedList<Object> msgList = new LinkedList<Object>();
    private LinkedList<Object> msgListSupply = new LinkedList<Object>();

    private Thread sendMessageThread;
    private Thread sendMessageThreadSupply;

    private PushServer content;


    public PushServer() {
        super();
        content = this;
        logger.info("\n\n############# 加载PushServer\n");



        sendMessageThread = new Thread(new Runnable() {
            @Override
            public void run() {
                ServerSocket serverSocket = null;
                try {
                    Integer push_port = Integer.parseInt(Machine.getPropertie("api.port"));
                    serverSocket = new ServerSocket(push_port);
                } catch (Exception e) {
                    e.printStackTrace();
                    return;
                }

                while (true) {
                    try {
                        if (null != client) {
                            if (msgList.size() == 0) {
                                client.sendUrgentData(0);
                                Thread.sleep(3000);
                                continue;
                            }
                            //logger.info("待发送的消息条数："+msgList.size()+"\n");
                            Object msg;
                            while ((msg = content.getMsg()) != null){
                                logger.info("发送消息:" + msg.toString());
                                os.write(msg.toString().getBytes());
                                os.flush();
                            }
                        } else {
                            logger.info("\n\n重新连接中...\n");
                            logger.info("\n\n等待客户端连接PORT:" + serverSocket.getLocalSocketAddress());
                            client = serverSocket.accept();
                            os = client.getOutputStream();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        try {
                            if (client != null) {
                                client.close();
                                client = null;
                            }

                            //transfer to supply linked list
                            Object msg;
                            while ((msg = content.getMsg()) != null){
                                content.addSupplyMsg(msg);
                            }
                            logger.info("\n\n连接失败，继续连接\n");
                            Thread.sleep(10 * 1000);
                        } catch (Exception e1) {
                            e1.printStackTrace();
                        }
                    }
                }
            }
        });
        sendMessageThread.start();


        sendMessageThreadSupply = new Thread(new Runnable() {

            @Override
            public void run() {
                ServerSocket serverSocket = null;
                try {
                    Integer push_port = Integer.parseInt(Machine.getPropertie("api.port.supply"));
                    serverSocket = new ServerSocket(push_port);
                } catch (Exception e) {
                    e.printStackTrace();
                    return;
                }

                while (true) {
                    try {
                        if (null != clientSupply) {
                            if (msgListSupply.size() == 0) {
                                clientSupply.sendUrgentData(0);
                                Thread.sleep(3000);
                                continue;
                            }
                            //logger.info("待发送的消息条数："+msgList.size()+"\n");
                            Object msg;
                            while ((msg = content.getSupplyMsg()) != null){
                                logger.info("发送补发消息:" + msg.toString());
                                osSupply.write(msg.toString().getBytes());
                                osSupply.flush();
                            }
                        } else {
                            logger.info("\n\n重新补发连接中...\n");
                            Integer push_port = Integer.parseInt(Machine.getPropertie("api.port.supply"));
                            logger.info("\n\n等待客户端补发连接PORT:" + serverSocket.getLocalSocketAddress());
                            clientSupply = serverSocket.accept();
                            osSupply = clientSupply.getOutputStream();
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        try {
                            if (clientSupply != null) {
                                clientSupply.close();
                                clientSupply = null;
                            }
                            logger.info("\n\n补发连接失败，继续连接\n");
                            Thread.sleep(10 * 1000);
                        } catch (Exception e1) {
                            e1.printStackTrace();
                        }
                    }
                }
            }
        });
        sendMessageThreadSupply.start();

        //定时清理数据
        new Thread(new Runnable() {

            @Override
            public void run() {
                while (true) {
                    try {
                        Thread.sleep(3600 * 1000);
                        DB.update("delete from ele_register_record where record_time  <  (CURRENT_TIMESTAMP() + INTERVAL -30 DAY)");
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }).start();
    }

    /**
     * 将一个字符串转化为输入流
     *
     * @param sInputString
     * @return
     */
    public static InputStream getStringStream(String sInputString) {
        if (null != sInputString && !sInputString.trim().equals("")) {
            try {
                ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(sInputString.getBytes());
                return byteArrayInputStream;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * 出
     *
     * @return
     */
    public Object getMsg() {
        synchronized (this) {
            if (msgList != null && msgList.size() > 0) {
                return msgList.removeFirst();
            }
            return null;
        }
    }

    /**
     * 出
     *
     * @return
     */
    public Object getSupplyMsg() {
        synchronized (this) {
            if (msgListSupply != null && msgListSupply.size() > 0) {
                return msgListSupply.removeFirst();
            }
            return null;
        }
    }

    /**
     * 入
     *
     * @param obj
     * @return
     */
    public Object addMsg(Object obj) {
        synchronized (this) {
            msgList.addLast(obj);
        }
        return obj;
    }

    /**
     * 入
     *
     * @param obj
     * @return
     */
    public Object addSupplyMsg(Object obj) {
        synchronized (this) {
            msgListSupply.addLast(obj);
            if (msgListSupply.size() > 100000){
                msgListSupply.removeFirst();
            }
        }
        return obj;
    }

    /**
     * 发送消息
     *
     * @param data
     */
    public void sendMessage(String data) {
        addMsg(data);
    }

    public Logger getLogger() {
        return logger;
    }

    public void setLogger(Logger logger) {
        this.logger = logger;
    }

    public Socket getServer() {
        return client;
    }

    public void setServer(Socket client) {
        this.client = client;
    }

    public OutputStream getOs() {
        return os;
    }

    public void setOs(OutputStream os) {
        this.os = os;
    }

    public LinkedList<Object> getMsgList() {
        return msgList;
    }

    public void setMsgList(LinkedList<Object> msgList) {
        this.msgList = msgList;
    }

    public Thread getSendMessageThread() {
        return sendMessageThread;
    }

    public void setSendMessageThread(Thread sendMessageThread) {
        this.sendMessageThread = sendMessageThread;
    }

}
