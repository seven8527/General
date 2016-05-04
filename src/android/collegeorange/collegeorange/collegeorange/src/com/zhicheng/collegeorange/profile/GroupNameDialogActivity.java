package com.zhicheng.collegeorange.profile;

import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.zhicheng.collegeorange.R;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;


public class GroupNameDialogActivity extends Activity {
	
	private TextView textView;
	private String mTitle;
	private RadioButton man;
	private RadioButton women;
	private EditText editText;
	private RadioGroup radioGroup;
	private String sex = "F";
	public static final String type = "type";
	public static final String text_content = "text_content";
	private String mType = null;
	private InputMethodManager imm;
	public static final String nickName = "nikeName";
	public static final String signature = "signature";
	public static final String qr_code = "qr_code";
	public static final String age = "info_age";
	public static final String hobbies = "info_hobbies";
	public static final String city = "city";
	public static final String shop = "shop";
	public static final String weight = "info_weight";
	
	private String mGroupName = null;
	private String mGroupID = null;
	
	private String mBlood;
	
	EditText edit1;
	EditText edit2;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_group_name_dialog);
		imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		initView();
		initData();
//		openInputMethod(editText);
	}
	
	private void initView(){
		textView = (TextView) findViewById(R.id.name_text);
		radioGroup = (RadioGroup) findViewById(R.id.sex);
		man = (RadioButton) findViewById(R.id.man);
		women = (RadioButton) findViewById(R.id.women);
		editText = (EditText) findViewById(R.id.edit);
		edit1 = (EditText) findViewById(R.id.edit1);
		edit2 = (EditText) findViewById(R.id.edit2);
		
		String gender = getIntent().getStringExtra("gender");
		mType = getIntent().getStringExtra(type); 
		
		mGroupName = getIntent().getStringExtra("group_name");
		mGroupID = getIntent().getStringExtra("group_id");
		
		mBlood = getIntent().getStringExtra("blood");
		if(TextUtils.equals(gender, "F")){
			women.setChecked(true);
			sex = "F";
		}else{
			man.setChecked(true);
			sex = "M";
		}
		
		
		man.setOnClickListener(onClickListener);
		women.setOnClickListener(onClickListener);
		
//		editText.addTextChangedListener(mTextWatcher);
	}
	
	private void initData(){
		mTitle = getIntent().getStringExtra("title");
	
		if(mTitle !=  null && !mTitle.equals("")){
			textView.setText(mTitle);
			if(mTitle.equals("Gender")){
				editText.setVisibility(View.GONE);
				radioGroup.setVisibility(View.VISIBLE);
				textView.setText(R.string.info_sex);
			}
		}else if (!TextUtils.isEmpty(mType)){
			
			try {
				if (mType.equals(nickName)){
					textView.setText(R.string.info_name);
					editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(24)}); 
				}else if (mType.equals(signature)){
					textView.setText(R.string.signature_tag);
					editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(48)}); 
				}else if (mType.equals(age)){
					textView.setText(R.string.info_age);
					editText.setInputType(InputType.TYPE_CLASS_NUMBER);
					editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(3)}); 
				}else if (mType.equals(hobbies)){
					textView.setText(R.string.info_hobbies);
					editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(48)}); 
				}else if (mType.equals(city)){
					textView.setText(R.string.info_school);
					editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(12)}); 
				}else if(mType.equals(weight)){
					textView.setText(R.string.health_weight_text);
					editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(3)}); 
				}else if (mType.equals(shop)){
					textView.setText("微店名称");
					editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(32)}); 
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			try {
				String content = getIntent().getStringExtra(text_content); 
				editText.setText(content);
				editText.setSelection(content.length());//set cursor to the end  
				editText.requestFocus();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(!TextUtils.isEmpty(mGroupID)){
			
			if(!TextUtils.isEmpty(mGroupName)){
				editText.setText(mGroupName);				
			}else{
				editText.setText("");
			}
			
			editText.setSelection(editText.getText().length());
			editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(24)});
			editText.requestFocus();
		}else if(!TextUtils.isEmpty(mBlood)){
			findViewById(R.id.bloodLayout).setVisibility(View.VISIBLE);
			editText.setVisibility(View.GONE);
			textView.setText("设置高低血糖");
			double max = getIntent().getDoubleExtra("max", 7.8);
			double min = getIntent().getDoubleExtra("min", 3.9);
			edit1.setText(max + "");
			edit2.setText(min + "");
		}
	}
	
	@Override
	protected void onResume() {
		// TODO 自动生成的方法存根
		super.onResume();
		
		mHandler.sendEmptyMessageDelayed(0, 100);
	}

	private void showKeybroad(){
		if(editText != null && editText.getVisibility() == View.VISIBLE){
			editText.requestFocus();
			InputMethodManager imm = (InputMethodManager) editText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
			imm.toggleSoftInput(0, InputMethodManager.SHOW_FORCED); 
		}
	}
	
	private Handler mHandler = new Handler(){
		
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case 0:
				showKeybroad();
				break;

			default:
				break;
			}
		
		}
	};
	
	private OnClickListener onClickListener = new OnClickListener() {
		
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.man:
				sex = "M";
				break;
			case R.id.women:
				sex = "F";
				break;
			default:
				break;
			}
			
		}
	};
	
	
	
	@Override
	protected void onDestroy() {
		imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
		super.onDestroy();
	}

	public void onCancel(View v) {
		imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
		finish();
	}

	public void onOK(View v) {
		String str = editText.getText().toString();
		if(!TextUtils.isEmpty(str)){
			str = str.trim();
		}
		Intent intent = new Intent();
		if(mTitle !=  null && !mTitle.equals("")){
			if(mTitle.equals("Gender")){
				str = sex;
			}
			intent.putExtra("name", str);
			intent.putExtra("title", mTitle);
		}else if (!TextUtils.isEmpty(mType)){
			if(TextUtils.isEmpty(str)){
				Toast.makeText(this, editText.getText().toString()+"不能为空", Toast.LENGTH_SHORT).show();
				return;
			}else if(TextUtils.isEmpty(str.trim())){
				Toast.makeText(this, editText.getText().toString()+"无效的昵称", Toast.LENGTH_SHORT).show();
				return;
			}
			
//			str = replaceBlank(str);
			str = str.trim();
			if(TextUtils.isEmpty(str)){
				Toast.makeText(this, editText.getText().toString()+"不能为空", Toast.LENGTH_SHORT).show();
				return;
			}
			

			if (mType.equals(age)){
				try {
					int ageNum = Integer.parseInt(str);
					if(ageNum < 0 || ageNum > 127){
						Toast.makeText(this, "您输入的年龄不合适！", Toast.LENGTH_SHORT).show();
						return;
					}
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}

			intent.putExtra(type, mType);
			intent.putExtra(mType, str);
		}else if (!TextUtils.isEmpty(mBlood)){
			String max = edit1.getText().toString();
			String min = edit2.getText().toString();
			if (!TextUtils.isEmpty(max)&&!TextUtils.isEmpty(min)) {
				str.trim();
			}else{
				Toast.makeText(this, "警戒值不能为空", Toast.LENGTH_SHORT).show();
				return;
			}
			if (Double.valueOf(max) == Double.valueOf(min)) {
				Toast.makeText(this, "高低警戒值不能相等", Toast.LENGTH_SHORT).show();
				return;
			}
						
			intent.putExtra("max", Double.valueOf(max));
			intent.putExtra("min", Double.valueOf(min));
		}else{
			if(TextUtils.isEmpty(str)){
				Toast.makeText(this, "群聊名称不能为空", Toast.LENGTH_SHORT).show();
				return;
			}
			intent.putExtra("name", str);
		}
		setResult(RESULT_OK, intent);
		imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
		finish();
	}

	public void openInputMethod(final EditText editText) {

		Timer timer = new Timer();
		timer.schedule(new TimerTask() {
			public void run() {
				InputMethodManager inputManager = (InputMethodManager) editText
						.getContext().getSystemService(
								Context.INPUT_METHOD_SERVICE);
				inputManager.showSoftInput(editText, 0);
			}
		}, 200);
	}
//	TextWatcher mTextWatcher = new TextWatcher() {
//
//		@Override
//		public void onTextChanged(CharSequence s, int start, int before, int count) {
//		}
//
//		@Override
//		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
//		}
//
//		@Override
//		public void afterTextChanged(Editable s) {
//			if (mType.equals(nickName)){
//			}else if (mType.equals(signature)){
//				
//			}else if (mType.equals(age)){
//				
//			}else if (mType.equals(hobbies)){
//				
//			}else if (mType.equals(city)){
//				
//			}
//		}
//	};
	
	public String replaceBlank(String str) {
		String dest = "";
		if (str != null) {
			Pattern p = Pattern.compile("\\s*|\t|\r|\n");
			Matcher m = p.matcher(str);
			dest = m.replaceAll("");
		}
		return dest;
	}
}
