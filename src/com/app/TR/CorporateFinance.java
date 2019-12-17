package com.app.TR;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import com.app.sys.DB;
import com.app.sys.WebSocketManager;


public class CorporateFinance {
	private static Map<String, Object> prices = new HashMap<String, Object>();
	private static Map<String, Object> deals = new HashMap<String, Object>();
	
	//maker
	public Map<String, Object> CF0001(Map<String, Object> map) throws Exception
	{
		System.out.println(map);
		Map<String, Object> result = new HashMap<String, Object>();
		
		String act = (String) map.get("ACTION");
		if ("getAll".equals(act)){
			DecimalFormat    df   = new DecimalFormat("######0.0000");  
			DecimalFormat    df2   = new DecimalFormat("00");  
			Random ra =new Random();
			String[] curs = {"USD_CNY","USD_AUD","USD_EUR","USD_CHF","USD_HKD","CNY_HKD"};
			
			if (prices.isEmpty()){
				for (String cur : curs){
					double mid = Math.random()+ra.nextInt(8);
					result.put(cur+"-L", mid);
					result.put(cur+"-R", mid+0.0055);
					result.put(cur+"-RL", mid);
					result.put(cur+"-RR", mid+0.0055);			
				}
				prices.putAll(result);
			}else{
				for (String key : prices.keySet()){
					if (ra.nextInt(5)==0){
						double price = (Double) prices.get(key);
						double newPrice = price + (ra.nextBoolean()?1:-1)*ra.nextInt(10)/10000.00;
						if (newPrice<=0) {
							newPrice = 0.0001;
						}
						prices.put(key, newPrice);
					}
				}
				result.putAll(prices);
			}
			
			for (String key : result.keySet()){
				result.put(key, df.format(result.get(key)));			
			}
		}else if ("changePrice".equals(act)){
			String cur = (String) map.get("Currency");
			String type = (String) map.get("Type");
			String key = "";
			double change = 0;
			if ("left-up".equals(type)){
				key = cur+"-L";			
				change = 0.0001;
				prices.put(key, (Double) prices.get(key)+ change);
			}else if ("left-down".equals(type)){
				key = cur+"-L";			
				change = -0.0001;
				prices.put(key, (Double) prices.get(key)+ change);
			}else if ("right-up".equals(type)){
				key = cur+"-R";			
				change = 0.0001;
				prices.put(key, (Double) prices.get(key)+ change);
			}else if ("right-down".equals(type)){
				key = cur+"-R";			
				change = -0.0001;
				prices.put(key, (Double) prices.get(key)+ change);
			}else if ("left".equals(type)){
				change = -0.0001;
				key = cur+"-L";			
				prices.put(key, (Double) prices.get(key)+ change);
				key = cur+"-R";	
				prices.put(key, (Double) prices.get(key)+ change);
			}else if ("right".equals(type)){
				change = 0.0001;
				key = cur+"-L";	
				prices.put(key, (Double) prices.get(key)+ change);
				key = cur+"-R";	
				prices.put(key, (Double) prices.get(key)+ change);
			}
		}
//		
//		result.put("USD_CNY-L-B", df2.format(ra.nextInt(99)));
//		result.put("USD_AUD-L-B", df2.format(ra.nextInt(99)));
//		result.put("USD_EUR-L-B", df2.format(ra.nextInt(99)));
//		result.put("USD_CHF-L-B", df2.format(ra.nextInt(99)));
//		result.put("USD_HKD-L-B", df2.format(ra.nextInt(99)));
//		result.put("CNY_HKD-L-B", df2.format(ra.nextInt(99)));
		return result;		
	}
	
