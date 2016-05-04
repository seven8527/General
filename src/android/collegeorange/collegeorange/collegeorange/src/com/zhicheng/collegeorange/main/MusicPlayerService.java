package com.zhicheng.collegeorange.main;

import java.io.IOException;

import android.app.Service;
import android.content.Intent;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnErrorListener;
import android.os.Binder;
import android.os.IBinder;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

public class MusicPlayerService extends Service
{
	private final IBinder mBinder = new LocalBinder();
    
    private MediaPlayer mMediaPlayer = null;

    public static final String PLAYER_PREPARE_END = "com.tomoon.recorder.prepared";
    public static final String PLAY_COMPLETED = "com.tomoon.recorder.playcompleted";
    
    
    MediaPlayer.OnCompletionListener mCompleteListener = new MediaPlayer.OnCompletionListener() 
    {
        public void onCompletion(MediaPlayer mp) 
        {
            broadcastEvent(PLAY_COMPLETED);
            stop();
        }
    };
    
    MediaPlayer.OnPreparedListener mPrepareListener = new MediaPlayer.OnPreparedListener() 
    {
        public void onPrepared(MediaPlayer mp) 
        {   
            broadcastEvent(PLAYER_PREPARE_END);
        }
        
    };
    
    MediaPlayer.OnErrorListener mErrorListener = new OnErrorListener() {
		
		@Override
		public boolean onError(MediaPlayer arg0, int arg1, int arg2) {
			// TODO Auto-generated method stub
			if(mMediaPlayer!=null){
				stop();
			}
			Log.d("Music", "error: " + arg1 + " " + arg2);
			//True if the method handled the error, 
			//false if it didn't. Returning false,
			//or not having an OnErrorListener at all, 
			//will cause the OnCompletionListener to be called.
			return true;//true
		}
	};
        
    private void broadcastEvent(String what)
	{
    	Log.d("Music", "broad " + what);
		Intent i = new Intent(what);
		LocalBroadcastManager.getInstance(this).sendBroadcast(i);
	}


	public void onCreate()
	{
		super.onCreate();
		initMediaPlayer();
		Log.i("Music", "service onCreate");
	}
	
	private void initMediaPlayer() {
		if(mMediaPlayer==null){
			mMediaPlayer = new MediaPlayer();
			mMediaPlayer.setOnPreparedListener(mPrepareListener);
			mMediaPlayer.setOnCompletionListener(mCompleteListener);
			mMediaPlayer.setOnErrorListener(mErrorListener);
		}
	}

	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		stop();
		mMediaPlayer.release();
		mMediaPlayer=null;
		Log.i("Music", "service onDestroy");
	}

	public class LocalBinder extends Binder
	{
		public MusicPlayerService getService()
		{
			return MusicPlayerService.this;
		}
	}


	public IBinder onBind(Intent intent)
	{
		Log.i("Music", "service onBind");
		return mBinder;
	}


	public void setDataSource(String path)
	{
		
		initMediaPlayer();

		try
		{
			mMediaPlayer.reset();
			mMediaPlayer.setDataSource(path);
			mMediaPlayer.prepare();
		}
		catch (IOException e)
		{
			return;
		}
		catch (IllegalArgumentException e)
		{
			return;
		}
	}


	public void start()
	{
		if(mMediaPlayer==null){
			return;
		}
		mMediaPlayer.start();
	}


	public void stop()
	{
		if(mMediaPlayer==null){
			return;
		}
		mMediaPlayer.stop();
	}


	public void pause()
	{
		if(mMediaPlayer==null){
			return ;
		}
		mMediaPlayer.pause();
	}


	public boolean isPlaying()
	{
		if(mMediaPlayer==null){
			return false;
		}
		return mMediaPlayer.isPlaying();
	}


	public int getDuration()
	{
		if(mMediaPlayer==null){
			return 0;
		}
		return mMediaPlayer.getDuration();
	}


	public int getPosition()
	{
		if(mMediaPlayer==null){
			return 0;
		}
		return mMediaPlayer.getCurrentPosition();
	}


	public long seek(int progress)
	{
		if(mMediaPlayer==null){
			return 0;
		}
		long whereto = progress*getDuration()/100;
		mMediaPlayer.seekTo((int) whereto);
		return whereto;
	}
}

