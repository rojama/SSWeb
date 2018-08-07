package com.app.electric.iecrole;

import com.app.utility.Tools;

public class IECTools {
	
	//将数据转变为可识别字符串
    public static String gidToString(byte[] gid, int datatype){
        String string = "";
        switch (datatype){
        case 0:
        	break;
        case 1:
        	string = new String(gid);
        	break;
        case 3:
        	string = String.valueOf(registersToUnsignedInt(gid));
        	break;
        case 4:
        	string = String.valueOf(registersToInt(gid));
        	break;
        case 5:
        	string = String.valueOf(registersToUnsignedFloat(gid));
        	break;
        case 6:
        	string = String.valueOf(registersToFloat(gid));
        	break;
        default:
        	string = Tools.bytesToHexString(gid);
        }
        return string;
    }
    
    public static final int registersToInt(byte[] bytes)
    {
      return bytes[0] << 24 | (bytes[1] & 0xFF) << 16 | (bytes[2] & 0xFF) << 8 | bytes[3] & 0xFF;
    }
    
    public static final int registersToUnsignedInt(byte[] bytes)
    {
      return (bytes[0] & 0xFF) << 24 | (bytes[1] & 0xFF) << 16 | (bytes[2] & 0xFF) << 8 | bytes[3] & 0xFF;
    }
    
    public static final float registersToFloat(byte[] bytes)
    {
      return Float.intBitsToFloat(bytes[0] << 24 | (bytes[1] & 0xFF) << 16 | (bytes[2] & 0xFF) << 8 | bytes[3] & 0xFF);
    }
    
    public static final float registersToUnsignedFloat(byte[] bytes)
    {
      return Float.intBitsToFloat((bytes[0] & 0xFF) << 24 | (bytes[1] & 0xFF) << 16 | (bytes[2] & 0xFF) << 8 | bytes[3] & 0xFF);
    }
}
