package com.zhicheng.collegeorange;

import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.UUID;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.FileEntity;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlarmManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PorterDuff.Mode;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.ExifInterface;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.Surface;
import android.view.View;

import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.cache.memory.impl.WeakMemoryCache;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.zhicheng.collegeorange.main.SharedHelper;


public class Utils {

	public static final String PIC_SHARED_PREFERENCE = "pic_share";

	public static final String IS_FIRST_SHARE = "first_share";

	public static final String NAME_CURVE = "name_curve";

	public static String URL_KEY_API_VERSION = "APIVersion";
	public static String URL_KEY_ACTION = "Action";
	public static String URL_KEY_DEVICE_TYPE = "Device-Type";
	public static String URL_KEY_UUID = "UUID";
	public static String URL_KEY_CHARSET = "Charset";
	public static String URL_KEY_CONTENT_TYPE = "Content-Type";
	public static String URL_KEY_USER_ID = "UserID";
	public static String URL_KEY_SESSION_ID = "SessionID";

	public static String URL_KEY_RESULT_CODE = "Result-Code";

	public static String URL_VALUE_API_VERSION = "1.0";
	public static String URL_VALUE_UUID = "UUID";
	public static String URL_VALUE_CHARSET = "UTF-8";
	public static String URL_VALUE_CONTENT_TYPE = "application/json";
	
	public static final String REMOTE_BASE_RUL = "http://123.56.233.226:80";
	
	public static final String REMOTE_SERVER_URL = REMOTE_BASE_RUL ;
	
	public static final String REMOTE_SERVER_URL_FOR_DOWNLOAD = REMOTE_BASE_RUL + "/down_avatar.php?avatar=";
	
	public static final String PRE_KEY_BLACKLIST_PHONE = "key_blacklist_phone";

	public static final String REMOTE_SERVER_URL_FOR_UPLOAD_VOICE = REMOTE_BASE_RUL + "/upload_voice_wt";

	public static final String REMOTE_SERVER_URL_FOR_SHARE_UPLOAD_VOICE = REMOTE_BASE_RUL + "/share/upload/voice";

	public static final String REMOTE_SERVER_URL_FOR_SHARE_IMAGE = REMOTE_BASE_RUL + "/share/upload/image";

	public static final String REMOTE_SERVER_URL_FOR_SHARE_DOWNLOAD_VOICE = REMOTE_BASE_RUL
			+ "/file/voice?uid=";
	

	public static final String REMOTE_SERVER_URL_FOR_DOWNLOAD_VOICE = REMOTE_BASE_RUL
			+ "/download_voice_wt?voice_file=";
	
	public static final String REMOTE_SERVER_URL_FOR_DOWNLOAD_IMAGE = REMOTE_BASE_RUL
			+ "/download_voice_wt?image_file=";

	public static final String REMOTE_SERVER_URL_FOR_UPLOAD = REMOTE_BASE_RUL + "/up_avatar.php";


	public static final String UPLOAD_PIC =  REMOTE_BASE_RUL + "/file/image?uid=";
	public static final String DOWNLOAD_PIC = REMOTE_BASE_RUL + "/file/image?uid=";

	public static final String LIGHT_APP_URL = REMOTE_BASE_RUL + "/light_app";
	

	public static final String ABOUT_URL = "http://cleverorange.cn/mobile/aboutus.aspx";
	public static final String NEW_VERSION_DOWNLOAD = "http://cleverorange.cn/appdownload.html";
	
	public static final String SMS_SEND_KEY = "10b21db083d38";
	public static final String SMS_SEND_SECRET = "30448c7ef7ea8c41e016d4290751b433";
	
	public static final String LOGIN_STATE_CHANGE = "LOGIN_STATE_CHANGE";
	public static final String USER_INFO_CHANGE = "USER_INFO_CHANGE";

	private Utils() {
		throw new IllegalAccessError("Cannot initialize a Utils object!");
	}

	public static boolean isInChina(Context ctx) {
		TelephonyManager tm = (TelephonyManager) ctx.getSystemService(Context.TELEPHONY_SERVICE);
		String country = tm.getNetworkCountryIso();
		if ("cn".equalsIgnoreCase(country) || "tw".equalsIgnoreCase(country)) {
			return true;
		} else {
			return false;
		}

	}

	public static boolean isChineseLanguage(Context ctx) {
		String lang = Locale.getDefault().getLanguage();
		if (lang != null && lang.startsWith("zh")) {
			return true;
		}
		return false;
	}

	public static File getPictureDir() {
		File sdDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
		File dir = new File(sdDir, "TOMOON");

		if (!dir.exists()) {
			dir.mkdirs();
		}
		return dir;
	}

