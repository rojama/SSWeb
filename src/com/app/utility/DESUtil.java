/**
 * ©2014 融建信息技术(厦门)有限公司 版权所有
 */
package com.app.utility;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.spec.AlgorithmParameterSpec;
import java.security.spec.KeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;

/**
 * @author <a href="mailto:shiny_vc@163.com">陈云亮</a> <br/>
 * @since 5.0.0 <br/>
 */
public class DESUtil {

	Cipher ecipher;
	Cipher dcipher;

	// 8-byte Salt
	byte[] salt = { (byte) 0xA9, (byte) 0x9B, (byte) 0xC8, (byte) 0x32,
			(byte) 0x56, (byte) 0x35, (byte) 0xE3, (byte) 0x03

	};

	int iterationCount = 19;

	public DESUtil(String passPhrase) {

		try {
			// Create the key
			KeySpec keySpec = new PBEKeySpec(passPhrase.toCharArray(), salt,
					iterationCount);
			SecretKey key = SecretKeyFactory.getInstance("PBEWithMD5AndDES")
					.generateSecret(keySpec);
			ecipher = Cipher.getInstance(key.getAlgorithm());
			dcipher = Cipher.getInstance(key.getAlgorithm());

			// Prepare the parameter to the ciphers
			AlgorithmParameterSpec paramSpec = new PBEParameterSpec(salt,
					iterationCount);

			// Create the ciphers
			ecipher.init(Cipher.ENCRYPT_MODE, key, paramSpec);
			dcipher.init(Cipher.DECRYPT_MODE, key, paramSpec);
		} catch (Exception ex) {
			throw new RuntimeException(ex);
		}
	}

	public String encrypt(String str) throws UnsupportedEncodingException,
			IllegalStateException, IllegalBlockSizeException,
			BadPaddingException {

		// Encode the string into bytes using utf-8
		byte[] utf8 = str.getBytes("UTF8");

		// Encrypt
		byte[] enc = ecipher.doFinal(utf8);

		// Encode bytes to base64 to get a string
		return new String(org.apache.commons.codec.binary.Base64.encodeBase64(enc));
		//return new sun.misc.BASE64Encoder().encode(enc);

	}

	public String decrypt(String str) throws IOException,
			IllegalStateException, IllegalBlockSizeException,
			BadPaddingException {

		// Decode base64 to get bytes
		byte[] dec = org.apache.commons.codec.binary.Base64.decodeBase64(str);
		//byte[] dec = new sun.misc.BASE64Decoder().decodeBuffer(str);

		// Decrypt
		byte[] utf8 = dcipher.doFinal(dec);

		// Decode using utf-8
		return new String(utf8, "UTF8");

	}

	private static DESUtil instance = new DESUtil("Granite is the way");

	public final static String encode(String str) {
		try {
			return instance.encrypt(str);
		} catch (Exception ex) {
			return str;
		}
	}

	public final static String decode(String str) {
		try {
			return instance.decrypt(str);
		} catch (Exception ex) {
			return str;
		}
	}
	
}
