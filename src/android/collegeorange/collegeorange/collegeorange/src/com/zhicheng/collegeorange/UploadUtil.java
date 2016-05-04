package com.zhicheng.collegeorange;

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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;

import com.zhicheng.collegeorange.main.SharedHelper;



/**
 * 
 * 上传工具类
 * 
 */
public class UploadUtil {
	private static final int TIME_OUT = 90000; // 超时时间
	private static final String CHARSET = "UTF-8"; // 设置编码

	/**
	 * android上传文件到服务器
	 * 
	 * @param file
	 *            需要上传的文件
	 * @param RequestURL
	 *            请求的rul
	 * @param nChatInfo
	 * @return 返回响应的内容
	 */
	public static String uploadFile(Context context,String path, String RequestURL, String newFileName, int index, boolean isImage) {
		File file = new File(path);
		if (file == null || !file.exists())
			return "";
		String type = "";
		String end = path.substring(path.lastIndexOf("."), path.length()).toLowerCase();
		for (int i = 0; i < MIME_MapTable.length; i++) {
			if (end.equals(MIME_MapTable[i][0]))
				type = MIME_MapTable[i][1];
		}
		String result = null;
		String BOUNDARY = UUID.randomUUID().toString(); // 边界标识 随机生成
		String PREFIX = "--", LINE_END = "\r\n";
		String CONTENT_TYPE = type; // 内容类型
		FileUploadTaskIndex = index;
		try {
			URL url = new URL(RequestURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setReadTimeout(TIME_OUT);
			conn.setConnectTimeout(TIME_OUT);
			conn.setDoInput(true); // 允许输入流
			conn.setDoOutput(true); // 允许输出流
			conn.setUseCaches(false); // 不允许使用缓存
			conn.setRequestMethod("POST"); // 请求方式
			conn.setRequestProperty("Charset", CHARSET); // 设置编码
			conn.setRequestProperty("connection", "keep-alive");
			conn.setRequestProperty("Content-Type", "multipart/form-data" + ";boundary=" + BOUNDARY);
			conn.setRequestProperty("User-Name", SharedHelper.getShareHelper(context).getString(SharedHelper.USER_NAME, ""));
			
			/**
			 * 当文件不为空，把文件包装并且上传
			 */

			DataOutputStream dos = new DataOutputStream(conn.getOutputStream());
			StringBuffer sb = new StringBuffer();
			sb.append(PREFIX);
			sb.append(BOUNDARY);
			sb.append(LINE_END);
			/**
			 * 这里重点注意： name里面的值为服务器端需要key 只有这个key 才可以得到对应的文件
			 * filename是文件的名字，包含后缀名的 比如:abc.png
			 */
			sb.append("Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"" + newFileName + "\"" + LINE_END);
//			multipart/form-data
			sb.append("Content-Type: " + CONTENT_TYPE + ";charset=" + CHARSET + LINE_END);
			sb.append(LINE_END);
			dos.write(sb.toString().getBytes());
			InputStream is = new FileInputStream(file);
			byte[] bytes = new byte[1024];
			long dwnldedLen = 0;
			int len = 0;
			int lastProgress = 0;
			long contentLength = file.length();
			while ((len = is.read(bytes)) != -1) {
				dwnldedLen += len;
				dos.write(bytes, 0, len);
				if (contentLength > 0 && isImage) {
					int progress = (int) (dwnldedLen * 100 / contentLength);
					/*if (AudioService.progressHashMap.get(nChatInfo.timeLong) == null) {
						return "cancel";
					}
					if ((progress - lastProgress) > 1) {
						lastProgress = progress;
						AudioService.progressHashMap.put(nChatInfo.timeLong, progress);
						LocalBroadcastManager.getInstance(LauncherApp.getInstance()).sendBroadcast(new Intent("upload_image"));
					}*/
				}
			}
			is.close();
			dos.write(LINE_END.getBytes());
			byte[] end_data = (PREFIX + BOUNDARY + PREFIX + LINE_END).getBytes();
			dos.write(end_data);
			dos.flush();
			/**
			 * 获取响应码 200=成功 当响应成功，获取响应的流
			 */

			int res = conn.getResponseCode();
			if (res == 200) {
				result = "ok";
			} else {
				
			}
		} catch (MalformedURLException e) {
			result = "MalformedURLException";
			e.printStackTrace();
		} catch (IOException e) {
			result = "io";
			e.printStackTrace();
		}
		if (TextUtils.isEmpty(result) || !result.equals("ok")) {
			if (FileUploadTaskIndex < 3) {
				FileUploadTaskIndex++;
				result = uploadFile(context,path, RequestURL, newFileName, FileUploadTaskIndex,  isImage);
			}
		}
		return result;
	}

	

	
	static int FileUploadTaskIndex;

	// 建立一个MIME类型与文件后缀名的匹配表
	public static String[][] MIME_MapTable = {
			// {后缀名， MIME类型}
			{ ".3gp", "video/3gpp" }, { ".apk", "application/vnd.android.package-archive" }, { ".asf", "video/x-ms-asf" }, { ".avi", "video/x-msvideo" },
			{ ".bin", "application/octet-stream" }, { ".bmp", "image/bmp" }, { ".c", "text/plain" }, { ".class", "application/octet-stream" },
			{ ".conf", "text/plain" }, { ".cpp", "text/plain" }, { ".doc", "application/msword" }, { ".exe", "application/octet-stream" },
			{ ".gif", "image/gif" }, { ".gtar", "application/x-gtar" }, { ".gz", "application/x-gzip" }, { ".h", "text/plain" }, { ".htm", "text/html" },
			{ ".html", "text/html" }, { ".jar", "application/java-archive" }, { ".java", "text/plain" }, { ".jpeg", "image/jpeg" }, { ".jpg", "image/jpeg" },
			{ ".js", "application/x-javascript" }, { ".log", "text/plain" }, { ".m3u", "audio/x-mpegurl" }, { ".m4a", "audio/mp4a-latm" },
			{ ".m4b", "audio/mp4a-latm" }, { ".m4p", "audio/mp4a-latm" }, { ".m4u", "video/vnd.mpegurl" }, { ".m4v", "video/x-m4v" },
			{ ".mov", "video/quicktime" }, { ".mp2", "audio/x-mpeg" }, { ".mp3", "audio/x-mpeg" }, { ".mp4", "video/mp4" },
			{ ".mpc", "application/vnd.mpohun.certificate" }, { ".mpe", "video/mpeg" }, { ".mpeg", "video/mpeg" }, { ".mpg", "video/mpeg" },
			{ ".mpg4", "video/mp4" }, { ".mpga", "audio/mpeg" }, { ".msg", "application/vnd.ms-outlook" }, { ".ogg", "audio/ogg" },
			{ ".pdf", "application/pdf" }, { ".png", "image/png" }, { ".pps", "application/vnd.ms-powerpoint" }, { ".ppt", "application/vnd.ms-powerpoint" },
			{ ".prop", "text/plain" }, { ".rar", "application/x-rar-compressed" }, { ".rc", "text/plain" }, { ".rmvb", "audio/x-pn-realaudio" },
			{ ".rtf", "application/rtf" }, { ".sh", "text/plain" }, { ".tar", "application/x-tar" }, { ".tgz", "application/x-compressed" },
			{ ".txt", "text/plain" }, { ".wav", "audio/x-wav" }, { ".wma", "audio/x-ms-wma" }, { ".wmv", "audio/x-ms-wmv" },
			{ ".wps", "application/vnd.ms-works" },
			// {".xml", "text/xml"},
			{ ".xml", "text/plain" }, { ".z", "application/x-compress" }, { ".zip", "application/zip" }, { ".amr", "application/octet-stream" }, { "", "*/*" } };
//	{ ".amr", "multipart/form-data" }
	public static String UploadPictureToService(Context context,String path, String RequestURL, String newFileName, int index) {
		File tmpFile = null;
		try {
			final BitmapFactory.Options options = new BitmapFactory.Options();
			options.inJustDecodeBounds = true;
			BitmapFactory.decodeFile(path, options);
			int rawImgW = options.outWidth;
			int rawImgH = options.outHeight;
			// String tmpFileName = Environment.getExternalStorageDirectory() +
			// "/" +newFileName;
			if ((rawImgW <= 1280) && (rawImgH <= 800)) {
				return uploadFile(context ,path, RequestURL, newFileName, index,  true);
			} else {
				// tmpFile = new File(newFileName);
				SimpleDateFormat timesdf = new SimpleDateFormat("yyyyMMddHHmmss");
				String FileTime = timesdf.format(new Date()).toString() + ".jpeg";// 获取

				tmpFile = new File(Environment.getExternalStorageDirectory(), FileTime);
				try {
					tmpFile.createNewFile();
				} catch (Exception e) {
					e.printStackTrace();
					return "io";
				}
				FileOutputStream output = null;
				try {
					output = new FileOutputStream(tmpFile);
				} catch (Exception e) {
					e.printStackTrace();
					return "io";
				}

				Bitmap bm = Utils.decodCompressionBitmapFromFile(path, 1280, 800);
				if (bm == null) {
					try {
						output.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
					return "io";
				}
				bm.compress(Bitmap.CompressFormat.JPEG, 100, output);
				try {
					output.flush();
				} catch (Exception e) {
					e.printStackTrace();
					return "io";
				}
			}

			String str = uploadFile(context , tmpFile.getPath(), RequestURL, newFileName, index,  true);
			if (tmpFile != null && tmpFile.exists()) {
				tmpFile.delete();
			}
			return str;
		} catch (Exception e) {
			e.printStackTrace();
			Log.e("bailu", "UploadPictureToService err");
		}
		return "io";
	}
	
	public static String uploadImage(String url,String filename) {
		
        String strResult = null;
        HttpClient httpClient = new DefaultHttpClient();
        HttpContext localContext = new BasicHttpContext();
        HttpPost httpPost = new HttpPost(url);
        
       
        try {
            MultipartEntity entity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);
            entity.addPart("images", new FileBody(new File (filename)));
            
            httpPost.setEntity(entity);
            HttpResponse response = httpClient.execute(httpPost, localContext);
            int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return null;
			}
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
			
        }catch (UnsupportedEncodingException e) {
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

        return  strResult;
    }
}