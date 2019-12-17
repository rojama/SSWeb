package com.app.TR;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import com.app.sys.DB;


public class CorporateFinanceHelper {
	public Map<String, Object> getAccountByCustNo(Map<String, Object> map) throws Exception
	{
		String str_CUSTOMERNO =  (String) map.get("CUSTOMERNO");
		String str_TT_SETTLEMENTCCY = (String) map.get("SETTLEMENTCCY");
		String select = "";
		if("CNY".equals(str_TT_SETTLEMENTCCY))
		{
			select = "SELECT * FROM TTP_SETTLEMENTS where CUSTOMERNO='"+str_CUSTOMERNO.trim()+"'  and TT_SETTLEMENTCCY ='CNY'";
		}else{
			select = "SELECT * FROM TTP_SETTLEMENTS where CUSTOMERNO='"+str_CUSTOMERNO.trim()+"'  and TT_SETTLEMENTCCY <>'CNY'";
		}
		List<Map<String, Object>> retData= DB.query(select);
		Map<String, Object> retMap= new HashMap<String, Object>();
		retMap.put("Rows", retData);
		return retMap;
	}
	
	public Map<String, Object> getBRFXSPREAD(Map<String, Object> map) throws Exception
	{
		String str_CurrencyPair =  (String) map.get("currencyPair");
		String str_TT_DEALTENOR = trimNull(map.get("TT_DEALTENOR"));
		String str_TT_DEALTYPE= trimNull(map.get("TT_DEALTYPE"));
		String 	select = "SELECT TT_OFFERPOINT as BRTT_OFFERPOINT,TT_BIDPOINT as BRTT_BIDPOINT FROM"
				+ " TR_COM_BR_FXSPREAD where TT_CURRENCYPAIR='"+str_CurrencyPair.replace("_", ".")+
				"'  and TT_DEALTYPE='"+str_TT_DEALTYPE+"' and TT_DEALTENOR='"+str_TT_DEALTENOR+"'";
		List<Map<String, Object>> retData= DB.query(select);
		Map<String, Object> retMap= new HashMap<String, Object>();
		if(retData.size()>0)
		{
			retMap = retData.get(0);
		}
		String []cs = str_CurrencyPair.split("_");
		String 	selectC = "SELECT TT_OFFERPOINT as COMTT_OFFERPOINT,TT_BIDPOINT as COMTT_BIDPOINT FROM"
				+ " TR_COM_FXBOARDSPREAD1 where TT_BASECCY='"+cs[0]+"'  and TT_TERMCCY ='"+cs[1]+"' and TT_TENOR='"+str_TT_DEALTENOR+"'";
		List<Map<String, Object>> retData1= DB.query(selectC);
		if(retData1.size()>0)
		{
			retMap.put("COMTT_OFFERPOINT", retData1.get(0).get("COMTT_OFFERPOINT"));
			retMap.put("COMTT_BIDPOINT", retData1.get(0).get("COMTT_BIDPOINT"));
		}
	    return retMap;
	}
	public Map<String, Object> getFXTRCOMBASERAT(Map<String, Object> map) throws Exception
	{
		String str_TR_BASECCY =  (String) map.get("TR_BASECCY");
		String str_TR_TERMSCCY =  (String) map.get("TR_TERMSCCY");
		String str_TR_TENOR =  (String) map.get("TR_TENOR");
		String str_FTR_TENOR =  (String) map.get("FTR_TENOR");
		String 	select = " SELECT * FROM  ROOT.TR_COM_BASERATE where TR_BASECCY='"+str_TR_BASECCY+"'  and TR_TERMSCCY ='"+str_TR_TERMSCCY+"' and TR_TENOR='"+str_TR_TENOR+"'";
		List<Map<String, Object>> retData= DB.query(select);
		Map<String, Object> retMap= new HashMap<String, Object>();
		if(retData.size()>0)
		{
			retMap = retData.get(0);
		}
		String 	selectF = " SELECT * FROM  ROOT.TR_COM_BASERATE where TR_BASECCY='"+str_TR_BASECCY+"'  and TR_TERMSCCY ='"+str_TR_TERMSCCY+"' and TR_TENOR='"+str_FTR_TENOR+"'";
		List<Map<String, Object>> retDataF= DB.query(selectF);
		if(retDataF.size()>0)
		{
			retMap.put("FTR_ASK", retDataF.get(0).get("TR_ASK")) ;
			retMap.put("FTR_BID", retDataF.get(0).get("TR_BID")) ;
		}
		
	    return retMap;
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
