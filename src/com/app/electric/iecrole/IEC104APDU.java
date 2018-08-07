package com.app.electric.iecrole;

import java.util.Arrays;

import com.app.utility.Machine;

public class IEC104APDU implements MessageElement {
	public IEC104APCI apci = new IEC104APCI();
	public IEC103ASDU asdu = new IEC103ASDU();
	@Override
	public void decode(byte[] message) throws Exception {
		if (message[1] != 0x68){
			throw new Exception("Message is not IEC104 message");
		}
		int apdulen = message[2];
		if (message.length != apdulen){
			throw new Exception("Message length is not right");
		}
		apci.decode(Arrays.copyOfRange(message, 0, 6));
		asdu.decode(Arrays.copyOfRange(message, 6, message.length));
	}
	@Override
	public byte[] code() throws Exception {
		byte[] asduByte = asdu.code();
		apci.len = asduByte.length + 4;
		byte[] apciByte = apci.code();
		return Machine.concatAll(apciByte, asduByte);
	}
}
