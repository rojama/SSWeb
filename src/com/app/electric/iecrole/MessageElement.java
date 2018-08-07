package com.app.electric.iecrole;

public interface MessageElement {
	
	/**
	 * abstract method for decoding sub information data from physical data
	 * @return 
	 */
	public abstract void decode(byte[] message) throws Exception;
	
	/**
	 * abstract method for coding physical data from sub information data
	 */
	public abstract byte[] code() throws Exception;
}
