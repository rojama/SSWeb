package com.app.market;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;


public class MainBO {
	private static Map<String, Object> prices = new HashMap<String, Object>();
	public Map<String, Object> process(Map<String, Object> map) throws Exception
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
}