	public static Bitmap ViewToBitmap(View view) {
		Bitmap returnedBitmap = Bitmap.createBitmap(view.getWidth(), view.getHeight(), Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(returnedBitmap);
		Drawable bgDrawable = view.getBackground();
		if (bgDrawable != null)
			bgDrawable.draw(canvas);
		else
			canvas.drawColor(Color.WHITE);
		view.draw(canvas);
		return returnedBitmap;
	}

	public static Bitmap ViewToBitmap(View view, int height) {
		Bitmap returnedBitmap = Bitmap.createBitmap(view.getWidth(), view.getHeight() - height,
				Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(returnedBitmap);
		canvas.translate(0, -height);
		Drawable bgDrawable = view.getBackground();
		if (bgDrawable != null)
			bgDrawable.draw(canvas);
		else
			canvas.drawColor(Color.WHITE);
		view.draw(canvas);
		return returnedBitmap;
	}

	public static boolean isFirstShare(Context context) {
		SharedPreferences sp = context.getSharedPreferences(PIC_SHARED_PREFERENCE, Context.MODE_PRIVATE);
		boolean result = sp.getBoolean(IS_FIRST_SHARE, true);
		if (result) {
			sp.edit().putBoolean(IS_FIRST_SHARE, false).commit();
		}
		return result;
	}

	public static String getNameCurved(Context context) {
		return context.getSharedPreferences(PIC_SHARED_PREFERENCE, Context.MODE_PRIVATE).getString(NAME_CURVE, "");

	}

	public static void writeNameCurved(Context context, String name) {
		context.getSharedPreferences(PIC_SHARED_PREFERENCE, Context.MODE_PRIVATE).edit().putString(NAME_CURVE, name)
				.commit();
	}

	// push notification

	
	/**
	 * public static boolean getPushState(Context context) { return
	 * context.getSharedPreferences(LaunchUtils.sPushPref,
	 * Context.MODE_PRIVATE).getBoolean(sPush, true); }
	 * 
	 * public static void writePushState(Context context, boolean push) {
	 * context.getSharedPreferences(LaunchUtils.sPushPref,
	 * Context.MODE_PRIVATE).edit().putBoolean(sPush, push).commit(); }
	 **/

	public static void setDate(Context context, int year, int month, int day) {
		Calendar c = Calendar.getInstance();

		c.set(Calendar.YEAR, year);
		c.set(Calendar.MONTH, month);
		c.set(Calendar.DAY_OF_MONTH, day);
		long when = c.getTimeInMillis();

		if (when / 1000 < Integer.MAX_VALUE) {
			((AlarmManager) context.getSystemService(Context.ALARM_SERVICE)).setTime(when);
		}
	}

	public static void setTime(Context context, int hourOfDay, int minute) {
		Calendar c = Calendar.getInstance();

		c.set(Calendar.HOUR_OF_DAY, hourOfDay);
		c.set(Calendar.MINUTE, minute);
		c.set(Calendar.SECOND, 0);
		c.set(Calendar.MILLISECOND, 0);
		long when = c.getTimeInMillis();

		if (when / 1000 < Integer.MAX_VALUE) {
			((AlarmManager) context.getSystemService(Context.ALARM_SERVICE)).setTime(when);
		}
	}

	public static StringBuilder formatOffset(StringBuilder sb, TimeZone tz, Date d) {
		int off = tz.getOffset(d.getTime()) / 1000 / 60;

		sb.append("GMT");
		if (off < 0) {
			sb.append('-');
			off = -off;
		} else {
			sb.append('+');
		}

		int hours = off / 60;
		int minutes = off % 60;

		sb.append((char) ('0' + hours / 10));
		sb.append((char) ('0' + hours % 10));

		sb.append(':');

		sb.append((char) ('0' + minutes / 10));
		sb.append((char) ('0' + minutes % 10));

		return sb;
	}

	
	
	public static HttpResponse getResponse(Context context,String url, String action, JSONObject obj, int connectionTime, int soTime)
			throws Exception {

		BasicHttpParams httpParameters = new BasicHttpParams();
		HttpConnectionParams.setConnectionTimeout(httpParameters, connectionTime);
		HttpConnectionParams.setSoTimeout(httpParameters, soTime);
		HttpClient httpclient = new DefaultHttpClient(httpParameters);
		HttpPost httppost = new HttpPost(url);
		httppost.addHeader(URL_KEY_API_VERSION, URL_VALUE_API_VERSION);
		httppost.addHeader(URL_KEY_ACTION, action);
		
		httppost.addHeader(URL_KEY_CHARSET, URL_VALUE_CHARSET);
		httppost.addHeader(URL_KEY_CONTENT_TYPE, URL_VALUE_CONTENT_TYPE);
		httppost.addHeader(URL_KEY_USER_ID, getMyUserName(context));
		httppost.addHeader(URL_KEY_SESSION_ID, getSessionID(context));
		if (obj != null) {
			httppost.setEntity(new StringEntity(obj.toString(), "UTF-8"));
		}

		HttpResponse response = httpclient.execute(httppost);
		return response;
	}

	public static HttpResponse getResponse(String url, JSONObject obj, int connectionTime, int soTime)
			throws Exception {
		BasicHttpParams httpParameters = new BasicHttpParams();
		HttpConnectionParams.setConnectionTimeout(httpParameters, connectionTime);
		HttpConnectionParams.setSoTimeout(httpParameters, soTime);
		HttpClient httpclient = new DefaultHttpClient(httpParameters);
		HttpPost httppost = new HttpPost(url);
		httppost.addHeader(URL_KEY_API_VERSION, URL_VALUE_API_VERSION);
		httppost.addHeader(URL_KEY_CHARSET, URL_VALUE_CHARSET);
		httppost.addHeader(URL_KEY_CONTENT_TYPE, URL_VALUE_CONTENT_TYPE);
		if (obj != null) {
			httppost.setEntity(new StringEntity(obj.toString(), "UTF-8"));
		}
		HttpResponse response = httpclient.execute(httppost);
		return response;
	}

	public static HttpResponse getResponse(String url, int connectionTime, int soTime) {
		HttpGet httpGet = new HttpGet(url);
		HttpClient httpClient = new DefaultHttpClient();
		try {
			HttpResponse response = httpClient.execute(httpGet);
			return response;
		} catch (Exception e) {
			//WriteLogFile.writeFileToSD("服务器没有响应 原因：" + e.getMessage(), "weather");
			e.printStackTrace();
		}
		return null;
	}
	
	public static HttpResponse deteteResponse(String url, JSONObject obj){
		try {
	        HttpEntity entity = new StringEntity(obj.toString());
	        HttpClient httpClient = new DefaultHttpClient();
	        HttpDeleteWithBody httpDeleteWithBody = new HttpDeleteWithBody(url);
	        httpDeleteWithBody.setEntity(entity);

	        HttpResponse response = httpClient.execute(httpDeleteWithBody);
	        return response;
	    } catch (UnsupportedEncodingException e) {
	        e.printStackTrace();
	    } catch (ClientProtocolException e) {
	        e.printStackTrace();
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
		return null;
	}

	public static ArrayList<String> getPrefArray(Context context, String key) {
		String regularEx = "#";
		String[] str = null;
		String values;
		values = SharedHelper.getShareHelper(context).getString(key, "");
		str = values.split(regularEx);
		ArrayList<String> arrayList = new ArrayList<String>();
		for (int i = 0; i < str.length; i++) {
			if (!TextUtils.isEmpty(str[i]))
				arrayList.add(str[i]);
		}
		return arrayList;
	}

	public static void setPrefArray(Context context, ArrayList<String> values, String key) {
		String regularEx = "#";
		String str = "";
		if (values != null && values.size() > 0) {
			for (String value : values) {
				str += value;
				str += regularEx;
			}
			SharedHelper.getShareHelper(context).putString(key, str);
		}
	}

	public static Bitmap rotateImage(Bitmap src, float degree) {
		// create new matrix
		Matrix matrix = new Matrix();
		// setup rotation degree
		matrix.postRotate(degree);
		Bitmap bmp = Bitmap.createBitmap(src, 0, 0, src.getWidth(), src.getHeight(), matrix, true);
		return bmp;
	}	

	public static Bitmap transform(Matrix scaler, Bitmap source, int targetWidth, int targetHeight, boolean scaleUp) {

		int deltaX = source.getWidth() - targetWidth;
		int deltaY = source.getHeight() - targetHeight;
		if (!scaleUp && (deltaX < 0 || deltaY < 0)) {
			/*
			 * In this case the bitmap is smaller, at least in one dimension,
			 * than the target. Transform it by placing as much of the image as
			 * possible into the target and leaving the top/bottom or left/right
			 * (or both) black.
			 */
			Bitmap b2 = Bitmap.createBitmap(targetWidth, targetHeight, Bitmap.Config.ARGB_8888);
			Canvas c = new Canvas(b2);

			int deltaXHalf = Math.max(0, deltaX / 2);
			int deltaYHalf = Math.max(0, deltaY / 2);
			Rect src = new Rect(deltaXHalf, deltaYHalf, deltaXHalf + Math.min(targetWidth, source.getWidth()),
					deltaYHalf + Math.min(targetHeight, source.getHeight()));
			int dstX = (targetWidth - src.width()) / 2;
			int dstY = (targetHeight - src.height()) / 2;
			Rect dst = new Rect(dstX, dstY, targetWidth - dstX, targetHeight - dstY);
			c.drawBitmap(source, src, dst, null);
			return b2;
		}
		float bitmapWidthF = source.getWidth();
		float bitmapHeightF = source.getHeight();

		float bitmapAspect = bitmapWidthF / bitmapHeightF;
		float viewAspect = (float) targetWidth / targetHeight;

		if (bitmapAspect > viewAspect) {
			float scale = targetHeight / bitmapHeightF;
			if (scale < .9F || scale > 1F) {
				scaler.setScale(scale, scale);
			} else {
				scaler = null;
			}
		} else {
			float scale = targetWidth / bitmapWidthF;
			if (scale < .9F || scale > 1F) {
				scaler.setScale(scale, scale);
			} else {
				scaler = null;
			}
		}

		Bitmap b1;
		if (scaler != null) {
			// this is used for minithumb and crop, so we want to mFilter here.
			b1 = Bitmap.createBitmap(source, 0, 0, source.getWidth(), source.getHeight(), scaler, true);
		} else {
			b1 = source;
		}

		int dx1 = Math.max(0, b1.getWidth() - targetWidth);
		int dy1 = Math.max(0, b1.getHeight() - targetHeight);

		Bitmap b2 = Bitmap.createBitmap(b1, dx1 / 2, dy1 / 2, targetWidth, targetHeight);

		if (b1 != source) {
			b1.recycle();
		}

		return b2;
	}

	public static void closeSilently(Closeable c) {

		if (c == null)
			return;
		try {
			c.close();
		} catch (Throwable t) {
			// do nothing
		}
	}

	public static int getOrientationInDegree(Activity activity) {

		int rotation = activity.getWindowManager().getDefaultDisplay().getRotation();
		int degrees = 0;

		switch (rotation) {
		case Surface.ROTATION_0:
			degrees = 0;
			break;
		case Surface.ROTATION_90:
			degrees = 90;
			break;
		case Surface.ROTATION_180:
			degrees = 180;
			break;
		case Surface.ROTATION_270:
			degrees = 270;
			break;
		}
		return degrees;
	}

	public static String getSessionID(Context context) {
		return SharedHelper.getShareHelper(context).getString(SharedHelper.USER_SESSION_ID, "");
	}

	public static String getMyUserName(Context context) {
		return SharedHelper.getShareHelper(context).getString(SharedHelper.USER_NAME, "");
	}

	// 只压缩大图片
	public static Bitmap decodCompressionBitmapFromFile(String filename, int reqWidth, int reqHeight) {
		// First decode with inJustDecodeBounds=true to check dimensions
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(filename, options);

		Bitmap bitmap = null;
		int rawImgW = options.outWidth;
		int rawImgH = options.outHeight;

		if ((reqWidth > rawImgW) && (reqHeight > rawImgH)) {
			reqWidth = rawImgW;
			reqHeight = rawImgH;
		}

		int rotate = Utils.getExifOrientation(filename);

		// Calculate inSampleSize
		int inSampleSize = 0;
		if (rotate == 0 || rotate == 180) {
			inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);
		} else {
			inSampleSize = calculateInSampleSize(options, reqHeight, reqWidth);
		}

		options.inSampleSize = inSampleSize;
		options.inJustDecodeBounds = false;
		bitmap = BitmapFactory.decodeFile(filename, options);

		if (reqWidth <= 0 || reqHeight <= 0) {
			reqWidth = rawImgW;
			reqHeight = rawImgH;
		}

		if (bitmap != null) {
			float scale = 1.0f;
			Bitmap bitmapTmp = bitmap;
			if (rotate == 0 || rotate == 180) {
				if (options.outWidth > reqWidth || options.outHeight > reqHeight) {
					scale = (float) Math.min(1.0 * reqWidth / bitmapTmp.getWidth(),
							1.0 * reqHeight / bitmapTmp.getHeight());
				}
			} else {
				if ((options.outWidth > reqWidth || options.outHeight > reqHeight)) {
					scale = (float) Math.min(1.0 * reqHeight / bitmapTmp.getWidth(),
							1.0 * reqWidth / bitmapTmp.getHeight());
				}
			}

			if (rotate != 0 || Math.abs(scale - 1.0) > 0.001) {
				Matrix matrix = new Matrix();
				matrix.setRotate(rotate);
				matrix.postScale(scale, scale);
				bitmap = Bitmap.createBitmap(bitmapTmp, 0, 0, bitmapTmp.getWidth(), bitmapTmp.getHeight(), matrix,
						false);
				bitmapTmp.recycle();
				bitmapTmp = null;
			}
		}

		return bitmap;
	}

	// 只压缩大图片
	public static Bitmap decodSuitableBitmapFromFile(String filename, int reqWidth, int reqHeight) {
		// First decode with inJustDecodeBounds=true to check dimensions
		final BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(filename, options);

		Bitmap bitmap = null;
		int rawImgW = options.outWidth;
		int rawImgH = options.outHeight;

		int rotate = Utils.getExifOrientation(filename);

		// Calculate inSampleSize
		int inSampleSize = 0;
		if (rotate == 0 || rotate == 180) {
			inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);
		} else {
			inSampleSize = calculateInSampleSize(options, reqHeight, reqWidth);
		}

		options.inSampleSize = inSampleSize;
		options.inJustDecodeBounds = false;
		bitmap = BitmapFactory.decodeFile(filename, options);

		if (reqWidth <= 0 || reqHeight <= 0) {
			reqWidth = rawImgW;
			reqHeight = rawImgH;
		}

		if (bitmap != null) {
			float scale = 1.0f;
			Bitmap bitmapTmp = bitmap;
			if (rotate == 0 || rotate == 180) {
				// if (options.outWidth > reqWidth || options.outHeight >
				// reqHeight) {
				scale = (float) Math.min(1.0 * reqWidth / bitmapTmp.getWidth(),
						1.0 * reqHeight / bitmapTmp.getHeight());
				// }
			} else {
				// if ((options.outWidth > reqWidth || options.outHeight >
				// reqHeight)) {
				scale = (float) Math.min(1.0 * reqHeight / bitmapTmp.getWidth(),
						1.0 * reqWidth / bitmapTmp.getHeight());
				// }
			}

			if (rotate != 0 || Math.abs(scale - 1.0) > 0.001) {
				Matrix matrix = new Matrix();
				matrix.setRotate(rotate);
				matrix.postScale(scale, scale);
				bitmap = Bitmap.createBitmap(bitmapTmp, 0, 0, bitmapTmp.getWidth(), bitmapTmp.getHeight(), matrix,
						false);
				bitmapTmp.recycle();
				bitmapTmp = null;
			}
		}

		return bitmap;
	}

	public static int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
		// Raw height and width of image
		final int height = options.outHeight;
		final int width = options.outWidth;
		int inSampleSize = 1;

		if (reqWidth <= 0 || reqHeight <= 0) {
			return inSampleSize;
		}

		if (height > reqHeight || width > reqWidth) {
			double heightSampleSize = (1.0 * height) / reqHeight;
			double widthSampleSize = (1.0 * width) / reqWidth;
			double maxSampleSize = Math.max(heightSampleSize, widthSampleSize);
			// if (heightSampleSize > widthSampleSize) {
			// if ((height%reqHeight) != 0) {
			// maxSampleSize += 1;
			// }
			// } else {
			// if ((width%reqWidth) != 0) {
			// maxSampleSize += 1;
			// }
			// }

			inSampleSize = (int) Math.floor(maxSampleSize);

			// This offers some additional logic in case the image has a strange
			// aspect ratio. For example, a panorama may have a much larger
			// width than height. In these cases the total pixels might still
			// end up being too large to fit comfortably in memory, so we should
			// be more aggressive with sample down the image (=larger
			// inSampleSize).

			final float totalPixels = width * height;

			// Anything more than 2x the requested pixels we'll sample down
			// further.
			final float totalReqPixelsCap = reqWidth * reqHeight * 2;

			while (totalPixels / (inSampleSize * inSampleSize) > totalReqPixelsCap) {
				inSampleSize++;
			}
		}

		return inSampleSize;
	}

