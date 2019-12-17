package com.app.TR;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

public class MarketMaker {
	private static Map<String, Object> prices = new HashMap<String, Object>();
	private static Map<String, Object> deals = new HashMap<String, Object>();
	
	//maker
		public Map<String, Object> MM0001(Map<String, Object> map) throws Exception
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
//			result.put("USD_CNY-L-B", df2.format(ra.nextInt(99)));
//			result.put("USD_AUD-L-B", df2.format(ra.nextInt(99)));
//			result.put("USD_EUR-L-B", df2.format(ra.nextInt(99)));
//			result.put("USD_CHF-L-B", df2.format(ra.nextInt(99)));
//			result.put("USD_HKD-L-B", df2.format(ra.nextInt(99)));
//			result.put("CNY_HKD-L-B", df2.format(ra.nextInt(99)));
			return result;		
		}
		
		
		//trade Center
		public Map<String, Object> MM0007(Map<String, Object> map) throws Exception
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
}
