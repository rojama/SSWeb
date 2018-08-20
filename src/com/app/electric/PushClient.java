package com.app.electric;

/**
 * Created by Rojama on 2018/8/9.
 */

import com.app.sys.DB;
import com.app.utility.Machine;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.LinkedList;
import java.util.logging.Logger;

public class PushClient {

    Logger logger = Logger.getLogger("PushClient");

    private String host;

    private Integer port;

    private Socket client;

    private OutputStream os;

    private LinkedList<Object> msgList = new LinkedList<Object>();

    private Thread sendMessageThread;


    public PushClient() {
        super();
        logger.info("\n\n############# 加载PushClient\n");
        sendMessageThread = new Thread(new Runnable() {

            @Override
            public void run() {
                while (true) {
                    try {
                        if (null != client) {
                            if (msgList.size() == 0) {
                                Thread.sleep(3000);
                                //logger.info("待发送的消息条数为0\n");
                                continue;
                            }
                            //logger.info("待发送的消息条数："+msgList.size()+"\n");
                            for (int i = 0; i < msgList.size(); i++) {
                                //Thread.sleep(500);
                                logger.info("发送第" + (i + 1) + "条消息:" + msgList.get(i).toString());
                                os.write(msgList.get(i).toString().getBytes());
                                os.flush();
                            }
                            msgList.clear();
                        } else {
                            logger.info("\n\n重新连接中...\n");
                            String push_ip = Machine.getPropertie("api.ip");
                            Integer push_port = Integer.parseInt(Machine.getPropertie("api.port"));
                            logger.info("\n\n连接IP:" + push_ip + "\n连接PORT:" + push_port);
                            client = new Socket(push_ip, push_port);
                            client.setKeepAlive(true);
                            os = client.getOutputStream();
                        }
                    } catch (Exception e) {
                        try {
                            if (client != null) {
                                client.close();
                                client = null;
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

        //定时清理数据
        new Thread(new Runnable() {

            @Override
            public void run() {
                while (true) {
                    try {
                        Thread.sleep(3600 * 1000);
                        DB.update("delete from ele_register_record where record_time  <  (CURRENT_TIMESTAMP() + INTERVAL -1 DAY)");
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

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public Integer getPort() {
        return port;
    }

    public void setPort(Integer port) {
        this.port = port;
    }

    public Socket getClient() {
        return client;
    }

    public void setClient(Socket client) {
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
