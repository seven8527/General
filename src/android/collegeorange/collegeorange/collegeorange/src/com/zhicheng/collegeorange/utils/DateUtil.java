package com.zhicheng.collegeorange.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import android.text.TextUtils;

public class DateUtil {
	// static SimpleDateFormat sDate = new
	// SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/**
	 * 将时间戳转为代表"距现在多久之前"的字符串
	 * 
	 * @param timeStr
	 *            时间戳
	 * @return
	 */
	public static String getStandardDate(String timeStr) {
		if (TextUtils.isEmpty(timeStr)) {
			return "";
		}
		StringBuffer sb = new StringBuffer();
		try {
			Date date = dateFormat.parse(timeStr);
			long beginTime = date.getTime();
			long time = System.currentTimeMillis() - beginTime;
			long mill = (long) Math.ceil(time / 1000);// 秒前
			long minute = (long) Math.ceil(time / 60 / 1000.0f);// 分钟前
			long hour = (long) Math.ceil(time / 60 / 60 / 1000.0f);// 小时
			long day = (long) Math.ceil(time / 24 / 60 / 60 / 1000.0f);// 天前
			if (day - 1 > 0) {
				sb.append(day + "天");
			} else if (hour - 1 > 0) {
				if (hour >= 24) {
					sb.append("1天");
				} else {
					sb.append(hour + "小时");
				}
			} else if (minute - 1 > 0) {
				if (minute == 60) {
					sb.append("1小时");
				} else {
					sb.append(minute + "分钟");
				}
			} else if (mill - 1 > 0) {
				if (mill == 60) {
					sb.append("1分钟");
				} else {
					sb.append(mill + "秒");
				}
			} else {
				sb.append("刚刚");
			}
			if (!sb.toString().equals("刚刚")) {
				sb.append("前");
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return sb.toString();
	}

	private final static long minute = 60 * 1000;// 1分钟
	private final static long hour = 60 * minute;// 1小时
	private final static long day = 24 * hour;// 1天
	private final static long month = 31 * day;// 月
	private final static long year = 12 * month;// 年

	/**
	 * 返回文字描述的日期
	 * 
	 * @param date
	 * @return
	 */
	public static String getTimeFormatText(String timeStr) {
		try {
			long diff = 0;
			try {
				long time = Long.valueOf(timeStr);
				diff = System.currentTimeMillis() - time;
			} catch (Exception e) {
				diff = System.currentTimeMillis() - dateFormat.parse(timeStr).getTime();
			}

			long r = 0;
			if (diff > year) {
				r = (diff / year);
				return r + "年前";
			}
			if (diff > month) {
				r = (diff / month);
				return r + "个月前";
			}
			if (diff > day) {
				r = (diff / day);
				return r + "天前";
			}
			if (diff > hour) {
				r = (diff / hour);
				return r + "小时前";
			}
			if (diff > 5 * minute) {
				r = (diff / minute);
				return r + "分钟前";
			}
		} catch (ParseException e) {
			return null;
		}
		return "刚刚";
	}

	public static int getBetweenTime(String date) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		int betweenTime = 3;
		try {
			Date mDate = sdf.parse(date);
			Date dateBegin = new Date(System.currentTimeMillis());// 获取当前时间
			if (dateBegin.getYear() == mDate.getYear() && mDate.getMonth() == dateBegin.getMonth()) {
				int day1 = dateBegin.getDate();
				int day2 = mDate.getDate();
				betweenTime = day1 - day2;
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return betweenTime;
	}

	public static String formatDate(Date date) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		String strDate = formatter.format(date);
		return strDate;
	}
	
	public static String currentFormatDate() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String strDate = formatter.format(new Date());
		return strDate;
	}


	/**
	 * 两个时间相差距离多少天多少小时多少分
	 * 
	 * @param str1
	 *            时间参数 1 格式：199001011200
	 * @param str2
	 *            时间参数 2 格式：200901011200
	 * @return String 返回值为：xx天xx小时xx分
	 */
	public static String getDistanceTime(String str1, String str2, int type) {
		DateFormat df = new SimpleDateFormat("MMddHHmm");
		Date one;
		Date two;
		long day = 0;
		long hour = 0;
		long min = 0;
		try {
			one = df.parse(str1);
			two = df.parse(str2);
			long time1 = one.getTime();
			long time2 = two.getTime();
			long diff;
			if (time1 < time2) {
				diff = time2 - time1;
			} else {
				diff = time1 - time2;
			}
			day = diff / (24 * 60 * 60 * 1000);
			hour = (diff / (60 * 60 * 1000) - day * 24);
			min = ((diff / (60 * 1000)) - day * 24 * 60 - hour * 60);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		if (day <= 0) {
			if (type == 0) {
				return hour + ":" + min;
			} else {
				return hour + "小时" + min + "分";
			}
		} else if (type == 1) {
			return hour + "小时" + min + "分";
		} else {
			return day + "天" + hour + "小时" + min + "分";
		}
	}

	/**
	 * 根据日期返回星期
	 * 
	 * @param sDate
	 * @return
	 */
	public static String getFullDateWeekTime(String sDate) {
		try {
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			Date date = format.parse(sDate);
			format.applyPattern("E");
			return format.format(date);
		} catch (Exception ex) {
			return "";
		}
	}

	public static ArrayList<String> getWeek() {
		ArrayList<String> strings = new ArrayList<String>();
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyyMMdd");
		String mDate = sDateFormat.format(new java.util.Date());
		String week = getFullDateWeekTime(mDate);
		if ("星期一".equals(week) || "周一".equals(week)) {
			strings.add(getAfterDate(6));
			strings.add(getAfterDate(5));
			strings.add(getAfterDate(4));
			strings.add(getAfterDate(3));
			strings.add(getAfterDate(2));
			strings.add(getAfterDate(1));
			strings.add(mDate);
		} else if ("星期二".equals(week) || "周二".equals(week)) {
			strings.add(getAfterDate(5));
			strings.add(getAfterDate(4));
			strings.add(getAfterDate(3));
			strings.add(getAfterDate(2));
			strings.add(getAfterDate(1));
			strings.add(mDate);
			strings.add(getBeforeDate(1));
		} else if ("星期三".equals(week) || "周三".equals(week)) {
			strings.add(getAfterDate(4));
			strings.add(getAfterDate(3));
			strings.add(getAfterDate(2));
			strings.add(getAfterDate(3));
			strings.add(mDate);
			strings.add(getBeforeDate(1));
			strings.add(getBeforeDate(2));
		} else if ("星期四".equals(week) || "周四".equals(week)) {
			strings.add(getAfterDate(3));
			strings.add(getAfterDate(2));
			strings.add(getAfterDate(1));
			strings.add(mDate);
			strings.add(getBeforeDate(1));
			strings.add(getBeforeDate(2));
			strings.add(getBeforeDate(3));
		} else if ("星期五".equals(week) || "周五".equals(week)) {
			strings.add(getAfterDate(2));
			strings.add(getAfterDate(1));
			strings.add(mDate);
			strings.add(getBeforeDate(1));
			strings.add(getBeforeDate(2));
			strings.add(getBeforeDate(3));
			strings.add(getBeforeDate(4));
		} else if ("星期六".equals(week) || "周六".equals(week)) {
			strings.add(getAfterDate(1));
			strings.add(mDate);
			strings.add(getBeforeDate(1));
			strings.add(getBeforeDate(2));
			strings.add(getBeforeDate(3));
			strings.add(getBeforeDate(4));
			strings.add(getBeforeDate(5));
		} else if ("星期日".equals(week) || "周日".equals(week)) {
			strings.add(getBeforeDate(1));
			strings.add(getBeforeDate(2));
			strings.add(getBeforeDate(3));
			strings.add(getBeforeDate(4));
			strings.add(getBeforeDate(5));
			strings.add(getBeforeDate(6));
			strings.add(mDate);
		}
		return strings;
	}

	public static String[] getWeek1() {
		String[] strings = new String[7];
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyyMMdd");
		String mDate = sDateFormat.format(new java.util.Date());
		String week = getFullDateWeekTime(mDate);
		if ("星期一".equals(week) || "周一".equals(week)) {
			strings[0] = mDate;
			strings[1] = getAfterDate(1);
			strings[2] = getAfterDate(2);
			strings[3] = getAfterDate(3);
			strings[4] = getAfterDate(4);
			strings[5] = getAfterDate(5);
			strings[6] = getAfterDate(6);
		} else if ("星期二".equals(week) || "周二".equals(week)) {
			strings[0] = getBeforeDate(1);
			strings[1] = mDate;
			strings[2] = getAfterDate(1);
			strings[3] = getAfterDate(2);
			strings[4] = getAfterDate(3);
			strings[5] = getAfterDate(4);
			strings[6] = getAfterDate(5);
		} else if ("星期三".equals(week) || "周三".equals(week)) {
			strings[0] = getBeforeDate(1);
			strings[1] = getBeforeDate(2);
			strings[2] = mDate;
			strings[3] = getAfterDate(1);
			strings[4] = getAfterDate(2);
			strings[5] = getAfterDate(3);
			strings[6] = getAfterDate(4);
		} else if ("星期四".equals(week) || "周四".equals(week)) {
			strings[0] = getBeforeDate(3);
			strings[1] = getBeforeDate(2);
			strings[2] = getBeforeDate(1);
			strings[3] = mDate;
			strings[4] = getAfterDate(3);
			strings[5] = getAfterDate(4);
			strings[6] = getAfterDate(5);
		} else if ("星期五".equals(week) || "周五".equals(week)) {
			strings[0] = getBeforeDate(4);
			strings[1] = getBeforeDate(3);
			strings[2] = getBeforeDate(2);
			strings[3] = getBeforeDate(1);
			strings[4] = mDate;
			strings[5] = getAfterDate(1);
			strings[6] = getAfterDate(2);
		} else if ("星期六".equals(week) || "周六".equals(week)) {
			strings[0] = getBeforeDate(5);
			strings[1] = getBeforeDate(4);
			strings[2] = getBeforeDate(3);
			strings[3] = getBeforeDate(2);
			strings[4] = getBeforeDate(1);
			strings[5] = mDate;
			strings[6] = getAfterDate(1);
		} else if ("星期日".equals(week) || "周日".equals(week)) {
			strings[0] = getBeforeDate(6);
			strings[1] = getBeforeDate(5);
			strings[2] = getBeforeDate(4);
			strings[3] = getBeforeDate(3);
			strings[4] = getBeforeDate(2);
			strings[5] = getBeforeDate(1);
			strings[6] = mDate;
		}
		return strings;
	}

	public static String[] get2Days() {
		String[] strings = new String[2];
		SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyyMMdd");
		String mDate = sDateFormat.format(new java.util.Date());
		String week = getFullDateWeekTime(mDate);
		strings[0] = mDate;
		strings[1] = getBeforeDate(1);
		return strings;
	}

	public static ArrayList<String> getHour() {
		ArrayList<String> strings = new ArrayList<String>();
		strings.add("0:00");
		strings.add("21:00");
		strings.add("18:00");
		strings.add("15:00");
		strings.add("12:00");
		strings.add("9:00");
		strings.add("6:00");
		return strings;
	}

	/**
	 * 当天日期前几天
	 */
	public static String getBeforeDate(int days) {
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new java.util.Date());
		calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - days);
		return df.format(calendar.getTime());
	}

	/**
	 * 当天日期后几天
	 */
	public static String getAfterDate(int days) {
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new java.util.Date());
		calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) + days);
		return df.format(calendar.getTime());
	}

	static DateFormat df = new SimpleDateFormat("MMddHHmm");

	public static String getDistanceTime(long time1, long time2) {
		long day = 0;
		long hour = 0;
		long min = 0;
		long diff;
		if (time1 < time2) {
			diff = time2 - time1;
		} else {
			diff = time1 - time2;
		}
		day = diff / (24 * 60 * 60 * 1000);
		hour = (diff / (60 * 60 * 1000) - day * 24);
		min = ((diff / (60 * 1000)) - day * 24 * 60 - hour * 60);
		if (day <= 0) {
			return hour + "小时" + min + "分";
		} else {
//			return day + "天" + hour + "小时" + min + "分";
			return null;
		}
	}
	
	public static Calendar getCalendarbyString(String timeStr){
		Calendar cal = Calendar.getInstance();
		try {
			long time = Long.valueOf(timeStr);
			cal.setTimeInMillis(time);
		} catch (Exception e) {
			
		}
		return cal;
	}

}
