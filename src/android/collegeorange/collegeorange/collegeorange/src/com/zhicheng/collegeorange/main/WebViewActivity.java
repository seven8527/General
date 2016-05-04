package com.zhicheng.collegeorange.main;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.webkit.DownloadListener;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.webkit.GeolocationPermissions.Callback;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
//import cn.sharesdk.onekeyshare.OnekeyShare;
//import cn.sharesdk.wechat.utils.WXMediaMessage;
//import cn.sharesdk.wechat.utils.WXWebpageObject;

import java.io.ByteArrayOutputStream;

import com.handmark.pulltorefresh.library.internal.Utils;

import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.mm.sdk.openapi.WXAppExtendObject;
import com.tencent.mm.sdk.openapi.WXImageObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;
import com.tencent.mm.sdk.openapi.WXMusicObject;
import com.tencent.mm.sdk.openapi.WXTextObject;
import com.tencent.mm.sdk.openapi.WXVideoObject;
import com.tencent.mm.sdk.openapi.WXWebpageObject;
import com.tencent.mm.sdk.openapi.GetMessageFromWX;

import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.WebViewFragment;
import com.zhicheng.collegeorange.utils.CompleteSharePopWindow;
import com.zhicheng.collegeorange.view.ProgressWebView;



public class WebViewActivity extends Activity {

	private String mUrl;
	private TextView text, titleTextview;
	private ProgressWebView mWebView;
	private Button mShareButton;

	private String webTitleStr = "网页";
	
	private CompleteSharePopWindow mSharePopWindow;
    private Bundle bundle;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		final IWXAPI api1 = WXAPIFactory.createWXAPI(this, null);
		api1.registerApp("wxf87fe29bb34bf7b1");
		setContentView(R.layout.activity_web_browser);
		bundle = getIntent().getExtras();
		
		initTitle();
		initView();
//		initShareSDk();
	}

	private void showShare() {
		 ShareSDK.initSDK(this);
		 OnekeyShare oks = new OnekeyShare();
		 //关闭sso授权
		 oks.disableSSOWhenAuthorize(); 
		// 分享时Notification的图标和文字  2.5.9以后的版本不调用此方法
		 //oks.setNotification(R.drawable.ic_launcher, getString(R.string.app_name));
		 // title标题，印象笔记、邮箱、信息、微信、人人网和QQ空间使用
		 oks.setTitle("来自大学圈的分享");
		 // titleUrl是标题的网络链接，仅在人人网和QQ空间使用
//		 oks.setTitleUrl("http://sharesdk.cn");
		 // text是分享文本，所有平台都需要这个字段
		 oks.setText("来自大学圈的分享");
		 // imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
		 //oks.setImagePath("/sdcard/test.jpg");//确保SDcard下面存在此张图片
		 // url仅在微信（包括好友和朋友圈）中使用
		 oks.setUrl(mUrl);
		 // comment是我对这条分享的评论，仅在人人网和QQ空间使用
//		 oks.setComment("我是测试评论文本");
		 // site是分享此内容的网站名称，仅在QQ空间使用
//		 oks.setSite(getString(R.string.app_name));
		 // siteUrl是分享此内容的网站地址，仅在QQ空间使用
//		 oks.setSiteUrl("http://sharesdk.cn");

		// 启动分享GUI
		 oks.show(this);
		 }
	private IWXAPI api;
	private void shareUrl2WX() {
		try {
			api = WXAPIFactory.createWXAPI(this, "wxf87fe29bb34bf7b1", true);
			WXWebpageObject webpage = new WXWebpageObject();
			webpage.webpageUrl = mUrl;
			WXMediaMessage msg = new WXMediaMessage(webpage);

			msg.title = webTitleStr;// (type == 1) ? "表达" :
									// "还用微信语音吗？速速下载表达，通过手表也可以语音对讲啦！";
			// msg.description = getString(R.string.invite_speechs);
			msg.description = "来自于“表达”的推荐";

//			Resources res = getResources();
//			Bitmap thumb = BitmapFactory.decodeResource(res, R.drawable.ic_launcher);
//			msg.thumbData = Utils.bmpToByteArray(thumb, true);
//			SendMessageToWX.Req req = new SendMessageToWX.Req();
//			req.transaction = buildTransaction("webpage");
//			req.message = msg;
//			req.scene = (type == 1) ? SendMessageToWX.Req.WXSceneTimeline : SendMessageToWX.Req.WXSceneSession;
//			api.sendReq(req);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private String getTransaction() {
		final GetMessageFromWX.Req req = new GetMessageFromWX.Req(bundle);
		return req.transaction;
	}
	private String buildTransaction(final String type) {
		return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
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
	private void initTitle() {
		findViewById(R.id.title_back).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				goBack();
			}
		});
		findViewById(R.id.sharebtn).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				//Toast.makeText(getApplicationContext(), "选择分享位置", 1).show();
				//AlertDialog alertDialog = new AlertDialog.Builder(WebViewActivity.this).create();
				//alertDialog.show();
				//Window window = alertDialog.getWindow();
				//window.setContentView(R.layout.share_to_item);
				//Button mPenyouBtn = (Button) window.findViewById(R.id.sharePengyou );
				//Button mPenyouQuanBtn = (Button) window.findViewById(R.id.sharePengyouquan);
				
