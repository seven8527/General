package com.zhicheng.collegeorange.view;

import java.util.Random;


public class RandomUtils
{
    public static final String allChar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"; 
    public static final String letterChar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    /** 
     * 返回一个定长的随机纯字母字符串(只包含大小写字母) 
     * 
     * @param length 随机字符串长度 
     * @return 随机字符串 
     */ 
    public static String generateMixString(int length) { 
            StringBuffer sb = new StringBuffer(); 
            Random random = new Random(); 
            for (int i = 0; i < length; i++) { 
                    sb.append(allChar.charAt(random.nextInt(letterChar.length()))); 
            } 
            return sb.toString(); 
    } 

    public static void main(String[] args) { 
            System.out.println(generateMixString(15)); 
    }
    private static Random mRandom ;
    public static int getRandomValue(int max){
    	if(mRandom == null){
    		mRandom = new Random();
    	}
    	return mRandom.nextInt(max);
    }
}