	public static int getExifOrientation(String filePath) {
		int degree = 0;
		ExifInterface exif = null;
		int orientation = -1;
		try {
			exif = new ExifInterface(filePath);
		} catch (IOException e) {
			e.printStackTrace();
		}

		if (exif != null) {
			orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, -1);
			if (orientation != -1) {
				switch (orientation) {
				case ExifInterface.ORIENTATION_ROTATE_90:
					degree = 90;
					break;

				case ExifInterface.ORIENTATION_ROTATE_180:
					degree = 180;
					break;

				case ExifInterface.ORIENTATION_ROTATE_270:
					degree = 270;
					break;

				default:
					break;
				}
			}
		}

		return degree;
	}

	public static ImageLoaderConfiguration initImageLoader(Context context) {
		// This configuration tuning is custom. You can tune every option, you
		// may tune some of them,
		// or you can create default configuration by
		// ImageLoaderConfiguration.createDefault(this);
		// method.
		// File cacheDir
		// =StorageUtils.getOwnCacheDirectory(context,"imageloader/Cache");
		ImageLoaderConfiguration.Builder builder = new ImageLoaderConfiguration.Builder(context);
		builder.threadPriority(Thread.NORM_PRIORITY - 2);
		builder.denyCacheImageMultipleSizesInMemory();
		// builder.diskCache(new UnlimitedDiscCache(cacheDir))//存放目录
		builder.diskCacheFileNameGenerator(new Md5FileNameGenerator());
		builder.diskCacheSize(50 * 1024 * 1024); // 50Mb
		builder.memoryCache(new WeakMemoryCache());
		// builder.discCacheFileNameGenerator(CacheManager.getDefaultFileNameGenerator());
		builder.tasksProcessingOrder(QueueProcessingType.FIFO);
		// builder.writeDebugLogs(); // Remove for release app
		// builder.memoryCacheExtraOptions(maxSize, maxSize);// max width, max
		// height，即保存的每个缓存文件的最大长宽
		// builder.discCacheExtraOptions(maxSize, maxSize, null);//
		// 设置缓存的详细信息，最好不要设置这个
		ImageLoader.getInstance().init(builder.build());
		return builder.build();
	}

	public static Bitmap toRoundCorner(Bitmap bitmap, int pixels) {
		Bitmap output = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Config.ARGB_8888);
		Canvas canvas = new Canvas(output);
		final int color = 0xff424242;
		final Paint paint = new Paint();
		final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
		final RectF rectF = new RectF(rect);
		final float roundPx = pixels;
		paint.setAntiAlias(true);
		canvas.drawARGB(0, 0, 0, 0);
		paint.setColor(color);
		canvas.drawRoundRect(rectF, roundPx, roundPx, paint);
		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
		canvas.drawBitmap(bitmap, rect, rect, paint);
		return output;
	}

	public static Bitmap getCornerBitmap(Bitmap bitmap) {
		Bitmap output = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Config.ARGB_8888);
		Canvas canvas = new Canvas(output);

		final int color = 0xff424242;
		final Paint paint = new Paint();
		final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
		final RectF rectF = new RectF(rect);
		final float roundPx = 8;

		paint.setAntiAlias(true);
		canvas.drawARGB(0, 0, 0, 0);
		paint.setColor(color);
		canvas.drawRoundRect(rectF, roundPx, roundPx, paint);

		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
		canvas.drawBitmap(bitmap, rect, rect, paint);

		return output;
	}

	public static int getDateDayWitchCurTime(Long date1) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyymmdd");
		long betweenTime = 3;
		try {
			Date date = new Date(date1);// 通过日期格式的parse()方法将字符串转换成日期
			Date dateBegin = new Date(System.currentTimeMillis());// 获取当前时间
			if (dateBegin.getYear() == date.getYear() && date.getMonth() == dateBegin.getMonth()) {
				int day1 = dateBegin.getDate();
				int day2 = date.getDate();
				betweenTime = day1 - day2;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return (int) betweenTime;
	}

	public static byte[] bmpToByteArray(final Bitmap bmp, final boolean needRecycle) {
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		bmp.compress(CompressFormat.PNG, 100, output);
		if (needRecycle) {
			bmp.recycle();
		}

		byte[] result = output.toByteArray();
		try {
			output.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public static Bitmap getBitMap(String url) {
		URL myFileUrl = null;
		Bitmap bitmap = null;
		try {
			myFileUrl = new URL(url);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}
		try {
			HttpURLConnection conn = (HttpURLConnection) myFileUrl.openConnection();
			conn.setDoInput(true);
			conn.connect();
			InputStream is = conn.getInputStream();
			bitmap = BitmapFactory.decodeStream(is);
			is.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return bitmap;
	}

	public static String initPath(String path) {
		File tmpFile = null;
		try {
			final BitmapFactory.Options options = new BitmapFactory.Options();
			options.inJustDecodeBounds = true;
			BitmapFactory.decodeFile(path, options);
			int rawImgW = options.outWidth;
			int rawImgH = options.outHeight;
			// File tmp = new File(path);
			if ((rawImgW <= 1280) && (rawImgH <= 720)) {
				return path;
			} else {
				SimpleDateFormat timesdf = new SimpleDateFormat("yyyyMMddHHmmss");
				String FileTime = timesdf.format(new Date()).toString() + ".jpeg";// 获取
				tmpFile = new File(Environment.getExternalStorageDirectory() + "/TomoonPictrue", FileTime);
				try {
					tmpFile.createNewFile();
				} catch (Exception e) {
					e.printStackTrace();
					return null;
				}
				FileOutputStream output = null;
				try {
					output = new FileOutputStream(tmpFile);
				} catch (Exception e) {
					e.printStackTrace();
					return null;
				}
				Bitmap bm = Utils.decodCompressionBitmapFromFile(path, 1280, 720);
				if (bm == null) {
					try {
						output.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
					return null;
				}
				bm.compress(Bitmap.CompressFormat.JPEG, 100, output);
				try {
					output.flush();
				} catch (Exception e) {
					e.printStackTrace();
					return null;
				}
			}
			return tmpFile.getPath();
		} catch (Exception e) {
			e.printStackTrace();
			Log.e("bailu", "UploadPictureToService err");
		}
		return null;
	}

	public static float dp2px(Resources resources, float dp) {
		final float scale = resources.getDisplayMetrics().density;
		return dp * scale + 0.5f;
	}

	public static float sp2px(Resources resources, float sp) {
		final float scale = resources.getDisplayMetrics().scaledDensity;
		return sp * scale;
	}

	public static Bitmap getRoundCornerBitmap(Bitmap bitmap) {
		Bitmap outBitmap = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Config.ARGB_8888);
		Canvas canvas = new Canvas(outBitmap);
		final int color = 0xff424242;
		final Paint paint = new Paint();
		final Rect rect = new Rect(0, 0, bitmap.getWidth(), bitmap.getHeight());
		final RectF rectF = new RectF(rect);
		final float roundPX = bitmap.getWidth() / 2;
		paint.setAntiAlias(true);
		canvas.drawARGB(0, 0, 0, 0);
		paint.setColor(color);
		canvas.drawRoundRect(rectF, roundPX, roundPX, paint);
		paint.setXfermode(new PorterDuffXfermode(Mode.SRC_IN));
		canvas.drawBitmap(bitmap, rect, rect, paint);
		return outBitmap;
	}

	public static void blur(int[] in, int[] out, int width, int height, float radius) {
		int widthMinus1 = width - 1;
		int r = (int) radius;
		int tableSize = 2 * r + 1;
		int divide[] = new int[256 * tableSize];

		for (int i = 0; i < 256 * tableSize; i++)
			divide[i] = i / tableSize;

		int inIndex = 0;

		for (int y = 0; y < height; y++) {
			int outIndex = y;
			int ta = 0, tr = 0, tg = 0, tb = 0;

			for (int i = -r; i <= r; i++) {
				int rgb = in[inIndex + clamp(i, 0, width - 1)];
				ta += (rgb >> 24) & 0xff;
				tr += (rgb >> 16) & 0xff;
				tg += (rgb >> 8) & 0xff;
				tb += rgb & 0xff;
			}

			for (int x = 0; x < width; x++) {
				out[outIndex] = (divide[ta] << 24) | (divide[tr] << 16) | (divide[tg] << 8) | divide[tb];

				int i1 = x + r + 1;
				if (i1 > widthMinus1)
					i1 = widthMinus1;
				int i2 = x - r;
				if (i2 < 0)
					i2 = 0;
				int rgb1 = in[inIndex + i1];
				int rgb2 = in[inIndex + i2];

				ta += ((rgb1 >> 24) & 0xff) - ((rgb2 >> 24) & 0xff);
				tr += ((rgb1 & 0xff0000) - (rgb2 & 0xff0000)) >> 16;
				tg += ((rgb1 & 0xff00) - (rgb2 & 0xff00)) >> 8;
				tb += (rgb1 & 0xff) - (rgb2 & 0xff);
				outIndex += height;
			}
			inIndex += width;
		}
	}

	public static void blurFractional(int[] in, int[] out, int width, int height, float radius) {
		radius -= (int) radius;
		float f = 1.0f / (1 + 2 * radius);
		int inIndex = 0;

		for (int y = 0; y < height; y++) {
			int outIndex = y;

			out[outIndex] = in[0];
			outIndex += height;
			for (int x = 1; x < width - 1; x++) {
				int i = inIndex + x;
				int rgb1 = in[i - 1];
				int rgb2 = in[i];
				int rgb3 = in[i + 1];

				int a1 = (rgb1 >> 24) & 0xff;
				int r1 = (rgb1 >> 16) & 0xff;
				int g1 = (rgb1 >> 8) & 0xff;
				int b1 = rgb1 & 0xff;
				int a2 = (rgb2 >> 24) & 0xff;
				int r2 = (rgb2 >> 16) & 0xff;
				int g2 = (rgb2 >> 8) & 0xff;
				int b2 = rgb2 & 0xff;
				int a3 = (rgb3 >> 24) & 0xff;
				int r3 = (rgb3 >> 16) & 0xff;
				int g3 = (rgb3 >> 8) & 0xff;
				int b3 = rgb3 & 0xff;
				a1 = a2 + (int) ((a1 + a3) * radius);
				r1 = r2 + (int) ((r1 + r3) * radius);
				g1 = g2 + (int) ((g1 + g3) * radius);
				b1 = b2 + (int) ((b1 + b3) * radius);
				a1 *= f;
				r1 *= f;
				g1 *= f;
				b1 *= f;
				out[outIndex] = (a1 << 24) | (r1 << 16) | (g1 << 8) | b1;
				outIndex += height;
			}
			out[outIndex] = in[width - 1];
			inIndex += width;
		}
	}

	public static int clamp(int x, int a, int b) {
		return (x < a) ? a : (x > b) ? b : x;
	}

	/**
	 *
	 * 高斯模糊
	 */
	/** 水平方向模糊度 */
	private static float hRadius = 10;
	/** 竖直方向模糊度 */
	private static float vRadius = 10;
	/** 模糊迭代度 */
	private static int iterations = 7;

	public static Drawable BoxBlurFilter(Bitmap bmp) {
		int width = bmp.getWidth();
		int height = bmp.getHeight();
		int[] inPixels = new int[width * height];
		int[] outPixels = new int[width * height];
		Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
		bmp.getPixels(inPixels, 0, width, 0, 0, width, height);
		for (int i = 0; i < iterations; i++) {
			blur(inPixels, outPixels, width, height, hRadius);
			blur(outPixels, inPixels, height, width, vRadius);
		}
		blurFractional(inPixels, outPixels, width, height, hRadius);
		blurFractional(outPixels, inPixels, height, width, vRadius);
		bitmap.setPixels(inPixels, 0, width, 0, 0, width, height);
		// bitmap = Bitmap.createBitmap(bitmap, 0, 10, width, height-10);
		bitmap = Bitmap.createBitmap(bitmap, 10, 10, width - 20, height - 20, null, false);
		Drawable drawable = new BitmapDrawable(bitmap);
		return drawable;
	}

	/**
	 * 检查当前网络是否可用
	 * 
	 * @param context
	 * @return
	 */
	public static boolean isNetworkAvailable(Activity activity) {
		Context context = activity.getApplicationContext();
		// 获取手机所有连接管理对象（包括对wi-fi,net等连接的管理）
		ConnectivityManager connectivityManager = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);

		if (connectivityManager == null) {
			return false;
		} else {
			// 获取NetworkInfo对象
			NetworkInfo[] networkInfo = connectivityManager.getAllNetworkInfo();

			if (networkInfo != null && networkInfo.length > 0) {
				for (int i = 0; i < networkInfo.length; i++) {
					// 判断当前网络状态是否为连接状态
					if (networkInfo[i].getState() == NetworkInfo.State.CONNECTED) {
						return true;
					}
				}
			}
		}
		return false;
	}

	/** 没有网络 */
	public static final int NETWORKTYPE_INVALID = 0;
	/** wap网络 */
	public static final int NETWORKTYPE_WAP = 1;
	/** 2G网络 */
	public static final int NETWORKTYPE_2G = 2;
	/** 3G和3G以上网络，或统称为快速网络 */
	public static final int NETWORKTYPE_3G = 3;
	/** wifi网络 */
	public static final int NETWORKTYPE_WIFI = 4;

	public static boolean isFastMobileNetwork(Context context) {
		TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
		switch (telephonyManager.getNetworkType()) {
		case TelephonyManager.NETWORK_TYPE_1xRTT:
			return false; // ~ 50-100 kbps
		case TelephonyManager.NETWORK_TYPE_CDMA:
			return false; // ~ 14-64 kbps
		case TelephonyManager.NETWORK_TYPE_EDGE:
			return false; // ~ 50-100 kbps
		case TelephonyManager.NETWORK_TYPE_EVDO_0:
			return true; // ~ 400-1000 kbps
		case TelephonyManager.NETWORK_TYPE_EVDO_A:
			return true; // ~ 600-1400 kbps
		case TelephonyManager.NETWORK_TYPE_GPRS:
			return false; // ~ 100 kbps
		case TelephonyManager.NETWORK_TYPE_HSDPA:
			return true; // ~ 2-14 Mbps
		case TelephonyManager.NETWORK_TYPE_HSPA:
			return true; // ~ 700-1700 kbps
		case TelephonyManager.NETWORK_TYPE_HSUPA:
			return true; // ~ 1-23 Mbps
		case TelephonyManager.NETWORK_TYPE_UMTS:
			return true; // ~ 400-7000 kbps
		case TelephonyManager.NETWORK_TYPE_EHRPD:
			return true; // ~ 1-2 Mbps
		case TelephonyManager.NETWORK_TYPE_EVDO_B:
			return true; // ~ 5 Mbps
		case TelephonyManager.NETWORK_TYPE_HSPAP:
			return true; // ~ 10-20 Mbps
		case TelephonyManager.NETWORK_TYPE_IDEN:
			return false; // ~25 kbps
		case TelephonyManager.NETWORK_TYPE_LTE:
			return true; // ~ 10+ Mbps
		case TelephonyManager.NETWORK_TYPE_UNKNOWN:
			return false;
		default:
			return false;
		}

	}

	/**
	 * 获取网络状态，wifi,wap,2g,3g.
	 *
	 * @param context
	 *            上下文
	 * @return int 网络状态 {@link #NETWORKTYPE_2G},{@link #NETWORKTYPE_3G}, *
	 *         {@link #NETWORKTYPE_INVALID},{@link #NETWORKTYPE_WAP}*
	 *         <p>
	 *         {@link #NETWORKTYPE_WIFI}
	 */
	public static int getNetWorkType(Context context) {
		ConnectivityManager manager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkInfo = manager.getActiveNetworkInfo();
		int mNetWorkType = NETWORKTYPE_INVALID;
		if (networkInfo != null && networkInfo.isConnected()) {
			String type = networkInfo.getTypeName();
			if (type.equalsIgnoreCase("WIFI")) {
				mNetWorkType = NETWORKTYPE_WIFI;
			} else if (type.equalsIgnoreCase("MOBILE")) {
				String proxyHost = android.net.Proxy.getDefaultHost();
				mNetWorkType = TextUtils.isEmpty(proxyHost)
						? (isFastMobileNetwork(context) ? NETWORKTYPE_3G : NETWORKTYPE_2G) : NETWORKTYPE_WAP;
			}
		} else {
			mNetWorkType = NETWORKTYPE_INVALID;
		}

		switch (mNetWorkType) {
		case NETWORKTYPE_INVALID:
			Log.i("testTag", "网络状态 ： 无可用网络");
			break;
		case NETWORKTYPE_WAP:
			Log.i("testTag", "网络状态 ： Wap 网络");
			break;
		case NETWORKTYPE_2G:
			Log.i("testTag", "网络状态 ： 2G 网络");
			break;
		case NETWORKTYPE_3G:
			Log.i("testTag", "网络状态 ： 3G 网络");
			break;
		case NETWORKTYPE_WIFI:
			Log.i("testTag", "网络状态 ： WIFI 网络");
			break;

		default:
			break;
		}


		return mNetWorkType;
	}


    
    public static boolean isWifi(Context mContext) {  
        ConnectivityManager connectivityManager = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);  
        NetworkInfo activeNetInfo = connectivityManager.getActiveNetworkInfo();  
        if (activeNetInfo != null  && activeNetInfo.getType() == ConnectivityManager.TYPE_WIFI) {  
            return true;  
        }  
        return false;  
    } 
    
    public static String uploadImage(String url , String filename){
		
		try {
			HttpClient httpClient = new DefaultHttpClient();
		    HttpPost httpPost = new HttpPost(url);
		    File uploadFile = new File(filename);
		    //定义FileEntity对象
		    HttpEntity entity = new FileEntity(uploadFile, filename);
		    //为httpPost设置头信息
		    httpPost.setHeader("images", URLEncoder.encode(filename,"utf-8"));//服务器可以读取到该文件名
		    httpPost.setHeader("Content-Length", String.valueOf(entity.getContentLength()));//设置传输长度
		    httpPost.setEntity(entity); //设置实体对象
		    // httpClient执行httpPost表单提交
		    HttpResponse response = httpClient.execute(httpPost);
		    // 得到服务器响应实体对象
		    String mHistoryList = EntityUtils.toString(response.getEntity());
			JSONObject jsonObj= new JSONObject(mHistoryList);
			
			int resultCode = -1;
			if(jsonObj.has("code")){
				resultCode = jsonObj.getInt("code");
			}			
			if (resultCode == 0
					&& jsonObj.has("data")) {
				
				JSONObject job = jsonObj.getJSONObject("data");
				JSONArray suc = job.getJSONArray("Succ");
				if(suc.length() > 0){
					String filemd5 = suc.getString(0);
					return filemd5;
				}
				
			}
		    
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    
	    return null;
	}
    
    private static final String TAG = "uploadFile";
    private static final int TIME_OUT = 10*1000;   //超时时间
    private static final String CHARSET = "utf-8"; //设置编码
    /**
     * android上传文件到服务器
     * @param file  需要上传的文件
     * @param RequestURL  请求的rul
     * @return  返回响应的内容
     */
    public static String uploadFile(String path,String RequestURL)
    {
    	File file = new File(path);
        String result = null;
        String  BOUNDARY =  UUID.randomUUID().toString();  //边界标识   随机生成
        String PREFIX = "--" , LINE_END = "\r\n"; 
        String CONTENT_TYPE = "multipart/form-data";   //内容类型
        
        try {
            URL url = new URL(RequestURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setReadTimeout(TIME_OUT);
            conn.setConnectTimeout(TIME_OUT);
            conn.setDoInput(true);  //允许输入流
            conn.setDoOutput(true); //允许输出流
            conn.setUseCaches(false);  //不允许使用缓存
            conn.setRequestMethod("POST");  //请求方式
            conn.setRequestProperty("Charset", CHARSET);  //设置编码
            conn.setRequestProperty("connection", "keep-alive");   
            conn.setRequestProperty("Content-Type", CONTENT_TYPE + ";boundary=" + BOUNDARY); 
            
            if(file!=null)
            {
                /**
                 * 当文件不为空，把文件包装并且上传
                 */
                DataOutputStream dos = new DataOutputStream( conn.getOutputStream());
                StringBuffer sb = new StringBuffer();
                sb.append(PREFIX);
                sb.append(BOUNDARY);
                sb.append(LINE_END);
                /**
                 * 这里重点注意：
                 * name里面的值为服务器端需要key   只有这个key 才可以得到对应的文件
                 * filename是文件的名字，包含后缀名的   比如:abc.png  
                 */
                
                sb.append("Content-Disposition: form-data; name=\"images\"; filename=\""+file.getName()+"\""+LINE_END); 
                sb.append("Content-Type: application/octet-stream; charset="+CHARSET+LINE_END);
                sb.append(LINE_END);
                dos.write(sb.toString().getBytes());
                InputStream is = new FileInputStream(file);
                byte[] bytes = new byte[1024];
                int len = 0;
                while((len=is.read(bytes))!=-1)
                {
                    dos.write(bytes, 0, len);
                }
                is.close();
                dos.write(LINE_END.getBytes());
                byte[] end_data = (PREFIX+BOUNDARY+PREFIX+LINE_END).getBytes();
                dos.write(end_data);
                dos.flush();
                /**
                 * 获取响应码  200=成功
                 * 当响应成功，获取响应的流  
                 */
                int res = conn.getResponseCode();  
                Log.e(TAG, "response code:"+res);
//                if(res==200)
//                {
                    Log.e(TAG, "request success");
                    InputStream input =  conn.getInputStream();
                    StringBuffer sb1= new StringBuffer();
                    int ss ;
                    while((ss=input.read())!=-1)
                    {
                        sb1.append((char)ss);
                    }
                    result = sb1.toString();
                    Log.e(TAG, "result : "+ result);
//                }
//                else{
//                    Log.e(TAG, "request error");
//                }
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }
    
}
