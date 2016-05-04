package com.zhicheng.collegeorange.utils;

import java.io.FileInputStream;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import android.text.TextUtils;

public class MD5 {

	public static String digestString(String str) {
		try {
			MessageDigest md5 = MessageDigest.getInstance("MD5");
			md5.update(str.getBytes());
			String digest = toHexString(md5.digest());

			return digest;
		} catch (NoSuchAlgorithmException e) {
			return "";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	public static String digestFileContent(String filename) {
		if (TextUtils.isEmpty(filename)) {
			return null;
		}

		InputStream fis = null;
		try {
			byte[] buffer = new byte[1024 * 1024];
			int totalNum = 0;
			int numRead = 0;

			fis = new FileInputStream(filename);
			MessageDigest md5 = MessageDigest.getInstance("MD5");

			long startTime = System.currentTimeMillis();
			while ((numRead = fis.read(buffer)) > 0) {
				md5.update(buffer, 0, numRead);
				totalNum += numRead;
			}
			String digest = toHexString(md5.digest());
			long endTime = System.currentTimeMillis();

			return digest;
		} catch (NoSuchAlgorithmException e) {
			return "";
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		} finally {
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	private static final char HEX_DIGITS[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

	private static String toHexString(byte[] b) {
		StringBuilder sb = new StringBuilder(b.length * 2);
		for (int i = 0; i < b.length; i++) {
			sb.append(HEX_DIGITS[(b[i] & 0xf0) >>> 4]);
			sb.append(HEX_DIGITS[b[i] & 0x0f]);
		}

		return sb.toString();
	}
}
