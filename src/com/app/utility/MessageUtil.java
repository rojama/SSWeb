package com.app.utility;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Map;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

public class MessageUtil {
	static public void sendEmail(String email, String Subject, String message) {
		 try { 
			// 发送email  
			HtmlEmail htmlEmail = new HtmlEmail(); 
            // 这里是SMTP发送服务器的名字：163的如下："smtp.163.com"  
            htmlEmail.setHostName("smtp.163.com");  
            // 字符编码集的设置  
            htmlEmail.setCharset("UTF-8");  
            // 收件人的邮箱  
            htmlEmail.addTo(email);  
            // 发送人的邮箱  
            htmlEmail.setFrom("electricmonitor@163.com", "系统管理员");  
            // 如果需要认证信息的话，设置认证：用户名-密码。分别为发件人在邮件服务器上的注册名称和密码  
            htmlEmail.setAuthentication("electricmonitor", "dsS41e2fc8Ded58");  
            // 要发送的邮件主题  
            htmlEmail.setSubject(Subject);  
            // 要发送的信息，由于使用了HtmlEmail，可以在邮件内容中使用HTML标签  
            htmlEmail.setMsg(message);  
            // 发送  
            htmlEmail.send();
            System.out.println("sendEmail to " + email);
        } catch (EmailException e) {  
            e.printStackTrace();
        }  
	}

	static public void sendSms(String phone, String message) {
		try {
			HttpClient client = new HttpClient();
			PostMethod post = new PostMethod("http://gbk.sms.webchinese.cn");
			post.addRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=gbk");// 在头文件中设置转码
			NameValuePair[] data = { 
					new NameValuePair("Uid", "electricmonitor"),
					new NameValuePair("Key", "2b3defef00e6c7dd3b13"),  //登录短信平台密码 hJjis785Guds87H
					new NameValuePair("smsMob", phone),
					new NameValuePair("smsText", message) };
			post.setRequestBody(data);
			client.executeMethod(post);
			Header[] headers = post.getResponseHeaders();
			int statusCode = post.getStatusCode();
			System.out.println("sendSms statusCode:" + statusCode);
			String result = new String(post.getResponseBodyAsString().getBytes("gbk"));
			System.out.println("sendSms return code:" + result); // 打印返回消息状态
			if (!result.startsWith("-")){
				System.out.println("sendSms to " + phone);
			}
			post.releaseConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	static public String replaceValue(String inputValue, Map data) {
		String outputValue = inputValue;
		for (Object key : data.keySet()) {
			outputValue = outputValue.replaceAll((String) key, String.valueOf(data.get(key)));
		}
		return outputValue;
	}

}
