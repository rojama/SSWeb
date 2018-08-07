package com.app.electric.iecrole;

import java.util.Arrays;

import com.app.utility.Machine;

public class IEC103ASDU implements MessageElement {
	public IEC103DUI dui = new IEC103DUI();
	public byte[] io;

	@Override
	public void decode(byte[] message) throws Exception {
		dui.decode(Arrays.copyOfRange(message, 0, 4));
		io = Arrays.copyOfRange(message, 4, message.length);
	}

	@Override
	public byte[] code() throws Exception {
		return Machine.concatAll(dui.code(), io);
	}
	
	public void build(int type, int vsq, int cot, int address, byte[] info) throws Exception{
		byte[] duibyte = new byte[]{(byte) type,(byte) vsq,(byte) cot,(byte) address};
		dui.decode(duibyte);		
		io = info;
	}

}
