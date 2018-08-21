package com.app.electric;

import com.app.sys.DB;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/history")
public class HistoryQuery extends HttpServlet {
    protected void service(HttpServletRequest req, HttpServletResponse res) throws ServletException {
        try {
            Map<String, Object> userInput = new HashMap<String, Object>();
            Enumeration<String> e = req.getParameterNames();
            while (e.hasMoreElements()) {
                String name = (String) e.nextElement();
                userInput.put(name, req.getParameter(name));
            }

            StringBuffer result = new StringBuffer();
            // query for data
            String device_id = (String) userInput.get("device_id");
            String register_id = (String) userInput.get("register_id");
            String start_time = (String) userInput.get("start_time");
            String end_time = (String) userInput.get("end_time");
            String sql = "select * from ele_register_record where 1=1";

            if (device_id != null){
                sql += " and device_id = '"+device_id+"'";
            }
            if (register_id != null){
                sql += " and register_id = '"+register_id+"'";
            }
            if (start_time != null){
                sql += " and record_time >= '"+start_time+"'";
            }
            if (end_time != null){
                sql += " and record_time <= '"+end_time+"'";
            }
            sql += " limit 10000";

            List<Map<String, Object>> datas = DB.query(sql);
            for(Map<String, Object> data : datas){
                result.append(DevicesThread.makeApiData(data));
            }

            res.setContentType("application/json;charset=utf-8");
            PrintWriter out = res.getWriter();
            out.print(result);
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
