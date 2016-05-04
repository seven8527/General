package com.zhicheng.collegeorange.profile;

import java.io.IOException;
import java.net.ConnectException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;

import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.zhicheng.collegeorange.R;
import com.zhicheng.collegeorange.Utils;
import com.zhicheng.collegeorange.deprecated.ItemListActivity;
import com.zhicheng.collegeorange.main.ShareService;
import com.zhicheng.collegeorange.main.SharedHelper;
import com.zhicheng.collegeorange.model.Circle;
import com.zhicheng.collegeorange.utils.MD5;
import com.zhicheng.collegeorange.utils.StringUtil;
import com.zhicheng.collegeorange.utils.ToastUtil;

/**
 * A login screen that offers login via email/password.
 */
public class LoginActivity extends Activity {

    /**
     * Id to identity READ_CONTACTS permission request.
     */
    private static final int REQUEST_READ_CONTACTS = 0;

    /**
     * A dummy authentication store containing known user names and passwords.
     * TODO: remove after connecting to a real authentication system.
     */
    private static final String[] DUMMY_CREDENTIALS = new String[]{
            "foo@example.com:hello", "bar@example.com:world"
    };
    
    private Context mContext;
    
    private UserLoginTask mAuthTask = null;

    // UI references.
    private EditText mEmailView;
    private EditText mPasswordView;
    private View mProgressView;
    private View mLoginFormView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = this;
        setContentView(R.layout.activity_login);
        
        initTitleView();
        // Set up the login form.
        mEmailView = (EditText) findViewById(R.id.email);
       // populateAutoComplete();