//				mSharePopWindow = new CompleteSharePopWindow(getApplicationContext());
//				mSharePopWindow.setAnimationStyle(R.style.AnimBottom);
//				mSharePopWindow.showAtLocation(v,
//						Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); // 设置layout在PopupWindow中显示的位置
				
				showShare();
//				shareUrl2WX();
			}
		});
		

	}

	@Override
	protected void onStop() {
		super.onStop();
		mHandler.removeMessages(0);
	}

	private void initView() {
		mUrl = getIntent().getStringExtra(WebViewFragment.ARG_TARGET_URL);
		
		
		titleTextview = (TextView) findViewById(R.id.title_middle1);
		text = (TextView) findViewById(R.id.text);
		mWebView = (ProgressWebView) findViewById(R.id.webview);
		try {
			if (mUrl != null) {
				if (mUrl.startsWith("http://") || mUrl.startsWith("https://")) {
					text.setVisibility(View.GONE);
					
					WebSettings settings = mWebView.getSettings();
					settings.setJavaScriptEnabled(true);
					settings.setGeolocationEnabled(true);
					settings.setGeolocationDatabasePath(getFilesDir().getPath());

					WebChromeClient wvcc = new WebChromeClient() {
						@Override
						public void onReceivedTitle(WebView view, String title) {
							super.onReceivedTitle(view, title);
							mUrl = view.getUrl();
							if (!TextUtils.isEmpty(title)) {
								webTitleStr = title;
							}
							//titleTextview.setText(webTitleStr);
						}

						@Override
						public void onProgressChanged(WebView view, int newProgress) {
							if (newProgress == 100) {
								mWebView.getProgressBar().setVisibility(View.GONE);
							} else {
								if (mWebView.getProgressBar().getVisibility() == View.GONE)
									mWebView.getProgressBar().setVisibility(View.VISIBLE);
								mWebView.getProgressBar().setProgress(newProgress);
							}
							super.onProgressChanged(view, newProgress);
						}
						
						@Override
						  public void onGeolocationPermissionsHidePrompt() {
						      super.onGeolocationPermissionsHidePrompt();
						      //Log.i(LOGTAG, "onGeolocationPermissionsHidePrompt");
						  }
						
						@Override
						public void onGeolocationPermissionsShowPrompt(
								final String origin,final Callback callback) {
							 AlertDialog.Builder builder = new AlertDialog.Builder(WebViewActivity.this);
						      builder.setMessage("需要使用您的位置信息?");
						      DialogInterface.OnClickListener dialogButtonOnClickListener = new DialogInterface.OnClickListener() {

						          @Override
						          public void onClick(DialogInterface dialog, int clickedButton) {
						              if (DialogInterface.BUTTON_POSITIVE == clickedButton) {
						                  callback.invoke(origin, true, true);
						              } else if (DialogInterface.BUTTON_NEGATIVE == clickedButton) {
						                  callback.invoke(origin, false, false);
						              }
						          }
						      };						      
						      builder.setPositiveButton("允许", dialogButtonOnClickListener);
						      builder.setNegativeButton("拒绝", dialogButtonOnClickListener);
						      builder.show();
							super.onGeolocationPermissionsShowPrompt(origin, callback);
						}
					
					};
					mWebView.setWebChromeClient(wvcc);
					mWebView.loadUrl(mUrl);
					mWebView.setWebViewClient(new HelloWebViewClient());
					mWebView.setDownloadListener(new MyWebViewDownLoadListener());
				} else {
					mWebView.setVisibility(View.GONE);
					//titleTextview.setText("扫描结果");
					// titleTextview.setVisibility(View.VISIBLE);
					text.setText(mUrl);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	private class HelloWebViewClient extends WebViewClient {

		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			view.loadUrl(url);
			return true;
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			return goBack();
		}
		return false;
	}

	private Handler mHandler = new Handler() {

		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case 0:
				try {
					mUrl = mWebView.getUrl();
					String title = mWebView.getTitle();
					if (!TextUtils.isEmpty(title)) {
						webTitleStr = title;
					}
					//titleTextview.setText(webTitleStr);
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			default:
				break;
			}
		}
	};

	private boolean goBack() {
		try {

			if (null != mUrl && !"".equals(mUrl)) {
				if (mWebView.canGoBack()) {
					if (mUrl.contains("weixin.qq.com")) {
						finish();
					} else {
						mWebView.goBack(); // goBack()表示返回WebView的上一页面
						mHandler.sendEmptyMessageDelayed(0, 1000);
					}
				} else {
					finish();
				}
			} else {
				finish();
			}

		} catch (Exception e) {
			e.printStackTrace();
			finish();
		}
		return true;
	}

	private class MyWebViewDownLoadListener implements DownloadListener {

		@Override
		public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimetype,
				long contentLength) {
			Uri uri = Uri.parse(url);
			Intent intent = new Intent(Intent.ACTION_VIEW, uri);
			startActivity(intent);
			finish();
		}

	}

}

