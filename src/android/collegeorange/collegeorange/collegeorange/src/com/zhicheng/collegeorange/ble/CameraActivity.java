package com.zhicheng.collegeorange.ble;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.utils.ImagePagerActivity;
import com.zy.find.FindUtils;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.graphics.PixelFormat;
import android.hardware.Camera;
import android.hardware.Camera.AutoFocusCallback;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.ShutterCallback;
import android.hardware.Camera.Size;
import android.media.AudioManager;
import android.media.ExifInterface;
import android.media.MediaPlayer;
import android.media.ThumbnailUtils;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.Settings;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;
import android.view.Display;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceHolder.Callback;
import android.view.SurfaceView;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;


public class CameraActivity extends Activity {
	private View layout;
	private Camera camera;
	private ImageView showView;
	private Camera.Parameters parameters = null;
	boolean clickQuicky = false;
	private ScaleGestureDetector mScaleGestureDetector = null;
	int cameraID = 0;
	int flash = 0;// 0自动，1开，2关
	private Button flashBtn;
	private ImageView focusView;
	public static final String STOP_CAMERA_ACTION = "com.tomoon.camera.stop";

	// Bundle bundle = null; // 声明一个Bundle对象，用来存储数据
	// byte[] datas = null;
	File jpgFile = null;
	SurfaceView surfaceView;
    private SharedHelper mSharedHelper = null;
	boolean isTakingPic = false;
	boolean isTakingClick = false;
	
	private boolean isCloseRotation = false;

	//int point = 0;// 0是普通拍照，1是微观点拍照
	private FocusCallback mAutoFocusCallback = new FocusCallback(); 

	private BroadcastReceiver friendReceiver = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			Log.i("msg", "action===" + action);
			
