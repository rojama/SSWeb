package com.app.electric.iecrole;

public class IEC103DUI implements MessageElement {
	public int typ;
	public int vsq;
	public int cot;
	public int address;
	
	@Override
	public void decode(byte[] message) throws Exception {
		typ = message[0] & 0xFF;
		vsq = message[1] & 0xFF;
		cot = message[2] & 0xFF;
		address = message[3] & 0xFF;
	}

	@Override
	public byte[] code() throws Exception {
		return new byte[]{(byte) typ, (byte) vsq, (byte) cot, (byte) address};
	}
	
}