        mPasswordView = (EditText) findViewById(R.id.password);
        mPasswordView.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int id, KeyEvent keyEvent) {
                if (id == R.id.login || id == EditorInfo.IME_NULL) {
                    attemptLogin();
                    return true;
                }
                return false;
            }
        });

        Button mEmailSignInButton = (Button) findViewById(R.id.email_sign_in_button);
        mEmailSignInButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                attemptLogin();
            }
        });
        this.findViewById(R.id.register_page).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				goRegisterPage(0);
			}
		});
        
        this.findViewById(R.id.find_pwd_page).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				goRegisterPage(1);
			}
		});
        mLoginFormView = findViewById(R.id.login_form);
        mProgressView = findViewById(R.id.login_progress);
    }
    
    private void initTitleView(){
    	this.findViewById(R.id.title_back).setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				finish();
			}
		});
    	TextView titleText = (TextView)this.findViewById(R.id.title_middle1);
    	titleText.setText(R.string.title_login);
    }
    
    private void goRegisterPage(int mode){
    	Intent intent = new Intent(this, RegisterActivity.class);
    	intent.putExtra("mode", mode);
    	startActivity(intent);
    }

  

    /**
     * Attempts to sign in or register the account specified by the login form.
     * If there are form errors (invalid email, missing fields, etc.), the
     * errors are presented and no actual login attempt is made.
     */
    private void attemptLogin() {
        if (mAuthTask != null) {
            return;
        }

        // Reset errors.
        mEmailView.setError(null);
        mPasswordView.setError(null);

        // Store values at the time of the login attempt.
        String email = mEmailView.getText().toString();
        String password = mPasswordView.getText().toString();

        boolean cancel = false;
        View focusView = null;

        // Check for a valid password, if the user entered one.
        if (!TextUtils.isEmpty(password) && !isPasswordValid(password)) {
            mPasswordView.setError(getString(R.string.error_invalid_password));
            focusView = mPasswordView;
            cancel = true;
        }

        // Check for a valid email address.
        if (TextUtils.isEmpty(email)) {
            mEmailView.setError(getString(R.string.error_field_required));
            focusView = mEmailView;
            cancel = true;
        } else if (!isPhoneValid(email)) {
            mEmailView.setError(getString(R.string.error_invalid_email));
            focusView = mEmailView;
            cancel = true;
        }

        if (cancel) {
            // There was an error; don't attempt login and focus the first
            // form field with an error.
            focusView.requestFocus();
        } else {
            // Show a progress spinner, and kick off a background task to
            // perform the user login attempt.
            showProgress(true);
            mAuthTask = new UserLoginTask(email, password);
            mAuthTask.execute((Void) null);
        }
    }

    private boolean isPhoneValid(String email) {
        //TODO: Replace this with your own logic
    	if(TextUtils.isEmpty(email)){
    		return false;
    	}
    	
    	if(email.length() == 11
    			&& StringUtil.isNumeric(email)){
    		return true;
    	}
    	
        return false;
    }

    private boolean isPasswordValid(String password) {
        //TODO: Replace this with your own logic
        return password.length() >= 6;
    }

    /**
     * Shows the progress UI and hides the login form.
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR2)
    private void showProgress(final boolean show) {
        // On Honeycomb MR2 we have the ViewPropertyAnimator APIs, which allow
        // for very easy animations. If available, use these APIs to fade-in
        // the progress spinner.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
            int shortAnimTime = getResources().getInteger(android.R.integer.config_shortAnimTime);

            mLoginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
            mLoginFormView.animate().setDuration(shortAnimTime).alpha(
                    show ? 0 : 1).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    mLoginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
                }
            });

            mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
            mProgressView.animate().setDuration(shortAnimTime).alpha(
                    show ? 1 : 0).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
                }
            });
        } else {
            // The ViewPropertyAnimator APIs are not available, so simply show
            // and hide the relevant UI components.
            mProgressView.setVisibility(show ? View.VISIBLE : View.GONE);
            mLoginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
        }
    }

    
    private void getUserInfo(String  uid) {
    	SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);
    	String myName = shareHelper.getString(SharedHelper.USER_NAME, "");
    	String mySession = shareHelper.getString(SharedHelper.USER_SESSION_ID, "");
		try {
			String url = Utils.REMOTE_SERVER_URL + "/user/info/"+uid+"?uid="+myName+"&session="+mySession;
			HttpGet httpGet = new HttpGet(url);
            HttpClient httpClient = new DefaultHttpClient();

            // 发送请求
            HttpResponse response = httpClient.execute(httpGet);
			int code = response.getStatusLine().getStatusCode();
			if (code != 200) {
				return;
			}
			String mHistoryList = EntityUtils.toString(response.getEntity());
			JSONObject jsonObj= new JSONObject(mHistoryList);
			
			int resultCode = -1;
			if(jsonObj.has("code")){
				resultCode = jsonObj.getInt("code");
			}
			
			if (resultCode == 0 && jsonObj.has("data")) {
				
				JSONObject jsonObject = jsonObj.getJSONObject("data");
				
				if(jsonObject.has("Profile")){
					JSONObject infoObject = jsonObject.getJSONObject("Profile");
					
					if(infoObject.has("Nickname")){						
						shareHelper.putString(SharedHelper.USER_NICKNAME, infoObject.getString("Nickname"));
					}
					
					if(infoObject.has("Avatar")){						
						shareHelper.putString(SharedHelper.USER_ICON, infoObject.getString("Avatar"));
					}
					
					if(infoObject.has("Signature")){						
						shareHelper.putString(SharedHelper.USER_SIGNATION, infoObject.getString("Signature"));
					}
					
					if(infoObject.has("Gender")){						
						shareHelper.putString(SharedHelper.USER_GENDER, infoObject.getString("Gender"));
					}
					
					if(infoObject.has("School")){						
						shareHelper.putString(SharedHelper.USER_SCHOOL, infoObject.getString("School"));
					}
					
					if(infoObject.has("CreateTime")){						
						shareHelper.putString(SharedHelper.USER_REGISTE_TIME, infoObject.getString("CreateTime"));
					}
					Intent intent = new Intent(Utils.USER_INFO_CHANGE);
					LocalBroadcastManager.getInstance(mContext).sendBroadcast(intent);
				}
				
				/*“data”:
				{	
				Id       string,   用户ID
				Username string,   用户名
				Profile:
				{
				Nickname   string,   昵称
				Avatar      string,   头像文件名
				Signature   string,    签名
				Gender     string,    性别， ‘M’-男， ‘F’-女
				School      string,    学校
				CreateTime  string     注册时间
				}
				}*/		
				
				
			}
			
		} catch (ConnectTimeoutException e) {
			e.printStackTrace();
		} catch (SocketTimeoutException e) {
			e.printStackTrace();
		} catch (ConnectException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}	

    /**
     * Represents an asynchronous login/registration task used to authenticate
     * the user.
     */
    public class UserLoginTask extends AsyncTask<Void, Void, Integer> {

        private final String mPhone;
        private final String mPassword;

        UserLoginTask(String email, String password) {
            mPhone = email;
            mPassword = password;
        }

        @Override
        protected Integer doInBackground(Void... params) {
            // TODO: attempt authentication against a network service.
        	try {
        		String pwdMd5 = MD5.digestString(mPassword).toLowerCase();
        		
				JSONObject obj = new JSONObject();
				obj.put("Username", mPhone);
				obj.put("Password", pwdMd5);
				
				HttpResponse response = Utils.getResponse(Utils.REMOTE_SERVER_URL + "/user/login", obj, 30000, 30000);
								
				int code = response.getStatusLine().getStatusCode();
				if (code != 200) {
					Log.e("logo", "login code:"+code);
					return -1;
				}			
				
				String mCommentViewpointList = EntityUtils.toString(response.getEntity());
				 if (!TextUtils.isEmpty(mCommentViewpointList)) {
					 JSONObject jsonObject = new JSONObject(mCommentViewpointList);
					if (jsonObject.has("code")) {
						int resultCode = jsonObject.getInt("code");
						if(resultCode == 0){
							JSONObject jsonObj = jsonObject.getJSONObject("data");
							int uid = jsonObj.getInt("Uid");
							String session = jsonObj.getString("Session");
							
							SharedHelper shareHelper = SharedHelper.getShareHelper(mContext);							
							shareHelper.putString(SharedHelper.USER_NAME, ""+ uid);
							shareHelper.putString(SharedHelper.USER_SESSION_ID, session);
							shareHelper.putInt(SharedHelper.WHICH_ME, 1);
							
							Intent intent = new Intent(Utils.LOGIN_STATE_CHANGE);
							LocalBroadcastManager.getInstance(mContext).sendBroadcast(intent);
							getUserInfo(""+uid);
							return 0;
						}else{
							
							
							return resultCode;
						}					
					}
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}           
            return -1;
        }

        @Override
        protected void onPostExecute(final Integer code) {
            mAuthTask = null;
            showProgress(false);

            if (code == 0) {
            	ToastUtil.showToast(mContext, "登录成功");
               
                finish();
            } else {
                mPasswordView.setError(getString(R.string.error_incorrect_password));
                mPasswordView.requestFocus();
            }
        }

        @Override
        protected void onCancelled() {
            mAuthTask = null;
            showProgress(false);
        }
        
    }
}