			if (FindUtils.ACTION_MANKO_DATA_CHANGE.equals(action)) {
				String address = intent.getStringExtra("address");
				String uuid = intent.getStringExtra("uuid");
				Log.i("msg", "value==" + address);
				try {
					int scale = 1;
					if (camera != null) {
						if (scale == 1) {
							if (isTakingClick) {
								return;
							}
							isTakingClick = true;
							takePicClickHandler.sendEmptyMessageDelayed(0, 1000);
							try {
								camera.autoFocus(new AutoFocusCallback() {
									@Override
									public void onAutoFocus(boolean success, Camera camera) {
										try {
											// success为true表示对焦成功
											if(cameraID==0){
												if (success&&!isTakingPic) {
													isTakingPic = true;
													if (camera != null) {
														// 拍照
														takePic();
													}else {
														clickHandler.sendEmptyMessageDelayed(0, 1000);
													}
												 }
											}else {
												if (camera != null) {
													// 拍照
													if(!isTakingPic){
														isTakingPic = true;
														takePic();
													}
												}
											}
										} catch (Exception e) {
											e.printStackTrace();
										}
									}
								});
							} catch (Exception e) {
								e.printStackTrace();
							}
						} else {
							setZoom(scale);
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (STOP_CAMERA_ACTION.equals(action)) {
				finish();
			}
		}

	};

	@Override
	public void onCreate(Bundle savedInstanceState) {
		getWindow().setFlags(
				WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
						| WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
						| WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
						| WindowManager.LayoutParams.FLAG_FULLSCREEN,
				WindowManager.LayoutParams.FLAG_FULLSCREEN
						| WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
						| WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
						| WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
		
		try {
			int flag =Settings.System.getInt(getContentResolver(),Settings.System.ACCELEROMETER_ROTATION, 0);
			if (0 == flag){
				Settings.System.putInt(getContentResolver(),Settings.System.ACCELEROMETER_ROTATION, 1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		super.onCreate(savedInstanceState);
		// 显示界面
		setContentView(R.layout.activity_camera);
		layout = this.findViewById(R.id.buttonLayout);
		flashBtn = (Button) findViewById(R.id.camera_flash);
		focusView = (ImageView) findViewById(R.id.camera_focus);
		showView = (ImageView) findViewById(R.id.scalePic);

		surfaceView = (SurfaceView) findViewById(R.id.surfaceView);
		surfaceView.getHolder()
				.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
		surfaceView.getHolder().setKeepScreenOn(true);// 屏幕常亮
		surfaceView.getHolder().addCallback(new SurfaceCallback());// 为SurfaceView的句柄添加一个回调函数

		mScaleGestureDetector = new ScaleGestureDetector(this,
				new ScaleGestureListener());

		IntentFilter filter = new IntentFilter();
		//filter.addAction(Commands.CMD_CONTROL_CAMERA.name());
		filter.addAction(FindUtils.ACTION_MANKO_DATA_CHANGE);
		filter.addAction(STOP_CAMERA_ACTION);
		
		LocalBroadcastManager.getInstance(this).registerReceiver(
				friendReceiver, filter);
		
//		mHandler.sendEmptyMessage(GET_PICTURE_PATH);
		mSharedHelper = SharedHelper.getShareHelper(this);
		if (Camera.getNumberOfCameras() < 2){
			findViewById(R.id.camera_change).setVisibility(View.GONE);
		}else{
			cameraID = mSharedHelper.getInt(SharedHelper.SETTING_CAMERA_ID, 0);
		}
	}
	
	
	
	private final static int DISPLAYE_PICTURE = 1001;
	private final static int GET_PICTURE_PATH = 1002;
	Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			try {
				switch (msg.what) {
				case DISPLAYE_PICTURE:
					try {
						Bitmap bmp = getImageThumbnail(jpgFile.getAbsolutePath(),120,120);
						showView.setImageBitmap(Utils.getCornerBitmap(bmp));
					} catch (Exception e) {
						e.printStackTrace();
					}
					break;
				case GET_PICTURE_PATH:
					getPicPath();
					break;
				default:
					break;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		};
	};
	
	private void getPicPath(){
		new Thread(){
			@Override
			public void run() {
				super.run();
				try {
					ArrayList<String> list = getFileList();
					if(list != null && list.size() > 0){
						String str = list.get(0).replace("file://", "");
						jpgFile = new File(list.get(0));
						mHandler.sendEmptyMessage(DISPLAYE_PICTURE);
					}else{
						jpgFile = null; 
						showView.setImageResource(R.drawable.camera_shot);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
		}.start();
	}

	/**
	 * 按钮被点击触发的事件
	 * 
	 * @param v
	 */
	public void btnOnclick(View v) {
		if (camera != null) {
			switch (v.getId()) {
			case R.id.takepicture:
				// 拍照
				if (isTakingClick) {
					return;
				}
				isTakingClick = true;
				takePicClickHandler.sendEmptyMessageDelayed(0, 1000);
				camera.autoFocus(new AutoFocusCallback() {

					@Override
					public void onAutoFocus(boolean success, Camera camera) {
						// TODO Auto-generated method stub
						// success为true表示对焦成功
						if(cameraID==0){
							if (success&&!isTakingPic) {
								isTakingPic = true;
								if (camera != null) {
									// 拍照
									takePic();
								}else {
									clickHandler.sendEmptyMessageDelayed(0, 1000);
								}
							 }
						}else {
							if (camera != null) {
								// 拍照
								if(!isTakingPic){
									isTakingPic = true;
									takePic();
								}
							}
						}
						 
					}
				});
				break;
			case R.id.camera_change:
				// 切换摄像头
				int cameraCount = Camera.getNumberOfCameras(); // get cameras
				if (cameraCount > 1) {
					camera.stopPreview();
					stopCamera();
					cameraID = cameraID == 0 ? 1 : 0;
					setCamera(cameraID);
					setParameters();
					mSharedHelper.putInt(SharedHelper.SETTING_CAMERA_ID,cameraID);
				}
				break;
			case R.id.camera_flash:
				// 闪光灯
				flash++;
				int i = flash % 3;
				if (i == 0) {
					autoCameraFlash();
					flashBtn.setBackgroundResource(R.drawable.camera_flash_auto);
				} else if (i == 1) {
					openCameraFlash();
					flashBtn.setBackgroundResource(R.drawable.camera_flash_on);
				} else if (i == 2) {
					closeCameraFlash();
					flashBtn.setBackgroundResource(R.drawable.camera_flash_off);
				}
				break;
			case R.id.surfaceView:
				camera.autoFocus(null);
				break;
			}
		}
	}

	/**
	 * 图片被点击触发的时间
	 * 
	 * @param v
	 */
	public void imageClick(View v) {
		if (v.getId() == R.id.scalePic) {
			if (jpgFile == null) {
				Toast.makeText(getApplicationContext(), "没有照片",
						Toast.LENGTH_SHORT).show();
			} else {
				/*
				 * Intent intent = new Intent(this, ShowPicActivity.class);
				 * intent.putExtras(bundle); startActivity(intent);
				 */
				if (clickQuicky) {
					return;
				}
				clickQuicky = true;
				clickHandler.sendEmptyMessageDelayed(0, 1500);
				Intent intent = new Intent(this, ImagePagerActivity.class);
				intent.putExtra("imageList", getFileList());
				intent.putExtra("sd_pic", true);
				intent.putExtra("booshare", true);
				intent.putExtra("boodelete", true);
				startActivity(intent);
				// startScan();
				// scanner.scanFileAndOpen(jpgFile.getAbsolutePath(),
				// "image/*");
//				jpgFile = null;
//				showView.setImageResource(R.drawable.camera_shot);
			}
		}
	}

	Handler clickHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			clickQuicky = false;
			isTakingPic = false;
		}
	};
	
	Handler takePicClickHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			isTakingClick = false;
		}
	};
	
	private void takePic() {
		try {
			camera.takePicture(mShutterCallback, null,
					new MyPictureCallback());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		super.onConfigurationChanged(newConfig);
		Log.i("msg", "onConfigurationChanged");
		camera.setDisplayOrientation(getPreviewDegree(CameraActivity.this));
		setParameters();
	}

	@Override
	protected void onResume() {
		super.onResume();
		Log.i("msg", "onResume");
		mHandler.sendEmptyMessage(GET_PICTURE_PATH);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Log.i("msg", "onDestroy");
		if (isCloseRotation){
			Settings.System.putInt(getContentResolver(),Settings.System.ACCELEROMETER_ROTATION, 0);
		}
		LocalBroadcastManager.getInstance(this).unregisterReceiver(
				friendReceiver);
	}

	@Override
	protected void onPause() {
		super.onPause();
		Log.i("msg", "onPause");
	}

	private final class MyPictureCallback implements PictureCallback {

		@Override
		public void onPictureTaken(byte[] data, Camera camera) {
			try {
				jpgFile = saveToSDCard(data); // 保存图片到sd卡中
				Toast.makeText(getApplicationContext(), "拍照成功",
						Toast.LENGTH_SHORT).show();
				camera.startPreview(); // 拍完照后，重新开始预览
				if (jpgFile != null) {
					mHandler.sendEmptyMessage(DISPLAYE_PICTURE);
					insertImage(jpgFile.getAbsolutePath());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally{
				isTakingPic = false;
			}
			/*if (point == 1) {
				// 记录文件
				ArrayList<String> points = (ArrayList<String>) FileUtils
						.readObjectFromFile(CameraActivity.this, "watch_point");
				if (points == null) {
					points = new ArrayList<String>();
				}
				points.add(jpgFile.getAbsolutePath());
				FileUtils.saveObjectToFile(CameraActivity.this, "watch_point",
						points);
				finish();
			}*/
		}
	}

	/**
	 * 将拍下来的照片存放在SD卡中
	 * 
	 * @param data
	 * @throws IOException
	 */
	public File saveToSDCard(byte[] data) throws IOException {
		long time = System.currentTimeMillis();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss"); // 格式化时间
		String filename = format.format(time) + ".jpg";
		File fileFolder = new File(Environment.getExternalStorageDirectory()
				+ "/Tfire/image/");
		if (!fileFolder.exists()) { // 如果目录不存在，则创建一个名为"finger"的目录
			fileFolder.mkdirs();
		}
		File file = new File(fileFolder, filename);
		FileOutputStream outputStream = new FileOutputStream(file); // 文件输出流
		outputStream.write(data); // 写入sd卡中
		outputStream.close(); // 关闭输出流
		return file;
	}

	private ArrayList<String> getFileList() {
		return GetFiles(new File(Environment.getExternalStorageDirectory()
				+ "/Tfire/image/").getAbsolutePath(), ".jpg");
	}

	public Bitmap setImageBitmap(byte[] bytes) {
		Bitmap cameraBitmap = BitmapFactory.decodeByteArray(bytes, 0,
				bytes.length);
		// 根据拍摄的方向旋转图像（纵向拍摄时要需要将图像选择90度)
		Matrix matrix = new Matrix();
		matrix.setRotate(getPreviewDegree(this));
		cameraBitmap = Bitmap
				.createBitmap(cameraBitmap, 0, 0, cameraBitmap.getWidth(),
						cameraBitmap.getHeight(), matrix, true);
		return cameraBitmap;
	}

	public void setCamera(int i) {
		try {
			if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.FROYO) {
				camera = Camera.open(); // 打开摄像头
			} else {
				camera = Camera.open(i); // 打开摄像头
			}
			camera.setPreviewDisplay(surfaceView.getHolder()); // 设置用于显示拍照影像的SurfaceHolder对象
			camera.setDisplayOrientation(getPreviewDegree(CameraActivity.this));
			camera.startPreview(); // 开始预览
		} catch (Exception e) {
			e.printStackTrace();
			Toast.makeText(CameraActivity.this, "无法打开摄像头！", Toast.LENGTH_LONG).show();
			Log.e("testTag", "open camera fail:" + e.getMessage());
		}
	}

	private void stopCamera() {
		if (camera != null) {
			camera.release(); // 释放照相机
			camera = null;
		}
	}

	public void setParameters() {
		try {
			parameters = camera.getParameters(); // 获取各项参数
			
			try {
				List<Size> supportedSizes = parameters.getSupportedPictureSizes();
				if (supportedSizes != null && supportedSizes.size() > 0){
					Size size = getBiggestSize(supportedSizes);
					parameters.setPictureSize(size.width, size.height);
				}
				
				List<Size> sizes = parameters.getSupportedPreviewSizes();
				Size optimalSize = getOptimalPreviewSize(sizes);
				parameters.setPreviewSize(optimalSize.width, optimalSize.height);
			} catch (Exception e) {
				e.printStackTrace();
			}

			parameters.setPictureFormat(PixelFormat.JPEG); // 设置图片格式
			if (cameraID == 1) {
				parameters
						.setRotation(getFrontPreviewDegree(CameraActivity.this));
			} else if (cameraID == 0) {
				parameters.setRotation(getPreviewDegree(CameraActivity.this));
			}
			autoCameraFlash();
//			autoFocus();
			camera.setParameters(parameters);
			
			
			
			MyHandler.sendEmptyMessage(OPEN_AUTOFOCS_IMAGEVIEW);
			new Thread(){
				public void run() {
					if(camera != null && mAutoFocusCallback != null){
						camera.autoFocus(mAutoFocusCallback);
					}
				}
			}.start();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private final static int CLOSE_AUTOFOCS_IMAGEVIEW = 0;
	private final static int OPEN_AUTOFOCS_IMAGEVIEW = 1;
	private final static int SET_AUTOFOCS_ON = 2;
	private final static int CLOSE_AUTOFOCS_IMAGEVIEW_TIME = 1000;
	private final static int OPEN_AUTOFOCS_IMAGEVIEW_TIME = 5000;
	private final static int SET_AUTOFOCS_ON_TIME = 4000;
	public Handler MyHandler = new Handler() {
		@SuppressWarnings("deprecation")
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case CLOSE_AUTOFOCS_IMAGEVIEW:
                if (null != focusView){
                	focusView.setVisibility(View.INVISIBLE);
                	MyHandler.sendEmptyMessageDelayed(OPEN_AUTOFOCS_IMAGEVIEW, OPEN_AUTOFOCS_IMAGEVIEW_TIME); //五秒钟做一次改变
                }
				break;
			case OPEN_AUTOFOCS_IMAGEVIEW:
				if (null != focusView){
					focusView.setVisibility(View.VISIBLE);
					focusView.setBackgroundDrawable(getResources().getDrawable(R.drawable.auto_focusing));
                	MyHandler.sendEmptyMessageDelayed(CLOSE_AUTOFOCS_IMAGEVIEW, CLOSE_AUTOFOCS_IMAGEVIEW_TIME); //一秒钟做一次改变
                }
				break;
			case SET_AUTOFOCS_ON:
				if (null != camera)
				    camera.autoFocus(mAutoFocusCallback);
				break;
			}
		}
	};

	private final class SurfaceCallback implements Callback {

		// 拍照状态变化时调用该方法
		@Override
		public void surfaceChanged(SurfaceHolder holder, int format, int width,
				int height) {
			Log.i("msg", "width==" + width + ",height==" + height);
			setParameters();
		}

		// 开始拍照时调用该方法
		@Override
		public void surfaceCreated(SurfaceHolder holder) {
			setCamera(cameraID);
		}

		// 停止拍照时调用该方法
		@Override
		public void surfaceDestroyed(SurfaceHolder holder) {
			stopCamera();
		}
	}

//	private void autoFocus() {
////		Camera.Parameters params = camera.getParameters();
////		List<String> FocusModes = params.getSupportedFocusModes();
////		if (FocusModes == null) {
////			return;
////		}
////		if (FocusModes
////				.contains(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE)) {
////			parameters
////					.setFocusMode(Camera.Parameters.FOCUS_MODE_CONTINUOUS_PICTURE);// 1连续对焦
////		}
//		
//		camera.autoFocus(new AutoFocusCallback() {
//			@Override
//			public void onAutoFocus(boolean success, Camera camera) {
//				if (success) {
////					camera.cancelAutoFocus();// 只有加上了这一句，才会自动对焦
//					focusView.setVisibility(View.VISIBLE);
//					mFocusHandler.sendEmptyMessageDelayed(0, 1000);
//				}
//			}
//
//		});
//	}

	Handler mFocusHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			focusView.setVisibility(View.GONE);
		}
	};

	private void openCameraFlash() {

		List<String> flashModes = parameters.getSupportedFlashModes();
		// Check if camera flash exists
		if (flashModes == null) {
			// Use the screen as a flashlight (next best thing)
			return;
		}
		String flashMode = parameters.getFlashMode();

		if (!Parameters.FLASH_MODE_ON.equals(flashMode)) {
			// Turn on the flash
			if (flashModes.contains(Parameters.FLASH_MODE_ON)) {
				parameters.setFlashMode(Parameters.FLASH_MODE_ON);
				camera.setParameters(parameters);
			} else {
			}
		}
	}

	private void closeCameraFlash() {
		List<String> flashModes = parameters.getSupportedFlashModes();
		// Check if camera flash exists
		if (flashModes == null) {
			// Use the screen as a flashlight (next best thing)
			return;
		}
		String flashMode = parameters.getFlashMode();

		if (!Parameters.FLASH_MODE_OFF.equals(flashMode)) {
			// Turn on the flash
			if (flashModes.contains(Parameters.FLASH_MODE_OFF)) {
				parameters.setFlashMode(Parameters.FLASH_MODE_OFF);
				camera.setParameters(parameters);
			} else {
			}
		}
	}

	private void autoCameraFlash() {
		List<String> flashModes = parameters.getSupportedFlashModes();
		// Check if camera flash exists
		if (flashModes == null) {
			// Use the screen as a flashlight (next best thing)
			return;
		}
		String flashMode = parameters.getFlashMode();

		if (!Parameters.FLASH_MODE_AUTO.equals(flashMode)) {
			// Turn on the flash
			if (flashModes.contains(Parameters.FLASH_MODE_AUTO)) {
				parameters.setFlashMode(Parameters.FLASH_MODE_AUTO);
				camera.setParameters(parameters);
			} else {
			}
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		switch (keyCode) {
		case KeyEvent.KEYCODE_CAMERA: // 按下拍照按钮
			if (camera != null && event.getRepeatCount() == 0) {

				if (isTakingClick) {
					return super.onKeyDown(keyCode, event);
				}
				isTakingClick = true;
				takePicClickHandler.sendEmptyMessageDelayed(0, 1000);
				camera.autoFocus(new AutoFocusCallback() {

					@Override
					public void onAutoFocus(boolean success, Camera camera) {
						// TODO Auto-generated method stub
						// success为true表示对焦成功
						if(cameraID==0){
							if (success&&!isTakingPic) {
								isTakingPic = true;
								if (camera != null) {
									// 拍照
									takePic();
								}else {
									clickHandler.sendEmptyMessageDelayed(0, 1000);
								}
							 }
						}else {
							if (camera != null) {
								// 拍照
								if(!isTakingPic){
									isTakingPic = true;
									takePic();
								}
							}
						}
						 
					}
				});
			}
		}
		return super.onKeyDown(keyCode, event);
	}

	// 提供一个静态方法，用于根据手机方向获得相机预览画面旋转的角度
	public static int getPreviewDegree(Activity activity) {
		// 获得手机的方向
		int rotation = activity.getWindowManager().getDefaultDisplay()
				.getRotation();
		int degree = 0;
		// 根据手机的方向计算相机预览画面应该选择的角度
		switch (rotation) {
		case Surface.ROTATION_0:
			degree = 90;
			break;
		case Surface.ROTATION_90:
			degree = 0;
			break;
		case Surface.ROTATION_180:
			degree = 270;
			break;
		case Surface.ROTATION_270:
			degree = 180;
			break;
		}
		return degree;
	}

	public static int getFrontPreviewDegree(Activity activity) {
		// 获得手机的方向
		int rotation = activity.getWindowManager().getDefaultDisplay()
				.getRotation();
		int degree = 0;
		// 根据手机的方向计算相机预览画面应该选择的角度
		switch (rotation) {
		case Surface.ROTATION_0:
			degree = 270;
			break;
		case Surface.ROTATION_90:
			degree = 0;
			break;
		case Surface.ROTATION_180:
			degree = 90;
			break;
		case Surface.ROTATION_270:
			degree = 180;
			break;
		}
		return degree;
	}

	public static int readPictureDegree(String path) {
		int degree = 0;
		try {
			ExifInterface exifInterface = new ExifInterface(path);
			int orientation = exifInterface.getAttributeInt(
					ExifInterface.TAG_ORIENTATION,
					ExifInterface.ORIENTATION_NORMAL);
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
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return degree;
	}

	public static Bitmap rotaingImageView(int angle, Bitmap bitmap) {
		// 旋转图片 动作
		Matrix matrix = new Matrix();
		matrix.postRotate(angle);
		System.out.println("angle2=" + angle);
		// 创建新的图片
		Bitmap resizedBitmap = Bitmap.createBitmap(bitmap, 0, 0,
				bitmap.getWidth(), bitmap.getHeight(), matrix, true);
		return resizedBitmap;
	}

	public static Bitmap rotateBitmap(Bitmap b, int degrees) {
		if (degrees != 0 && b != null) {
			Matrix m = new Matrix();
			m.setRotate(degrees, (float) b.getWidth() / 2,
					(float) b.getHeight() / 2);
			try {
				Bitmap newBitmap = Bitmap.createBitmap(b, 0, 0, b.getWidth(),
						b.getHeight(), m, true);
				if (b != newBitmap) {
					b.recycle();
					b = newBitmap;
				}
			} catch (OutOfMemoryError ex) {
				Log.i("msg", "OutOfMemoryError");
				ex.printStackTrace();
			}
		}
		return b;
	}

	private Bitmap getImageThumbnail(String imagePath, int width, int height) {
		Bitmap bitmap = null;
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		// 获取这个图片的宽和高，注意此处的bitmap为null
		bitmap = BitmapFactory.decodeFile(imagePath, options);
		options.inJustDecodeBounds = false; // 设为 false
		// 计算缩放比
		int h = options.outHeight;
		int w = options.outWidth;
		int beWidth = w / width;
		int beHeight = h / height;
		int be = 1;
		if (beWidth < beHeight) {
			be = beWidth;
		} else {
			be = beHeight;
		}
		if (be <= 0) {
			be = 1;
		}
		options.inSampleSize = be;
		// 重新读入图片，读取缩放后的bitmap，注意这次要把options.inJustDecodeBounds 设为 false
		bitmap = BitmapFactory.decodeFile(imagePath, options);
//		if (cameraID == 0) {
//			bitmap = rotateBitmap(bitmap, getPreviewDegree(this));
//		} else if (cameraID == 1) {
//			bitmap = rotateBitmap(bitmap, getFrontPreviewDegree(this));
//		}
		
		bitmap = rotateBitmap(bitmap, readPictureDegree(imagePath));
		// 利用ThumbnailUtils来创建缩略图，这里要指定要缩放哪个Bitmap对象
		bitmap = ThumbnailUtils.extractThumbnail(bitmap, width, height,
				ThumbnailUtils.OPTIONS_RECYCLE_INPUT);
		return bitmap;
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		return mScaleGestureDetector.onTouchEvent(event);
	}

	public class ScaleGestureListener implements
			ScaleGestureDetector.OnScaleGestureListener {
		float scale;

		@Override
		public boolean onScale(ScaleGestureDetector detector) {
			Log.i("msg", "onScale");
			scale = detector.getScaleFactor();// >1放大，《1是缩小
			Log.i("msg", "scale===" + scale);
			return false;
		}

		@Override
		public boolean onScaleBegin(ScaleGestureDetector detector) {
			// TODO Auto-generated method stub
			Log.i("msg", "onScaleBegin");

			return true;
		}

		@Override
		public void onScaleEnd(ScaleGestureDetector detector) {
			// TODO Auto-generated method stub
			Log.i("msg", "onScaleEnd");
			setZoom(scale);
		}

	}

	private void setZoom(float scale) {
		if (!parameters.isZoomSupported())
			return;
		int maxZoom = parameters.getMaxZoom();
		if (scale > 1) {
			zoom += 5;
		} else if (scale < 1) {
			zoom -= 5;
		}
		if (zoom < 0) {
			zoom = 0;
		} else if (zoom > maxZoom) {
			zoom = maxZoom;
		}
		parameters.setZoom(zoom);
		Log.i("msg", "getMaxZoom==" + parameters.getMaxZoom());
		camera.setParameters(parameters);
	}

	int zoom = 0;
	MediaPlayer shootMP;

	ShutterCallback mShutterCallback = new ShutterCallback() {
		public void onShutter() {
			shootSound();
		}
	};

	/**
	 * 播放系统拍照声音
	 */
	public void shootSound() {
		AudioManager meng = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
		int volume = meng.getStreamVolume(AudioManager.STREAM_NOTIFICATION);

		if (volume != 0) {
			if (shootMP == null)
				shootMP = MediaPlayer
						.create(this,
								Uri.parse("file:///system/media/audio/ui/camera_click.ogg"));
			if (shootMP != null)
				shootMP.start();
		}
	}

	public static int getDisplayOrientation(int degrees, int cameraId) {
		// See android.hardware.Camera.setDisplayOrientation for
		// documentation.
		Camera.CameraInfo info = new Camera.CameraInfo();
		Camera.getCameraInfo(cameraId, info);
		int result;
		if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
			result = (info.orientation + degrees) % 360;
			Log.i("msg", "info.orientation==" + info.orientation);
			result = (360 - result) % 360; // compensate the mirror
		} else { // back-facing
			result = (info.orientation - degrees + 360) % 360;
			Log.i("msg", "info.orientation=======" + info.orientation);
		}
		return result;
	}

	private void insertImage(String fileName) {
		try {
			MediaStore.Images.Media.insertImage(getContentResolver(), fileName,
					new File(fileName).getName(), new File(fileName).getName());
			Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
			Uri uri = Uri.fromFile(new File(fileName));
			intent.setData(uri);
			sendBroadcast(intent);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	public ArrayList<String> GetFiles(String Path, String Extension) // 搜索目录，扩展名，是否进入子文件夹
	{
		ArrayList<String> lstFile = new ArrayList<String>(); // 结果 List
		File[] files = new File(Path).listFiles();

		if (files == null){
			return null;
		}
		for (int i = 0; i < files.length; i++) {
			File f = files[i];
			if (f.isFile()) {
				if (f.getAbsolutePath().endsWith(Extension)) // 判断扩展名
					lstFile.add(f.getAbsolutePath());
			}
		}
		Collections.sort(lstFile, new FileComparator());
		
		/*for(int i = 0; i < lstFile.size() ;i++){
			String str = "file://" + lstFile.get(i) ;
			lstFile.set(i, str);
		}*/
		return lstFile;
	}

	private class FileComparator implements Comparator<String> {

		@Override
		public int compare(String lhs, String rhs) {
			if (new File(lhs).lastModified() <new File(rhs).lastModified()) {
				return 1;// 最后修改的照片在前
			} else {
				return -1;
			}
		}

	}

	
//	private Camera.Size getSuitableSize(List<Size> supportedSizes) {
//		Display display = getWindowManager().getDefaultDisplay();
//		int width = display.getWidth();
//		int height = display.getHeight();
//		List<Camera.Size> sizeList = new ArrayList<Camera.Size>();
//		Camera.Size picSize = supportedSizes.get(0);
//		for (Size size : supportedSizes) {
//			if (size.width == width){
//				sizeList.add(size);
//			 }else if (size.width > width && size.width < picSize.width){
//				 picSize = size;
//			 }
//		}
//		
//		if (sizeList.size() > 0){
//			picSize = sizeList.get(0);
//			for (Size size : sizeList) {
//				if (size.height == height){
//					return size;
//				 }else if (size.height > height && size.height < picSize.height){
//					 picSize = size;
//				 }
//			}
//		}		
//		return picSize;
//	}
	
	private Camera.Size getBiggestSize(List<Size> supportedSizes) {
		Display display = getWindowManager().getDefaultDisplay();
		int width = display.getWidth();
		int height = display.getHeight();
		List<Camera.Size> sizeList = new ArrayList<Camera.Size>();
		Camera.Size picSize = supportedSizes.get(0);
		for (Size size : supportedSizes) {
			if (size.width == width){
				sizeList.add(size);
			 }else if (size.width > width && size.width < picSize.width){
				 picSize = size;
			 }
		}
		if(sizeList.size() > 0){
			picSize = sizeList.get(0);
			for (Size item : sizeList) {
				Size size = item;
				if (picSize.width < size.width && picSize.height < size.height){
					picSize = size;
				}
			}
		}
	return picSize;
}
	
	private Size getOptimalPreviewSize(List<Size> sizes) {
		Display display = getWindowManager().getDefaultDisplay();
		int w = display.getWidth();
		int h = display.getHeight();
		if (h > w) {
			int temp = w;
			w = h;
			h = temp;
		}
		
		final double ASPECT_TOLERANCE = 0.2;
		double targetRatio = (double) w / h;
		if (sizes == null)
			return null;
		Size optimalSize = null;
		double minDiff = Double.MAX_VALUE;
		int targetHeight = h;

		for (Size size : sizes) {
			double ratio = (double) size.width / size.height;
			if (Math.abs(ratio - targetRatio) > ASPECT_TOLERANCE)
				continue;
			if (Math.abs(size.height - targetHeight) < minDiff) {
				optimalSize = size;
				minDiff = Math.abs(size.height - targetHeight);
			}
		}
		// Cannot find the one match the aspect ratio, ignore the
		// requirement
		if (optimalSize == null) {
			minDiff = Double.MAX_VALUE;
			for (Size size : sizes) {
				if (Math.abs(size.height - targetHeight) < minDiff) {
					optimalSize = size;
					minDiff = Math.abs(size.height - targetHeight);
				}
			}
		}
		return optimalSize;
	}
	
	
	public final class FocusCallback implements
			android.hardware.Camera.AutoFocusCallback {
		public void onAutoFocus(boolean focused, Camera camera) {
			closeAutoFocsImage();
			/* 对到焦点拍照 */
			if (focused) {
				focusView.setVisibility(View.VISIBLE);
				focusView.setBackgroundDrawable(getResources().getDrawable(R.drawable.auto_focu_ok));
				MyHandler.sendEmptyMessageDelayed(CLOSE_AUTOFOCS_IMAGEVIEW,
						CLOSE_AUTOFOCS_IMAGEVIEW_TIME); // 一秒钟做一次改变
			} else {
				MyHandler.sendEmptyMessageDelayed(OPEN_AUTOFOCS_IMAGEVIEW,
						OPEN_AUTOFOCS_IMAGEVIEW_TIME);
			}
			MyHandler.sendEmptyMessageDelayed(SET_AUTOFOCS_ON,
					SET_AUTOFOCS_ON_TIME);
		}
	};
	
	private void closeAutoFocsImage(){	
		if (null != MyHandler){
			MyHandler.removeMessages(CLOSE_AUTOFOCS_IMAGEVIEW);
			MyHandler.removeMessages(OPEN_AUTOFOCS_IMAGEVIEW);
			MyHandler.removeMessages(SET_AUTOFOCS_ON);
		}
        if (null != focusView){
        	focusView.setVisibility(View.INVISIBLE);
		}
	}
}
