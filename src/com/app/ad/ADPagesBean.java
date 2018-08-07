package com.app.ad;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.wimpi.modbus.ModbusIOException;
import net.wimpi.modbus.msg.ReadCoilsRequest;
import net.wimpi.modbus.msg.ReadCoilsResponse;
import net.wimpi.modbus.msg.ReadInputDiscretesRequest;
import net.wimpi.modbus.msg.ReadInputDiscretesResponse;
import net.wimpi.modbus.msg.ReadInputRegistersRequest;
import net.wimpi.modbus.msg.ReadInputRegistersResponse;
import net.wimpi.modbus.msg.ReadMultipleRegistersRequest;
import net.wimpi.modbus.msg.ReadMultipleRegistersResponse;
import net.wimpi.modbus.msg.WriteCoilRequest;
import net.wimpi.modbus.msg.WriteCoilResponse;
import net.wimpi.modbus.msg.WriteSingleRegisterRequest;
import net.wimpi.modbus.msg.WriteSingleRegisterResponse;
import net.wimpi.modbus.procimg.InputRegister;
import net.wimpi.modbus.procimg.Register;
import net.wimpi.modbus.procimg.SimpleRegister;
import net.wimpi.modbus.util.BitVector;

import org.apache.shiro.session.Session;

import com.app.sys.CommonBO;
import com.app.sys.DB;
import com.app.utility.Machine;

public class ADPagesBean {
	
	public Object select(Map<String, Object> map) throws Exception
	{
		String action = "";
		if (map.containsKey("ACTION")){
			action = (String) map.get("ACTION");
		}
		System.out.println("inputMAP="+map);
		if (action.equals("area-tree")){
			String icon = "../../images/icons/some/world.png";
			return DB.query("select area_id as node_id, area_id as node_value, area_name as node_name, upper_area_id as upper_node_id , '"+icon+"' as icon from ad_area");
		}else if (action.equals("ins-tree")){
			String icon = "../../images/icons/some/house.png";
			return DB.query("select INS_ID as node_id, INS_CODE as node_value, INS_NAME as node_name, INS_SUPER_ID as upper_node_id , '"+icon+"' as icon from aut_institution");
		}else if (action.equals("media-list")){
			return DB.seleteByColumn("AD_MEDIA", new HashMap(), "MEDIA_ID, CONCAT(MEDIA_NAME,'-',MEDIA_TYPE) as MEDIA_NAME", null, null, "MEDIA_NAME", "ASC", null);
		}
		return null;
	}
	
}
