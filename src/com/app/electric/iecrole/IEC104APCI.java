package com.app.electric.iecrole;

import com.app.utility.DataTypeChangeHelper;

public class IEC104APCI implements MessageElement {

	public int len;
	public byte ctrl1;
	public byte ctrl2;
	public byte ctrl3;
	public byte ctrl4;
	
	@Override
	public void decode(byte[] message) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public byte[] code() throws Exception {
		// TODO Auto-generated method stub
		return new byte[]{0x68, (byte) len, ctrl1, ctrl2, ctrl3, ctrl4};
	}
	
	public void setCount(short send, short recv){
		String binSend = "000000000000000000000"+Integer.toBinaryString(send)+"0";
		ctrl1 = (byte) Integer.parseInt(binSend.substring(binSend.length()-8, binSend.length()),2);
		ctrl2 = (byte) Integer.parseInt(binSend.substring(binSend.length()-16, binSend.length()-8),2);
		String binRecv = "000000000000000000000"+Integer.toBinaryString(recv)+"0";
		ctrl3 = (byte) Integer.parseInt(binRecv.substring(binRecv.length()-8, binRecv.length()),2);
		ctrl4 = (byte) Integer.parseInt(binRecv.substring(binRecv.length()-16, binRecv.length()-8),2);				
	}

}
