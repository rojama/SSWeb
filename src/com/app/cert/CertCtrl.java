package com.app.cert;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.app.sys.DB;
import com.app.utility.ImageUtil;
//import com.sun.image.codec.jpeg.JPEGCodec;
//import com.sun.image.codec.jpeg.JPEGImageDecoder;
//import com.sun.image.codec.jpeg.JPEGImageEncoder;
//import sun.awt.SunHints;

import javax.imageio.ImageIO;
import javax.swing.*;

public class CertCtrl {
	
	public Map maintan(Map<String, Object> map) throws Exception{
		Map rtnmap = new HashMap();
		List<Map<String, Object>> rows = DB.selete("CERT_USER");
		rtnmap.put("total", rows.size());
		rtnmap.put("rows", rows);
		return rtnmap;
	}

	public Object main_query(Map<String, Object> map) throws Exception{
		Map rtnmap = new HashMap();
		List<Map<String, Object>> datas =  DB.seleteByKey("CERT_USER", map);
		if (datas.size() == 0){
			rtnmap.put("ERR","没有查询到相关证书");
		}else{
			rtnmap = datas.get(0);
			ImageUtil.addBase64Image(rtnmap,"CERT_IMAGE");
		}
		return rtnmap;
	}

	public Object main_get(Map<String, Object> map) throws Exception{
		Map rtnmap = new HashMap();
		String pagesize = (String)map.get("rows");
		String page = (String)map.get("page");
		List<Map<String, Object>> data = DB.seleteByColumn("CERT_USER",null,
				"USER_ID, USER_NAME, USER_SEX, USER_AGE, CERT_LEVEL, CERT_START, USER_IMAGE",
				pagesize,page,null,null,null);
		for (Map datamap : data){
			ImageUtil.addBase64Image(datamap,"USER_IMAGE");
		}
		Long total = (Long) DB.query("select count(1) COUNT from CERT_USER").get(0).get("COUNT");
		rtnmap.put("total", total);
		rtnmap.put("rows", data);
		return rtnmap;
	}
	
	public Object main_save(Map<String, Object> map) throws Exception{
		ImageUtil.changeBase64ToByte(map, "USER_IMAGE");
		makeCert(map);
		DB.insert("CERT_USER", map);
		return null;
	}
	
	public Object main_update(Map<String, Object> map) throws Exception{
		ImageUtil.changeBase64ToByte(map, "USER_IMAGE");
		makeCert(map);
		DB.update("CERT_USER", map);
		return null;
	}
	
	public Object main_destroy(Map<String, Object> map) throws Exception{
		Map key = new HashMap();
		key.put("USER_ID", map.get("id"));
		DB.delete("CERT_USER", key);
		return null;
	}

	private void makeCert(Map<String, Object> map) throws Exception{
//		//获取模版背景图
//		InputStream is = CertCtrl.class.getResourceAsStream("temple.jpg");
//		JPEGImageDecoder jpegDecoder = JPEGCodec.createJPEGDecoder(is);
//		BufferedImage buffImg = jpegDecoder.decodeAsBufferedImage();
//		Graphics2D g = buffImg.createGraphics();
//		g.setRenderingHint(SunHints.KEY_ANTIALIASING, SunHints.VALUE_ANTIALIAS_OFF);
//		g.setRenderingHint(SunHints.KEY_TEXT_ANTIALIASING, SunHints.VALUE_TEXT_ANTIALIAS_DEFAULT);
//		g.setRenderingHint(SunHints.KEY_STROKE_CONTROL, SunHints.VALUE_STROKE_DEFAULT);
//		g.setRenderingHint(SunHints.KEY_TEXT_ANTIALIAS_LCD_CONTRAST, 140);
//		g.setRenderingHint(SunHints.KEY_FRACTIONALMETRICS, SunHints.VALUE_FRACTIONALMETRICS_OFF);
//		g.setRenderingHint(SunHints.KEY_RENDERING, SunHints.VALUE_RENDER_DEFAULT);
//
//		//附加头像。
//		ByteArrayInputStream user_image_byte = new ByteArrayInputStream((byte[]) map.get("USER_IMAGE"));
//		BufferedImage user_image = ImageIO.read(user_image_byte);
//		g.drawImage(user_image,138,463,133,165,null);
//
//		//设置颜色。
//		g.setColor(Color.BLACK);
//		g.setFont(new Font("宋体",Font.PLAIN,26));
//
//		//写名字等信息
//		g.drawString((String) map.get("USER_NAME"),552,497);
//		g.drawString((String) map.get("USER_SEX"),552,580);
//		g.drawString((String) map.get("USER_AGE"),552,670);
//		g.drawString((String) map.get("USER_ID"),586,753);
//		g.drawString((String) map.get("CERT_LEVEL"),222,667);
//		g.drawString((String) map.get("CERT_START"),222,750);
//		g.dispose();
//
//		//输出证书图像
//		ByteArrayOutputStream out = new ByteArrayOutputStream();
//		ImageIO.write(buffImg,"png", out);
//		map.put("CERT_IMAGE", out.toByteArray());
//		out.close();
//		is.close();
	}
}