	//taker
	public Map<String, Object> CF1001(Map<String, Object> map) throws Exception
	{
		System.out.println(map);
		Map<String, Object> result = new HashMap<String, Object>();
		
		String act = (String) map.get("ACTION");
		if ("getAll".equals(act)){
			DecimalFormat    df   = new DecimalFormat("######0.0000");  
			
			if (!prices.isEmpty()){
				result.putAll(prices);
			}
			
			for (String key : result.keySet()){
				result.put(key, df.format(result.get(key)));			
			}
		}else if ("getSeqno".equals(act)){
			String seqno = UUID.randomUUID().toString();
			result.put("seqno", seqno);
			Map<String, Object> deal = new HashMap<String, Object>();
			deal.put("Seqno", seqno);
			deal.put("DealState", "Init");
		//	deals.put(seqno, deal);
		}else if ("Query".equals(act)){
			//String seqno = (String) map.get("seqno");
			//Map<String, Object> deal = (Map<String, Object>) deals.get(seqno);
			map.put("DealState", "Ask");
			String str_BuyOrSell = (String)map.get("FXT_BUYORSELL_CUS");
			if("BUY".equals(str_BuyOrSell))
			{
				map.put("FXT_DEALTCOSTRATE", trimNull(map.get("BFXT_DEALTCOSTRATE")));
				map.put("FXT_DEALTCOSTRATE", trimNull((String)map.get("BFXT_DEALTCOSTRATE")));	
				map.put("FXT_COSTPOINT", trimNull(map.get("BFXT_COSTPOINT")));
				map.put("FXT_DEALTDEALDOWNRATE", trimNull(map.get("BFXT_DEALTDEALDOWNRATE")));
				map.put("FXT_DEALPOINT", trimNull(map.get("BFXT_DEALPOINT")));
				map.put("FXT_DEALAFAVOURPOINT", trimNull(map.get("BFXT_DEALAFAVOURPOINT")));
				map.put("FXT_SWAPCOSTPOINT", trimNull(map.get("BFXT_SWAPCOSTPOINT")));
				map.put("FXT_SWAPCOSTRATE", trimNull(map.get("BFXT_SWAPCOSTRATE")));
				map.put("FXT_SWAPDEALFAVOURPOINT", trimNull(map.get("BFXT_SWAPDEALFAVOURPOINT")));
				map.put("FXT_SWAPDEALPOINT", trimNull(map.get("BFXT_SWAPDEALPOINT")));
				map.put("FXT_SWAPDEALDOWNRATE", trimNull(map.get("BFXT_SWAPDEALDOWNRATE")));
				map.put("FXT_TRADEMARKRATE", trimNull(map.get("BFXT_TRADEMARKRATE")));
				map.put("FXT_TRADEMARKPOINT", "1");
				map.put("FXT_SWAPTRADEMARKPOINT", "12");
			}else{
				map.put("FXT_TRADEMARKRATE", trimNull(map.get("SFXT_TRADEMARKRATE")));
				map.put("FXT_COSTPOINT", trimNull((String)map.get("SFXT_COSTPOINT")));	
				map.put("FXT_DEALTCOSTRATE", trimNull(map.get("SFXT_DEALTCOSTRATE")));
				map.put("FXT_DEALAFAVOURPOINT", trimNull(map.get("SFXT_DEALAFAVOURPOINT")));
				map.put("FXT_DEALPOINT", trimNull(map.get("SFXT_DEALPOINT")));
				map.put("FXT_DEALTDEALDOWNRATE", trimNull(map.get("SFXT_DEALTDEALDOWNRATE")));
				map.put("FXT_SWAPCOSTRATE", trimNull(map.get("SFXT_SWAPCOSTRATE")));
				map.put("FXT_SWAPCOSTPOINT", trimNull(map.get("SFXT_SWAPCOSTPOINT")));
				map.put("FXT_SWAPDEALDOWNRATE", trimNull(map.get("SFXT_SWAPDEALDOWNRATE")));
				map.put("FXT_SWAPDEALPOINT", trimNull(map.get("SFXT_SWAPDEALPOINT")));
				map.put("FXT_SWAPDEALFAVOURPOINT", trimNull(map.get("SFXT_SWAPDEALFAVOURPOINT")));
				map.put("FXT_TRADEMARKRATE", trimNull(map.get("SFXT_TRADEMARKRATE")));
				map.put("FXT_TRADEMARKPOINT", "12");
				map.put("FXT_SWAPTRADEMARKPOINT", "1");
			}
			if(map.containsKey("SUBJECT"))
			{
				map.remove("SUBJECT");
			}
			deals.put((String)map.get("FX_TREFNO"), map);
			
			WebSocketManager.SendMessage("CF1001", null, (String)map.get("FX_TREFNO")); 
			
		}else if ("Confim".equals(act)){
			String seqno = (String) map.get("seqno");
			Map<String, Object> deal = (Map<String, Object>) deals.get(seqno);
			deal.put("DealState", "Confim");
			WebSocketManager.SendMessage("CF0023", null, (String)map.get("FX_TREFNO"));
		}else if ("Cancel".equals(act)){
			String seqno = (String) map.get("seqno");
			Map<String, Object> deal = (Map<String, Object>) deals.get(seqno);
			deal.put("DealState", "Cancel");
		}else if("Search".equals(act)){
			String seqno = (String) map.get("seqno");
			result = (Map<String, Object>)deals.get(seqno);
		}
		
		return result;		
	}
	
	//trade Center
	public Map<String, Object> CF0023(Map<String, Object> map) throws Exception
	{
		System.out.println(map);
		Map<String, Object> result = new HashMap<String, Object>();
		
		String act = (String) map.get("ACTION");
		if ("getAll".equals(act)){
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			for (String key :deals.keySet()){
				list.add((Map<String, Object>) deals.get(key));
			}
			result.put("Rows", list);
		}else if ("getSeqno".equals(act)){
			String seqno = UUID.randomUUID().toString();
			result.put("seqno", seqno);
			Map<String, Object> deal = new HashMap<String, Object>();
			deal.put("DealState", "Init");
			deals.put(seqno, deal);
		}else if ("Ask".equals(act)){
			String seqno = (String) map.get("seqno");
			Map<String, Object> deal = (Map<String, Object>) deals.get(seqno);
			deal.put("DealState", "Ask");
			deal.putAll(map);
		}else if ("Confim".equals(act)){
			String seqno = (String) map.get("seqno");
			Map<String, Object> deal = (Map<String, Object>) deals.get(seqno);
			deal.put("DealState", "Confim");
			deal.putAll(map);
		}else if ("Cancel".equals(act)){
			String seqno = (String) map.get("seqno");
			Map<String, Object> deal = (Map<String, Object>) deals.get(seqno);
			deal.put("DealState", "Cancel");
			deal.putAll(map);
		}
		
		return result;		
	}
	
	//market
	public Map<String, Object> CF0024(Map<String, Object> map) throws Exception 
	{
		
		System.out.println("CF0024@@:"+map);
		Map<String, Object> result = new HashMap<String, Object>();
		
		String act = (String) map.get("ACTION");
		if("Confim".equals(act))
		{
			String seqno = (String) map.get("seqno");
			Map<String, Object> deal = (Map<String, Object>) deals.get(seqno);
			deal.put("DealState", "Confim");
			
			if(map.containsKey("SUBJECT"))
			{
				map.remove("SUBJECT");
			}
			
			deal.putAll(map);
			
			WebSocketManager.SendMessage("CF0023", null, seqno);
		}
		 
		return result;
	}
	
	public String trimNull(Object str_valueObject) {
		String str_value = (String) str_valueObject;
		if (str_value == null) {
			return "";
		} else {
			return str_value.trim();
		}
	}

	
}
