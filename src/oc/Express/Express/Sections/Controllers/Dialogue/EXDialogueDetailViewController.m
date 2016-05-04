//
//  EXDialogueDetailViewController.m
//  Express
//
//  Created by owen on 15/11/12.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXDialogueDetailViewController.h"
#import "DBHelper.h"
#import "DBMessageManager.h"
#import "EXDialogueDetailTableViewCell.h"
#import "Utils.h"
#import "EXHttpHelper.h"
#import "LVRecordTool.h"
#import "EXCreateGroupViewController.h"
#import "EXDialogueGroupSettingViewController.h"
#import "DBFriendManager.h"
#import "MediaPlayer/MediaPlayer.h"
#import "TMVideoPickerViewController.h"
#import "DBDialogueMemberManager.h"



#define kCellHight_top 3.0f
#define kCellHight_interval 4.0f
#define kCellHight_padding 2.0f
#define kCellHight_time 20.0f
#define kCellHight_sysMsg  25.0f
#define kCellHight_name  15.0f
#define kCellHight_logo  40.0f
#define kCellHight_bottom  3.0f

#define kFaceBoard_Hight  216.0f  //表情键盘高度


#define kCellHight_bigEmoji  75.0f
// 照片原图路径
#define KOriginalPhotoImagePath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]



@interface EXDialogueDetailViewController ()
@property (nonatomic, assign) float keyboardHight;
@property (nonatomic, assign) float lastInputHight;
@property (nonatomic, assign) float changedHight;
@property (nonatomic, assign) float totalChangedHight;
@property (nonatomic, assign) NSInteger  lastLineNum;
@property (nonatomic, assign) BOOL  isMaxInput;
@property (assign, nonatomic) NSInteger currentRow;
@property (nonatomic, assign) NSInteger offset;

@property (nonatomic, strong) NSString * lastTimeOfMessage; //记录上一条消息的时间
@property (nonatomic, assign) BOOL didSetupConstraints;


@property (strong, nonatomic) LVRecordTool* recordTool;
//添加录音功能的属性
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSURL *audioPlayURL;
@property (strong, nonatomic) NSString *voicefileName;

@property (assign, nonatomic) BOOL *isFaceBoardShow;
@property (strong, nonatomic) DialogueListEntity *dialogueListEntity;
@property (assign, nonatomic) double currentTime;
@property (assign, nonatomic) BOOL isSendBtnClicked;

@property (assign, nonatomic) int   reSendMsgRow;
@property (strong, nonatomic) NSMutableArray * photos ;
@property (strong, nonatomic) MWPhotoBrowser *browser;
@property (strong, nonatomic) NSMutableArray *photoMapArray;

@property (strong, nonatomic) MPMoviePlayerController *movie;


@end

@implementation EXDialogueDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBarImgBtn:nil];
    [self setTitle:@"对话"];
    if ([_groupType boolValue]) {
        [self setRightBarImgBtn:@"title_shezhi"];
    }
    else
    {
        [self setRightBarImgBtn:@"dialogue_group"];
    }
  
    
    _currentRow = -1;
    _offset = 0;
    
    
    [self configUI];
    [self initData];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadList:) name:KNOTIFI_MESSAGE_UPDATE_DIALOGUE_DETAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_movie];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    [self createBrowser];
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBDialogueListManager queryByID:_groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
            _dialogueListEntity = result;
            _isShowName =  [_dialogueListEntity.isShowMember boolValue];
            NSString *nameStr = [[NSString alloc]init];
            if ([_groupType boolValue]) {
                if ([Utils isBlankString:_dialogueListEntity.groupName]) {
                    for (DialogueMemberEntity * memberEntity in _dialogueListEntity.groupMemberList) {
                        nameStr = [nameStr stringByAppendingString:memberEntity.nickName];
                    }
                    [self setTitle:nameStr];
                }
                else
                {
                    [self setTitle:_dialogueListEntity.groupName];
                }
            }
            else
            {
                [DBFriendManager queryByID:_groupId FMDatabase:db QueryResult:^(FriendEntity *result) {
                    [self setTitle:result.nickName];
                }];
            }
            [_tableView reloadData];
            
        }];
    }];
   }

-(void)createBrowser
{
    
    _browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    _browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    _browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    _browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    _browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    _browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    _browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    _browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    _browser.autoPlayOnAppear = NO; // Auto-play first video
    // Manipulate
    [_browser showNextPhotoAnimated:YES];
    [_browser showPreviousPhotoAnimated:YES];
    [_browser setCurrentPhotoIndex:0];
}
-(void)rightBtnAction:(id)sender
{
    if ([_groupType boolValue]) {
        EXDialogueGroupSettingViewController *groupSettingCtl = [[EXDialogueGroupSettingViewController alloc]init];
        groupSettingCtl.groupId =_groupId;
        [self.navigationController pushViewController:groupSettingCtl animated:YES];
        
    }
    else
    {
        EXCreateGroupViewController * createGroupCtl = [[EXCreateGroupViewController alloc]init];
        createGroupCtl.delegate = self;
        createGroupCtl.isCreate = YES;
        createGroupCtl.selectedFriDic = [[NSMutableArray alloc]initWithObjects:_groupId,nil];
        [self.navigationController pushViewController:createGroupCtl animated:YES ];
 
    }
}
-(void) configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(KEEEEEEColor);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置下拉刷新
    [self.view addSubview:_tableView];
    __weak EXDialogueDetailViewController *weakSelf = self; //防止循环引用
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf initData];
    }];
    
     _faceBoard = [[FaceBoard alloc]init];

    
    //底部背景图
    self.bottomView = [UIView newAutoLayoutView];
    self.bottomView.backgroundColor = UIColorFromRGB(KF8F8F8Color);
//    self.bottomView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.bottomView];
    //键盘icon
    self.changeTocontextBtn = [UIButton newAutoLayoutView];
    [self.changeTocontextBtn setImage:[UIImage imageNamed:@"to_edit_normal"] forState:UIControlStateNormal];
    [self.changeTocontextBtn setImage:[UIImage imageNamed:@"to_edit_click"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.changeTocontextBtn];
    
    //语音icon
    self.changeToVoiceBtn = [UIButton newAutoLayoutView];
    [self.changeToVoiceBtn setImage:[UIImage imageNamed:@"to_voice_normal"] forState:UIControlStateNormal];
    [self.changeToVoiceBtn setImage:[UIImage imageNamed:@"to_voice_hightLight"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.changeToVoiceBtn];
    [self.changeToVoiceBtn setHidden:YES];
    
    
    //语音button
    self.voiceBtn = [UIButton newAutoLayoutView];
    [self.voiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.voiceBtn setTitleColor:UIColorFromRGB(K7F7F7FColor) forState:UIControlStateNormal];
    [self.voiceBtn setTitleColor:UIColorFromRGB(KEBBBAAColor) forState:UIControlStateHighlighted];
    self.voiceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [self.voiceBtn.layer setMasksToBounds:YES];
    [self.voiceBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    [self.voiceBtn.layer setBorderWidth:1.0]; //边框宽度
    [self.voiceBtn.layer setBorderColor: UIColorFromRGB(KADADADColor).CGColor];//边框颜色
    [self.bottomView addSubview:self.voiceBtn];
    

    
    //输入框
    self.contextTextView = [UITextView newAutoLayoutView];
    [self.contextTextView.layer setMasksToBounds:YES];
    [self.contextTextView.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    [self.contextTextView.layer setBorderWidth:1.0]; //边框宽度
    [self.contextTextView.layer setBorderColor: UIColorFromRGB(KADADADColor).CGColor];//边框颜色
    self.contextTextView.returnKeyType = UIReturnKeySend;//返回键的类型
    self.contextTextView.font = [UIFont systemFontOfSize:15];
    self.contextTextView.enablesReturnKeyAutomatically = NO;
    self.contextTextView.delegate = self;
    [self.bottomView addSubview:self.contextTextView];
    [self.contextTextView setHidden:YES];
    
    
    //表情icon
    self.smiliesBtn = [UIButton newAutoLayoutView];
    [self.smiliesBtn setImage:[UIImage imageNamed:@"chat_icon_smiles"] forState:UIControlStateNormal];
    [self.smiliesBtn setImage:[UIImage imageNamed:@"chat_icon_smiles_pressed"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.smiliesBtn];
    [self.smiliesBtn setHidden:YES];
    
    //添加多媒体icon
    self.addMediaBtn = [UIButton newAutoLayoutView];
    [self.addMediaBtn setImage:[UIImage imageNamed:@"add_select_normal"] forState:UIControlStateNormal];
    [self.addMediaBtn setImage:[UIImage imageNamed:@"add_hightLight"] forState:UIControlStateHighlighted];
    [self.bottomView addSubview:self.addMediaBtn];
    
    //发送icon
    self.sendBtn = [UIButton newAutoLayoutView];
    [self.sendBtn setImage:[UIImage imageNamed:@"btn_send_normal"] forState:UIControlStateNormal];
    [self.sendBtn setImage:[UIImage imageNamed:@"btn_send_hightLight"] forState:UIControlStateSelected];
    [self.bottomView addSubview:self.sendBtn];
    [self.sendBtn setHidden:YES];
    
    
    
    [self.changeTocontextBtn addTarget:self action:@selector(changeToContext) forControlEvents:UIControlEventTouchUpInside];
    [self.changeToVoiceBtn addTarget:self action:@selector(changeToVoice) forControlEvents:UIControlEventTouchUpInside];
//    [self.voiceBtn addTarget:self action:@selector(sendVoice) forControlEvents:UIControlEventTouchUpInside];
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sendVoice:)];
//    //设置长按时间
//    longPress.minimumPressDuration = 0.2;
//    [self.voiceBtn addGestureRecognizer:longPress];
    [self.smiliesBtn addTarget:self action:@selector(smilies) forControlEvents:UIControlEventTouchUpInside];
    [self.addMediaBtn addTarget:self action:@selector(addMedia) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    
    [self.voiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.voiceBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    
    
//    self.voiceBtn.delegate = self;
    // 录音按钮
    [self.voiceBtn addTarget:self action:@selector(recordBtnDidTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.voiceBtn addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceBtn addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];

    
    [self updateViewConstraints];
}

-(void) initData
{
    
    _recordTool  = [LVRecordTool sharedRecordTool];
    _recordTool.delegate = self;
    [self getGroupInfo];
    
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBMessageManager queryLimitByID:_groupId  FMDatabase:db OffSet:_offset QueryResult:^(NSMutableArray *result) {
            if (_dialogueDetailDict == nil) {
                _dialogueDetailDict = [[NSMutableArray alloc]init];
            }
            [_dialogueDetailDict  addObjectsFromArray:result];
            NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"rectime" ascending:YES];
            NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
            NSArray *sortArray=[_dialogueDetailDict sortedArrayUsingDescriptors:sortDescriptors];
            
           
            self.dialogueDetailDict =  [sortArray mutableCopy];
            
            [self initBrowser];
            [_tableView reloadData];
            [_tableView.header endRefreshing];
            
            
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[result count] inSection:0];
            if (_offset ==0)
            {
                [_tableView setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            }
            else
            {
                 [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
           
            
            _offset += [result count];
        }];
    }];
    
}
-(void)reloadList:(NSNotification *)aNotification
{
    _offset = 0;
    FMDatabase *db = [aNotification object];
    [DBMessageManager queryLimitByID:_groupId  FMDatabase:db OffSet:_offset QueryResult:^(NSMutableArray *result) {
        NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"rectime" ascending:YES];
        NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
        NSArray *sortArray=[result sortedArrayUsingDescriptors:sortDescriptors];
        
        
        self.dialogueDetailDict =  [sortArray mutableCopy];
         [self initBrowser];
        [_tableView reloadData];
        [_tableView.header endRefreshing];
         _offset += 20;

    }];
}

-(void)reloadListFromDB:(FMDatabase *)db
{
    _offset = 0;
    [DBMessageManager queryLimitByID:_groupId  FMDatabase:db OffSet:_offset QueryResult:^(NSMutableArray *result) {
        NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:@"rectime" ascending:YES];
        NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
        NSArray *sortArray=[result sortedArrayUsingDescriptors:sortDescriptors];
        
        
        self.dialogueDetailDict =  [sortArray mutableCopy];
        [self initBrowser];
        [_tableView reloadData];
        [_tableView.header endRefreshing];
        _offset += 20;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dialogueDetailDict.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}
- (void) initBrowser
{
    _photoMapArray = [[NSMutableArray alloc]init];
    _photos = [NSMutableArray array];
    for (MessageEntity *messageDict in _dialogueDetailDict) {
        if ([messageDict.msgType isEqualToString:@"group_image"] ||[messageDict.msgType isEqualToString:@"user_image"] ) {
            if ([Utils isBlankString:messageDict.fromUser]) {
                NSString * path =[KOriginalPhotoImagePath stringByAppendingPathComponent:messageDict.content];
                [_photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:path]]];
                
            }
            else
            {
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KIMAGE_DOWNLOAD_ROOT_PATH, messageDict.content]];
                [_photos addObject:[MWPhoto photoWithURL:url]];
            }
            [_photoMapArray addObject:[NSString stringWithFormat:@"%@%@",messageDict.content , messageDict.rectime]];
        }
      }
}
#pragma mark  ------切换到 语音----------
-(void)changeToContext
{
    
    [self.changeTocontextBtn setHidden:YES];
    [self.changeToVoiceBtn setHidden:NO];
    [self.voiceBtn setHidden:YES];
    [self.contextTextView setHidden:NO];
    [self.smiliesBtn setHidden:NO];
    [self.contextTextView becomeFirstResponder];
}

-(void)changeToVoice
{
    
    [self.changeTocontextBtn setHidden:NO];
    [self.changeToVoiceBtn setHidden:YES];
    [self.voiceBtn setHidden:NO];
    [self.contextTextView setHidden:YES];
    [self.smiliesBtn setHidden:YES];
    [self.contextTextView resignFirstResponder];
    [self.faceBoard resignFirstResponder];
}

-(void)sendVoice:(NSString *)sender
{
    
    
}



#pragma mark - 录音按钮事件
// 按下
- (void)recordBtnDidTouchDown:(UIButton *)recordBtn {
//    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];   
    
    NSString *strUrl =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    _voicefileName = [NSString stringWithFormat:@"%@_%ld", APPDELEGATE.UserID, (long)[[NSDate date] timeIntervalSince1970]];
//    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.wav", strUrl, _voicefileName]];
    NSURL *url = [NSURL URLWithString:[strUrl stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",_voicefileName]]];
    _audioPlayURL = url;
    [self.recordTool startRecording:_audioPlayURL];
    
    [SVProgressHUD showImage:[UIImage imageNamed:@"mic_0"] status:@"正在录音"];
    
//    _hud = [[MBProgressHUD alloc] initWithView:self.view];
//    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mic_0"]];
//    [self.view addSubview:_hud];
//    _hud.mode = MBProgressHUDModeCustomView;
//    _hud.opacity = 0.5;
//    _hud.userInteractionEnabled= NO;
////    _hud.delegate = self;
//    _hud.labelText = @"正在录音";
//    [_hud show:YES];
    
}

// 点击
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
    _currentTime = self.recordTool.recorder.currentTime;
    NSLog(@"%lf", _currentTime);
    if (_currentTime < 1.5) {
//        [_hud removeFromSuperview];
//        [_hud show:NO];
//        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mic_0"]];
//        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"录音时间太短"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
        });
//        ALERT(@"说话时间太短");
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.recordTool stopRecording];
            dispatch_async(dispatch_get_main_queue(), ^{
//                _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mic_0"]];
                [SVProgressHUD dismiss];
            });
        });
    }
}

// 手指从按钮上移除
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
     [SVProgressHUD showImage:[UIImage imageNamed:@"mic_0"] status:@"正在录音"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
        dispatch_async(dispatch_get_main_queue(), ^{
             [SVProgressHUD dismiss];
        });
    });
  
}

#pragma mark - LVRecordToolDelegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no {
    
    NSString *imageName = [NSString stringWithFormat:@"mic_%d", no];
    [SVProgressHUD showImage:[UIImage imageNamed:imageName] status:@"正在录音"];
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {

    if (flag && _currentTime >= 1.5) {
        
        MessageEntity *  textMsg= [[MessageEntity alloc]init];
        textMsg.fromUserName = APPDELEGATE.UserID;
        textMsg.toUserName = _groupId;
        textMsg.content = @"";
        textMsg.voice = [NSString  stringWithFormat:@"%@.amr", _voicefileName];
        if ([_groupType boolValue])
        {
            textMsg.msgType = @"group";
        }
        else
        {
            textMsg.msgType = @"user";
        }
        textMsg.time = [Utils getCurrentTime];
        textMsg.state = [NSNumber numberWithInt:0];
        textMsg.isFromWatch =[NSNumber numberWithInt:2];
        //插入数据库
        [DBHelper inTransaction:^(FMDatabase *db) {
            [DBMessageManager insertArray:[NSMutableArray arrayWithObject:textMsg] FMDatabase:db ResultStat:^(Boolean result) {
                [self reloadListFromDB:db];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dialogueDetailDict.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }];
        }];
      
        NSString * urlStr = [[_audioPlayURL absoluteString] stringByReplacingOccurrencesOfString:@".wav" withString:@".amr"];
        if ([VoiceConverter ConvertWavToAmr:[recorder.url absoluteString] amrSavePath:urlStr]) {
            // 已成功录音
            NSLog(@"已成功录音");
            [self uploadVoice:textMsg];
//            NSString *pathOfurl = [NSString stringWithFormat:@"%@%@", KFILE_ROOT_PATH, KVOICE_UPLOAD_PATH];
//            NSString *fileName = [NSString  stringWithFormat:@"%@.amr", _voicefileName];
//            //        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//            //            NSDictionary *parameters = @{@"uploadedfile":fileName, @"user-name":APPDELEGATE.UserID};
//            [EXHttpHelper uploadFileURL:[NSURL URLWithString:urlStr] parameters:nil  addr:pathOfurl name:@"uploadedfile" fileName:fileName mimeType:@"application/octet-stream" success:^(int resultCode, id responseObject) {
//                //向服务器发送消息
//                [self sendToServer:textMsg];
//                
//            } failure:^(NSError *error) {
//                WDLog(@"文件上传失败");
//                textMsg.state = [NSNumber numberWithInt:-1];
//                [DBHelper inTransaction:^(FMDatabase *db) {
//                    [DBMessageManager updateStateByID:textMsg.messageId Time:textMsg.time State:[NSNumber numberWithInt:-1] FMDatabase:db QueryResult:^(Boolean result) {
//                        [self reloadListFromDB:db];
//                        
//                    }];
//                }];
//            }];
        }
        
    }
}






-(void)smilies
{
    
    if ([self.contextTextView.inputView isEqual:_faceBoard])
    {
        self.contextTextView.inputView = nil;
        [self.contextTextView reloadInputViews];
    }
    else
    {
        _faceBoard.inputTextView = self.contextTextView;
        _faceBoard.inputTextView.delegate = self;
        self.contextTextView.inputView = _faceBoard;
        [self.contextTextView reloadInputViews];
    }
    
    if (![self.contextTextView isFirstResponder])
    {
        [self.contextTextView becomeFirstResponder];
    }
    __block  EXDialogueDetailViewController* weakSelf = self;
    [_faceBoard setBlock:^(BOOL isbaseEmoji, NSString *key) {
        if (isbaseEmoji) {
            weakSelf.contextTextView.text =key;
            [weakSelf textViewDidChange: weakSelf.contextTextView];
        }
        else
        {
            [weakSelf sendTextToSer:key];
        }
    }];
}

-(void)addMedia
{
    
    UIActionSheet* mediaSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];
    
    [mediaSheet addButtonWithTitle :@"拍照"];
    [mediaSheet addButtonWithTitle:@"相册选图"];
    [mediaSheet addButtonWithTitle:@"小视频"];
    [mediaSheet addButtonWithTitle:@"取消"];
    mediaSheet.destructiveButtonIndex=3;
    [mediaSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        ALERT(@"拍照");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = NO;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];//进入照相界面
        
    }else if (buttonIndex == 1) {
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 6;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups = NO;
        picker.delegate = self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }else if(buttonIndex == 2) {
        
        TMVideoPickerViewController *tmvPVCtrl = [[TMVideoPickerViewController alloc] initWithNibName:@"TMVideoPickerViewController" bundle:nil];
        tmvPVCtrl.delegate = self;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:tmvPVCtrl animated:NO];
    
    }else if(buttonIndex == 3) {
//        ALERT(@"取消");
    }
    
}


#pragma mark ---- 视频回调 ---
-(void)didFinishSelectVideoFileName:(NSString *)strVideoPathAndName{
//    [SVProgressHUD showSuccessWithStatus:strVideoPathAndName];
    
    MessageEntity *  textMsg= [[MessageEntity alloc]init];
    textMsg.fromUserName = APPDELEGATE.UserID;
    textMsg.toUserName = _groupId;
    textMsg.content = @"";
    textMsg.video = [strVideoPathAndName lastPathComponent];
    if ([_groupType boolValue])
    {
        textMsg.msgType = @"group";
    }
    else
    {
        textMsg.msgType = @"user";
    }
    textMsg.time = [Utils getCurrentTime];
    textMsg.state = [NSNumber numberWithInt:0];
    textMsg.isFromWatch =[NSNumber numberWithInt:2];
    textMsg.v_width = [NSNumber numberWithInt:640];
    textMsg.v_height = [NSNumber numberWithInt:480];
    //插入数据库
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBMessageManager insertArray:[NSMutableArray arrayWithObject:textMsg] FMDatabase:db ResultStat:^(Boolean result) {
            [self reloadListFromDB:db];
        }];
    }];
    [self uploadVideo:textMsg];
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{

    for (ALAsset *asset in assets ) {
        MessageEntity *textMsg = [[MessageEntity alloc]init];
        textMsg.fromUserName =APPDELEGATE.UserID;
        textMsg.toUserName = _groupId;
//        NSString *url = [[[asset defaultRepresentation]url] absoluteString];
    
        NSString *nameOfImage = [NSString stringWithFormat:@"%@_%ld_%d.png", APPDELEGATE.UserID, (long)[[NSDate date] timeIntervalSince1970], (arc4random()%100)];
        textMsg.content = nameOfImage;
        if ([_groupType boolValue])
        {
            textMsg.msgType = @"group_image";
        }
        else
        {
            textMsg.msgType = @"user_image";
        }
        textMsg.time = [Utils getCurrentTime];
        //消息状态 -1 发送失败  0 正在发送  1 发送成功
        textMsg.state = [NSNumber numberWithInt:0];
        
        
        NSData * data =  UIImageJPEGRepresentation([UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage], 0.3);
        NSString * imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:nameOfImage];
        //                 NSData *data =  UIImageJPEGRepresentation
        [data writeToFile:imagePath atomically:YES];
        
        
        //插入数据库
        [DBHelper inTransaction:^(FMDatabase *db) {
            [DBMessageManager insertArray:[NSMutableArray arrayWithObject:textMsg] FMDatabase:db ResultStat:^(Boolean result) {
                [self reloadListFromDB:db];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dialogueDetailDict.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }];
        }];
        
        [self uploadImage:textMsg];

//        NSString *pathOfurl = [NSString stringWithFormat:@"%@%@", KFILE_ROOT_PATH, KIMAGE_UPLOAD_PATH];
//        //        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//        NSDictionary *parameters = @{@"uploadedfile":textMsg.content, @"user-name":APPDELEGATE.UserID};
//        [EXHttpHelper uploadFileURL:[NSURL URLWithString:[KOriginalPhotoImagePath stringByAppendingPathComponent: textMsg.content]] parameters:parameters  addr:pathOfurl name:@"uploadedfile" fileName:textMsg.content mimeType:@"image/jpeg" success:^(int resultCode, id responseObject) {
//            //向服务器发送消息
//            [self sendToServer:textMsg];
//        } failure:^(NSError *error) {
//            WDLog(@"文件上传失败");
//            textMsg.state = [NSNumber numberWithInt:-1];
//            [DBHelper inTransaction:^(FMDatabase *db) {
//                [DBMessageManager updateStateByID:textMsg.messageId Time:textMsg.time State:[NSNumber numberWithInt:-1] FMDatabase:db QueryResult:^(Boolean result) {
//                    [self reloadListFromDB:db];
//                }];
//            }];
//        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MessageEntity *textMsg = [[MessageEntity alloc]init];
    textMsg.fromUserName =APPDELEGATE.UserID;
    textMsg.toUserName = _groupId;
    //        NSString *url = [[[asset defaultRepresentation]url] absoluteString];
    
    NSString *nameOfImage = [NSString stringWithFormat:@"%@_%ld_%d.png", APPDELEGATE.UserID, (long)[[NSDate date] timeIntervalSince1970], (arc4random()%100)];
    textMsg.content = nameOfImage;
    if ([_groupType boolValue])
    {
        textMsg.msgType = @"group_image";
    }
    else
    {
        textMsg.msgType = @"user_image";
    }
    textMsg.time = [Utils getCurrentTime];
    //消息状态 -1 发送失败  0 正在发送  1 发送成功
    textMsg.state = [NSNumber numberWithInt:0];
    
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSData * data =  UIImageJPEGRepresentation(image, 0.3);
    NSString * imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:nameOfImage];
    [data writeToFile:imagePath atomically:YES];

    //插入数据库
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBMessageManager insertArray:[NSMutableArray arrayWithObject:textMsg] FMDatabase:db ResultStat:^(Boolean result) {
            [self reloadListFromDB:db];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dialogueDetailDict.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }];
    }];
     [self uploadImage:textMsg];
//    NSString *pathOfurl = [NSString stringWithFormat:@"%@%@", KFILE_ROOT_PATH, KIMAGE_UPLOAD_PATH];
//    //        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
//    NSDictionary *parameters = @{@"uploadedfile":textMsg.content, @"user-name":APPDELEGATE.UserID};
//    [EXHttpHelper uploadFileURL:[NSURL URLWithString:[KOriginalPhotoImagePath stringByAppendingPathComponent: textMsg.content]] parameters:parameters  addr:pathOfurl name:@"uploadedfile" fileName:textMsg.content mimeType:@"image/jpeg" success:^(int resultCode, id responseObject) {
//        //向服务器发送消息
//        [self sendToServer:textMsg];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"上传失败"];
//        textMsg.state = [NSNumber numberWithInt:-1];
//        [DBHelper inTransaction:^(FMDatabase *db) {
//            [DBMessageManager updateStateByID:textMsg.messageId Time:textMsg.time State:[NSNumber numberWithInt:-1] FMDatabase:db QueryResult:^(Boolean result) {
//                [self reloadListFromDB:db];
//                
//            }];
//        }];
//
//    }];
}
//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
      [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma  mark ------发送文本消息-------
-(void)sendMsg
{
    _isSendBtnClicked = YES;
    [self sendTextToSer:_contextTextView.text];
    _contextTextView.text=@"";
    [self textViewDidChange:_contextTextView];
    [_addMediaBtn setHidden:NO];
    [_sendBtn setHidden:YES];
}

-(void)sendTextToSer:(NSString*)text
{
    
    MessageEntity *textMsg = [[MessageEntity alloc]init];
    textMsg.fromUserName =APPDELEGATE.UserID;
    textMsg.toUserName = _groupId;
    textMsg.content = text;
    if ([_groupType boolValue])
    {
        textMsg.msgType = @"group";
    }
    else
    {
        textMsg.msgType = @"user";
    }
    textMsg.time = [Utils getCurrentTime];
    //消息状态 -1 发送失败  0 正在发送  1 发送成功
    textMsg.state = [NSNumber numberWithInt:0];
    //插入数据库
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBMessageManager insertArray:[NSMutableArray arrayWithObject:textMsg] FMDatabase:db ResultStat:^(Boolean result) {
            [self reloadListFromDB:db];
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dialogueDetailDict.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }];
    }];
    
    [self sendTextToServer:textMsg];
    
}
-(void)updateViewConstraints
{
     //设置背景约束
    [self.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 55.0f+100)];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-100];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    
    // 设置调出键盘 约束
    [self.changeTocontextBtn autoSetDimensionsToSize:CGSizeMake(29, 29)];
    [self.changeTocontextBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [self.changeTocontextBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
    // 设置调出语音按钮 约束
    [self.changeToVoiceBtn autoSetDimensionsToSize:CGSizeMake(29, 29)];
    [self.changeToVoiceBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [self.changeToVoiceBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
    //语音 按钮
    [self.voiceBtn autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH-(29+29+10+10+10+10), 35)];
    [self.voiceBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.voiceBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.changeToVoiceBtn withOffset:10];
    
    
    //输入框
    [self.contextTextView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH-(29+29+10+10+10+10+29+10), 35)];
    [self.contextTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.contextTextView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.changeToVoiceBtn withOffset:10];
//     [self.contextTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
//    [self.contextTextView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.smiliesBtn withOffset:-10];
    
    // 设置表情 约束
    [self.smiliesBtn autoSetDimensionsToSize:CGSizeMake(29, 29)]; [self.smiliesBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [self.smiliesBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.addMediaBtn withOffset:-10];
    
    // 设置发送按钮 约束
    [self.sendBtn autoSetDimensionsToSize:CGSizeMake(29, 29)];
    [self.sendBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [self.sendBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    
    // 设置调出添加按钮 约束
    [self.addMediaBtn autoSetDimensionsToSize:CGSizeMake(29, 29)];
    [self.addMediaBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [self.addMediaBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    
    [super updateViewConstraints];
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHight = keyboardRect.size.height;
    //计算键盘偏移量
    float offset = self.view.frame.size.height -(self.bottomView.frame.origin.y + self.bottomView.frame.size.height-100+_totalChangedHight +_keyboardHight);
    if (offset <=0) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = self.view.frame;
        frame.origin.y = -_totalChangedHight;
        self.view.frame = frame;
    }];
}
- (void)keyboardWillHideRecognizer
{
   
    [_contextTextView resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_contextTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark ------开始 重写方法 ---------

#pragma mark ---- 键盘相关 -----


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//设置最大输入内容
//    NSInteger maxLineNum = 4;
//    NSString *textString = @"Text";
//    CGSize fontSize = [textString sizeWithAttributes:@{NSFontAttributeName:textView.font}];
//    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    CGSize tallerSize = CGSizeMake(textView.frame.size.width-15,textView.frame.size.height*2);
//    CGSize newSize = [newText boundingRectWithSize:tallerSize
//                                           options:NSStringDrawingUsesLineFragmentOrigin
//                                        attributes:@{NSFontAttributeName: textView.font}
//                                           context:nil].size;
//    NSInteger newLineNum = newSize.height / fontSize.height;
//    if ([text isEqualToString:@"\n"]) {
//        newLineNum += 1;
//    }
//    
//    if ((newLineNum <= maxLineNum)&& newSize.width < textView.frame.size.width-15)
//    {
//        return YES;
//    }else{
//        return NO;
//    }
    
    if ([text isEqualToString:@"\n"]) {
        
//        [SVProgressHUD showWithStatus:@"return"];
//        [self sendTextToSer:textView.text];
        [self sendMsg];
        return NO;
    }
    return  YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (![Utils isBlankString:textView.text]) {
        [self.addMediaBtn setHidden:YES];
        [self.sendBtn setHidden:NO];
    }
//    else
//    {
//        if (_isSendBtnClicked) {
//            _isSendBtnClicked = !_isSendBtnClicked;
//            CGSize fontSize = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
//            CGRect viewFrame =  self.view.frame;
//            viewFrame.origin.y -=  (2 - _lastLineNum) * fontSize.height-10;
//            self.view.frame = viewFrame;
//            CGRect textFrame =  self.contextTextView.frame;
//            textFrame.size.height += (2 - _lastLineNum ) * fontSize.height-10;
//            self.contextTextView.frame = textFrame;
//            _totalChangedHight += (2 - _lastLineNum) * fontSize.height-10;
//        }
//    }
   
//    if (textView.text.length == 0) {
//        _totalChangedHight = 0;
//        _changedHight = 0;
//        _lastInputHight = 0;
//        [self.addMediaBtn setHidden:NO];
//        [self.sendBtn setHidden:YES];
//    }
//    else
//    {
//        [self.addMediaBtn setHidden:YES];
//        [self.sendBtn setHidden:NO];
//
//    }
//    if (textView.contentSize.height <100) {
//        
//        if (_lastInputHight != textView.contentSize.height ) {
//            _changedHight = textView.contentSize.height - _lastInputHight;
//            _totalChangedHight +=_changedHight;
//            
//            if (textView.contentSize.height > 35) {
//                CGRect viewFrame =  self.view.frame;
//                viewFrame.origin.y -=_changedHight;
//                self.view.frame = viewFrame;
//                CGRect textFrame =  self.contextTextView.frame;
//                textFrame.size.height += _changedHight;
//                self.contextTextView.frame = textFrame;
//            }
//            
//        }
//        
//    }
    NSInteger maxLineNum = 4;
    CGSize fontSize = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    CGSize tallerSize = CGSizeMake(textView.frame.size.width-10,textView.frame.size.height*1.2);
    CGSize newSize = [textView.text boundingRectWithSize:tallerSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: textView.font}
                                           context:nil].size;
    NSInteger newLineNum = newSize.height / fontSize.height;
    
//    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%ld", (long)newLineNum]];
    if ((newLineNum <= maxLineNum)&& newSize.width < textView.frame.size.width-10 )
    {
        if (newLineNum == 1) {
            if(_lastLineNum > 1 )
            {
                CGRect textFrame =  self.contextTextView.frame;
                if ((textFrame.size.height + (newLineNum - _lastLineNum ) * fontSize.height) >25) {
                    CGRect viewFrame =  self.view.frame;
                    viewFrame.origin.y -=  (1 - _lastLineNum) * fontSize.height;
                    self.view.frame = viewFrame;
                    
                    textFrame.size.height += (1 - _lastLineNum) * fontSize.height;
                    self.contextTextView.frame = textFrame;
                    _totalChangedHight += (1 - _lastLineNum) * fontSize.height;
                }
                else
                {
                    CGRect viewFrame =  self.view.frame;
                    viewFrame.origin.y -=  35 - _lastLineNum * fontSize.height;
                    self.view.frame = viewFrame;
                    
                    textFrame.size.height += 35 - _lastLineNum * fontSize.height;
                    self.contextTextView.frame = textFrame;
                    _totalChangedHight += 35 - _lastLineNum * fontSize.height;
                }
                
            }
        }
        else
        {
            CGRect viewFrame =  self.view.frame;
            viewFrame.origin.y -=  (newLineNum - _lastLineNum) * fontSize.height;
            self.view.frame = viewFrame;
            CGRect textFrame =  self.contextTextView.frame;
            textFrame.size.height += (newLineNum - _lastLineNum ) * fontSize.height;
            self.contextTextView.frame = textFrame;
            _totalChangedHight += (newLineNum - _lastLineNum) * fontSize.height;

        }
        
    }else{
        // 是否还进行其他操作待定
        
    }
    _lastLineNum = newLineNum;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_dialogueDetailDict count];
}

#pragma mark  ===计算每个cell高度====
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     *  计算cell的高度
     */
    MessageEntity *messageDict = [_dialogueDetailDict objectAtIndex:indexPath.row];
    if([messageDict.msgType hasPrefix:@"user"] || [messageDict.msgType isEqualToString:@"group"]|| [messageDict.msgType isEqualToString:@"group_image"]) //聊天消息
    {
        //计算时间看是否需要显示时间
      
       return  [self computeCellHight:messageDict];
        
    }
    else //系统消息
    {
         return kCellHight_top + kCellHight_sysMsg + kCellHight_bottom;
       
    }
}
#pragma mark -------计算cell的实际高度-------
//根据条件计算 实际的cell高度
-(float) computeCellHight:(MessageEntity *)messageDict
{
    float totalHight = kCellHight_top;
    if ([messageDict.isshowtime boolValue]) { //是否显示时间
        totalHight += kCellHight_interval + kCellHight_time;
    }
    //是群组且开启显示群成员选项  并且 不是自己发得消息 则显示名称
    if (_isShowName && [messageDict.msgType hasPrefix:@"group"]) {
        if (![Utils isBlankString:messageDict.fromUser]) { // 接受消息标志
            totalHight += kCellHight_interval + kCellHight_name;
        }
    }
//    totalHight += [self computeContentSize:messageDict].height; //计算内容的高度
    if ( [self computeContentSize:messageDict].height < kCellHight_logo) {
        totalHight += kCellHight_interval + kCellHight_logo  ;
        
    }
    else
    {
        totalHight += kCellHight_interval + [self computeContentSize:messageDict].height+12 ;
        
    }
    return totalHight + kCellHight_bottom;
}

#pragma mark -------计算显示内容的实际高度和宽度-------
-(CGSize ) computeContentSize:(MessageEntity *)messageDict
{
    float totalHight;
    float totalWidth;
    //计算显示内容高度
    if (![messageDict.url isEqualToString:@""] && messageDict.url !=nil) {
        //url内容
        totalHight  = 30;
        totalWidth  = kCellHight_logo*3;
    }
    else  if (![messageDict.video isEqualToString:@""] && messageDict.video !=nil) {
        //视频内容
        totalHight  = kCellHight_logo*3;
        totalWidth  = kCellHight_logo*3;
    }
    else  if (![messageDict.voice isEqualToString:@""] && messageDict.voice !=nil) {
        //音频内容
        totalHight  = 30;
    }else  if ([messageDict.msgType isEqualToString:@"group_image"] ||[messageDict.msgType isEqualToString:@"user_image"] ) {
        totalHight  = kCellHight_logo*3; //图片大小
        totalWidth  = kCellHight_logo*3;
    }
    else
    {
        //如果发送过来的直接是个大表情 直接给出高度
        if ([messageDict.content hasPrefix:@"[\\"] &&[messageDict.content hasSuffix:@"]"]) {
            totalHight =  kCellHight_bigEmoji;
            totalWidth =   kCellHight_bigEmoji;
        }
        else
        {
            UIFont *font = [UIFont systemFontOfSize:15];
            CGSize size = CGSizeMake(180.0f,20000.0f); //设置一个行高上限
            NSDictionary *attribute = @{NSFontAttributeName: font};
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:   @"\\[[\\\\w\\u4e00-\\u9fa5\\w]+\\]" options:0 error:nil];
            NSString *str  =[regularExpression stringByReplacingMatchesInString:messageDict.content options:0 range:NSMakeRange(0, messageDict.content.length) withTemplate:@"[M]"];
            CGSize labelsize = [str boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            totalHight  =  labelsize.height+10;
            totalWidth  =  labelsize.width+8;
        }
    }
    CGSize size= CGSizeMake(totalWidth, totalHight);
    return size;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DialogueDetaiId = @"DialogueDetaiId";
    EXDialogueDetailTableViewCell *dialogueDetailTableViewCell = [tableView dequeueReusableCellWithIdentifier:DialogueDetaiId];
    if (dialogueDetailTableViewCell == nil) {
        dialogueDetailTableViewCell = [[EXDialogueDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DialogueDetaiId];
//        dialogueDetailTableViewCell.userInteractionEnabled = NO;
        dialogueDetailTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
 
    
    for (UIView *subviews in [dialogueDetailTableViewCell subviews]) {
            [subviews removeFromSuperview];
    }
    
    MessageEntity *messageDict =[_dialogueDetailDict objectAtIndex:[indexPath row]];
    if([messageDict.msgType hasPrefix:@"user"] || [messageDict.msgType isEqualToString:@"group"]|| [messageDict.msgType isEqualToString:@"group_image"]) //聊天消息
    {
        [dialogueDetailTableViewCell addSubview:[self  DrawCell:messageDict Cell:dialogueDetailTableViewCell  Row:[indexPath row]]];
        _lastTimeOfMessage= messageDict.time;

        
    }
    else //系统消息
    {
        UILabel *sysMsgLB = [UILabel newAutoLayoutView];
        sysMsgLB.font  = [UIFont boldSystemFontOfSize:10];
        sysMsgLB.backgroundColor = UIColorFromRGB(KC8C8C8Color);
        sysMsgLB.textColor  = [UIColor whiteColor];
        sysMsgLB.layer.cornerRadius = 6.0f;
        sysMsgLB.textAlignment = NSTextAlignmentCenter;
        sysMsgLB.clipsToBounds = YES;
        [dialogueDetailTableViewCell addSubview:sysMsgLB];
        
        //设置约束
        [sysMsgLB autoSetDimensionsToSize:CGSizeMake(220, kCellHight_sysMsg)];
        [sysMsgLB autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCellHight_top];
        [sysMsgLB autoAlignAxisToSuperviewAxis:ALAxisVertical];
        NSString * textMsg = [[NSString alloc]init];
        
        if ([messageDict.msgType hasPrefix:@"group_creat"]) {
            
            ;
        }
        else if ([messageDict.msgType hasPrefix:@"group_add"]) {
            if(![messageDict.fromUserName isEqualToString:APPDELEGATE.UserID])
            {
                textMsg = [textMsg stringByAppendingString:messageDict.nickName];
            }
            textMsg = [textMsg stringByAppendingString:[NSString stringWithFormat:@"邀请%@加入了群聊", messageDict.content]];
        }
        else if ([messageDict.msgType hasPrefix:@"group_remove"]) {
        
            textMsg = [NSString stringWithFormat:@"%@被请出了群聊", messageDict.content];
        }
        else if ([messageDict.msgType hasPrefix:@"group_quit"]) {
            textMsg = [NSString stringWithFormat:@"%@退出了群聊", messageDict.content];
        }
        sysMsgLB.text = textMsg;
    }
  
       return  dialogueDetailTableViewCell;
}


#pragma  mark ------ 绘制cell内容 -----
-(UIView *)DrawCell:(MessageEntity *)messageDict  Cell:(EXDialogueDetailTableViewCell *)cell   Row:(NSInteger ) row
{
  
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self computeCellHight:messageDict])];
    if ([messageDict.isshowtime boolValue]) { //是否显示时间
       cell.timeLB = [UILabel newAutoLayoutView];
       cell.timeLB.font  = [UIFont boldSystemFontOfSize:10];
       cell.timeLB.backgroundColor = UIColorFromRGB(KC8C8C8Color);
       cell.timeLB.textColor  = [UIColor whiteColor];
       cell.timeLB.layer.cornerRadius = 8.0f;
       cell.timeLB.textAlignment = NSTextAlignmentCenter;
       cell.timeLB.clipsToBounds = YES;
       [view addSubview:cell.timeLB];
        //设置约束
        [cell.timeLB autoSetDimensionsToSize:CGSizeMake(120, kCellHight_time)];
        [cell.timeLB autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCellHight_top];
        [cell.timeLB autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        cell.timeLB.text = [Utils format:[NSString stringWithFormat:@"%@",messageDict.rectime]];//设置内容
        
    }
    if (_isShowName && [messageDict.msgType hasPrefix:@"group"]) {
        if (![Utils isBlankString:messageDict.fromUser]) { //接受标志
            cell.labelName = [UILabel newAutoLayoutView];
            cell.labelName.font  = [UIFont boldSystemFontOfSize:10];
            cell.labelName.textColor  = UIColorFromRGB(K595555Color);
            cell.labelName.layer.cornerRadius = 5.0f;
            cell.labelName.textAlignment = NSTextAlignmentLeft;
            cell.labelName.clipsToBounds = YES;
            [view addSubview: cell.labelName];
            
            for (NSLayoutConstraint *constraint in cell.labelName.constraints) {
                if ([constraint isEqual:constraint]) {
                    [cell.labelName removeConstraint:constraint];
                }
            }
            
            
            //设置约束
            [ cell.labelName autoSetDimensionsToSize:CGSizeMake(120, kCellHight_name)];
            if ([messageDict.isshowtime boolValue]) { //如果时间显示了。那么名字应该添加到时间下方
                [cell.labelName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView: cell.timeLB withOffset:kCellHight_top];
            }
            else //无时间， 名字直接置顶
            {
                [cell.labelName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCellHight_top];
            }
            [cell.labelName autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kCellHight_top+22+kCellHight_logo];
             cell.labelName.text = messageDict.nickName;
        }
    }
    
    return  [self DrawCellContent:messageDict  Cell:cell view:view   Row:row];//绘制内容
}

-(UIView *)DrawCellContent:(MessageEntity *)messageDict  Cell:(EXDialogueDetailTableViewCell *)cell view:(UIView *)view  Row:(NSInteger ) row
{
    //定义 头像
    cell.imageLogo = [UIImageView newAutoLayoutView];
    cell.imageLogo.contentMode =UIViewContentModeScaleAspectFit;
    cell.imageLogo.layer.borderWidth = 1.0f;
    cell.imageLogo.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.imageLogo.layer.cornerRadius = 20;
    cell.imageLogo.clipsToBounds = YES;
    [view addSubview: cell.imageLogo];
    //定义背景
    cell.imageBg = [UIImageView newAutoLayoutView];
    [view addSubview:cell.imageBg];
    
    //定义文本显示内容
    cell.emojiLabel = [MLEmojiLabel newAutoLayoutView];
    [view addSubview:cell.emojiLabel];
    
    //内容大小约束
    [cell.imageLogo autoSetDimensionsToSize:CGSizeMake(kCellHight_logo, kCellHight_logo)];
    
     cell.fSVoiceBubble = [FSVoiceBubble newAutoLayoutView];
     [view addSubview:cell.fSVoiceBubble];
     [cell.fSVoiceBubble autoSetDimensionsToSize:CGSizeMake(120, 40)];

   
    
    //以下是上下约束
    if ([messageDict.isshowtime boolValue]) { //显示时间
        if (_isShowName && ![Utils isBlankString:messageDict.fromUser] && [messageDict.msgType hasPrefix:@"group"]) {//名称 时间都显示 ，按时间约束
            [cell.imageLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.labelName withOffset:kCellHight_interval];
            [cell.imageBg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.labelName withOffset:kCellHight_interval];
            [cell.fSVoiceBubble autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.labelName withOffset:kCellHight_interval];
            
        }
        else{//名称不显示，按时间约束
            [cell.imageLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.timeLB withOffset:kCellHight_interval];
            [cell.imageBg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.timeLB withOffset:kCellHight_interval];
            [cell.fSVoiceBubble autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.timeLB withOffset:kCellHight_interval];
        }
    }
    else
    {
        if (_isShowName && ![Utils isBlankString:messageDict.fromUser] && [messageDict.msgType hasPrefix:@"group"]) {//时间不显示，按名称约束
            [cell.imageLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.labelName withOffset:kCellHight_interval];
            [cell.imageBg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.labelName withOffset:kCellHight_interval];
            [cell.fSVoiceBubble autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.labelName withOffset:kCellHight_interval];
        }
        else{ //时间和名称都不显示 ，直接置顶约束
            [cell.imageLogo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCellHight_interval+kCellHight_top];
            [cell.imageBg autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCellHight_interval+kCellHight_top];
            [cell.fSVoiceBubble autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kCellHight_interval+kCellHight_top];
        }
    }
   
    
    
    CGFloat top = 30; // 顶端盖高度
    CGFloat bottom = 30 ; // 底端盖高度
    CGFloat left = 30; // 左端盖宽度
    CGFloat right = 30; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    //以下是左右约束
    if ([Utils isBlankString:messageDict.fromUser]) //发送的消息
    {
        [cell.imageLogo autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kCellHight_interval*2];
        [cell.imageBg autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:cell.imageLogo withOffset:-kCellHight_interval];
         //开始添加内容
        //背影图片
        UIImage *bubble = [UIImage imageNamed:@"chatto_bg_focused.png"];
        [cell.imageBg setImage:[bubble resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch]];//气泡样式
//        [cell.imageBg addSubview:bubbleImageView];//气泡样式
        [cell.imageLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KLOGO_ROOT_PATH,APPDELEGATE.userInfo.Avatar]]];

         [cell.fSVoiceBubble autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:cell.imageLogo withOffset:-kCellHight_interval];
        
        [cell.emojiLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.imageBg withOffset:kCellHight_interval*2];
        [cell.emojiLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.imageBg withOffset:kCellHight_interval*2+2];
        
    }
    else //收到的消息
    {
        [cell.imageLogo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kCellHight_interval+2];
        [cell.imageBg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageLogo withOffset:kCellHight_interval];
        
        //开始添加内容
        //背影图片
        UIImage *bubble = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
       [cell.imageBg setImage:[bubble resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch]];//气泡样式
       [cell.imageLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KLOGO_ROOT_PATH, messageDict.avatar]]];
        
        
        [cell.fSVoiceBubble autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:cell.imageLogo withOffset:kCellHight_interval];
        
        [cell.emojiLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.imageBg withOffset:kCellHight_interval*2];
        [cell.emojiLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.imageBg withOffset:-kCellHight_interval*2+5];
    }

    
    
    
    //根据 显示内容加入view
    if (![messageDict.url isEqualToString:@""] && messageDict.url !=nil) {
        [cell.fSVoiceBubble removeFromSuperview];
    }
    else  if (![Utils isBlankString:messageDict.video]) {
        //视频内容
       [cell.fSVoiceBubble removeFromSuperview];
        for (NSLayoutConstraint *constraint in cell.imageBg.constraints) {
            if ([constraint isEqual:constraint]) {
                [cell.imageBg removeConstraint:constraint];
            }
        }
        float imageWidth =  [messageDict.v_width floatValue]/[messageDict.v_height floatValue]*(kCellHight_logo*3);
        [cell.imageBg autoSetDimensionsToSize:CGSizeMake(imageWidth+27, kCellHight_logo*3+10)];
        NSString *baseUrl =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *strUrl = [baseUrl stringByAppendingPathComponent:messageDict.video];
        
        if([Utils isBlankString:messageDict.fromUser])
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, imageWidth, kCellHight_logo*3)];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *folderPath = [path stringByAppendingPathComponent:@"videos"];
            NSString *strImgFileName = [[folderPath stringByAppendingPathComponent:@"captureImage"] stringByAppendingPathComponent:messageDict.video];
            NSString * urlStr = [strImgFileName stringByReplacingOccurrencesOfString:@".mp4" withString:@".png"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if([fileManager fileExistsAtPath:urlStr])
            {
                NSLog(@"文件存在");
                UIImage *image = [UIImage imageWithContentsOfFile:urlStr];
                [imageView setImage:image];

            }
            else
            {
               UIImage *image = [Utils getImage:[folderPath stringByAppendingPathComponent:messageDict.video]];
                [imageView setImage:image];
            }
            [cell.imageBg addSubview:imageView];
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake((imageWidth-36)/2+5, (kCellHight_logo*3-36)/2+5, 36, 36)];
            [imageView1 setImage:[UIImage imageNamed:@"video"]];
            [cell.imageBg addSubview:imageView1];
        }
        else
        {
            //视频URL
            NSURL *url = [NSURL fileURLWithPath:strUrl];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 5, imageWidth, kCellHight_logo*3)];
            NSString * urlStr = [NSString stringWithFormat:@"%@%@&filename=%@", KVIDEOIMAGE_DOWNLOAD_ROOT_PATH,messageDict.fromUserName,messageDict.video];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
            [imageView setImageWithURL:[NSURL URLWithString:urlStr]];
            [cell.imageBg addSubview:imageView];
            UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake((imageWidth-36)/2+22, (kCellHight_logo*3-36)/2+5, 36, 36)];
            [imageView1 setImage:[UIImage imageNamed:@"video"]];
            [cell.imageBg addSubview:imageView1];
            
            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            [EXHttpHelper downloadFileURL:[NSString stringWithFormat:@"%@%@&filename=%@", KVIDEO_DOWNLOAD_ROOT_PATH,messageDict.fromUserName,messageDict.video] savePath:cacheDir fileName:messageDict.video success:^(int resultCode, id responseObject) {
                //视频播放对象
                
            } failure:^(NSError *error) {
                WDLog(@"文件下载出错");
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (url) {
                    [fileManager removeItemAtURL:url error:NULL];
                }
            }];
        }
       
        
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(playVideo:)];
        cell.imageBg.tag = row;
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [cell.imageBg setUserInteractionEnabled:YES];
        [cell.imageBg addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(playVideo:)];
        cell.imageBg.tag = row;
        tap2.numberOfTouchesRequired = 1;
        tap2.numberOfTapsRequired = 2;
        [cell.imageBg setUserInteractionEnabled:YES];
        [cell.imageBg addGestureRecognizer:tap2];
        [tap requireGestureRecognizerToFail:tap2];
    }
    else  if (![messageDict.voice isEqualToString:@""] && messageDict.voice !=nil) {
        //音频内容
       
        [cell.imageBg removeFromSuperview];

        if ([messageDict.fromUser isEqualToString:@""] || messageDict.fromUser ==nil) {
            NSString *baseUrl =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSString *  newName = [messageDict.voice stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
            NSString *strUrl =[baseUrl stringByAppendingPathComponent:newName];
            
            cell.fSVoiceBubble.contentURL =[NSURL fileURLWithPath:strUrl];
            cell.fSVoiceBubble.invert = YES;
            cell.fSVoiceBubble.tag = row;
            if (row == _currentRow) {
                [cell.fSVoiceBubble startAnimating];
            } else {
                [cell.fSVoiceBubble stopAnimating];
            }
            
        }
        else
        {
            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            [EXHttpHelper downloadFileURL:[NSString stringWithFormat:@"%@%@", KVOICE_DOWNLOAD_ROOT_PATH,messageDict.voice] savePath:cacheDir fileName:messageDict.voice success:^(int resultCode, id responseObject) {
                
                NSString *strUrl = [responseObject stringByReplacingOccurrencesOfString:@".amr" withString:@".wav"];
                if ([VoiceConverter ConvertAmrToWav:responseObject wavSavePath:[NSString stringWithFormat:strUrl,cacheDir,messageDict.voice]]) {
                    NSURL *url = [NSURL fileURLWithPath:strUrl];
                    cell.fSVoiceBubble.contentURL =url ;
                     cell.fSVoiceBubble.invert = NO;
                    cell.fSVoiceBubble.tag = row;
                    if (row == _currentRow) {
                        [cell.fSVoiceBubble startAnimating];
                    } else {
                        [cell.fSVoiceBubble stopAnimating];
                    }
                }
            } failure:^(NSError *error) {
                WDLog(@"文件下载出错");
            }];
  
        }
        
        
        
    }else  if ([messageDict.msgType isEqualToString:@"group_image"] ||[messageDict.msgType isEqualToString:@"user_image"] ) {
        [cell.fSVoiceBubble removeFromSuperview];
        [cell.emojiLabel removeFromSuperview];
        
        
        
        if ([messageDict.fromUser isEqualToString:@""] || messageDict.fromUser ==nil) {
            cell.imageContent = [UIImageView newAutoLayoutView];
            cell.imageContent.layer.masksToBounds = YES;
            cell.imageContent.layer.cornerRadius = 5.0;
            
            [cell.imageContent autoSetDimensionsToSize:CGSizeMake(kCellHight_logo*3, kCellHight_logo*3)];
            [cell.imageBg autoSetDimensionsToSize:CGSizeMake(kCellHight_logo*3+27, kCellHight_logo*3+8)];
            [view addSubview:cell.imageContent];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString * path =[KOriginalPhotoImagePath stringByAppendingPathComponent:messageDict.content];
//                [_photos addObject:[MWPhoto photoWithURL:[NSURL fileURLWithPath:path]]];
                UIImage *image=[UIImage imageWithContentsOfFile:path];
                UIImage *imagethumb = [Utils image:image fitInSize:CGSizeMake(0, kCellHight_logo*3)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    for (NSLayoutConstraint *constraint in cell.imageContent.constraints) {
                        if ([constraint isEqual:constraint]) {
                            [cell.imageContent removeConstraint:constraint];
                        }
                    }
                    for (NSLayoutConstraint *constraint in cell.imageBg.constraints) {
                        if ([constraint isEqual:constraint]) {
                            [cell.imageBg removeConstraint:constraint];
                        }
                    }

                    if (image != nil) {
                        float imageWidth =  image.size.width/image.size.height*(kCellHight_logo*3);
                        [cell.imageContent autoSetDimensionsToSize:CGSizeMake(imageWidth, kCellHight_logo*3)];
                        [cell.imageBg autoSetDimensionsToSize:CGSizeMake(imageWidth+27, kCellHight_logo*3+10)];
                        [cell.imageContent autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.imageBg withOffset:kCellHight_interval+2];
                        [cell.imageContent autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.imageBg withOffset:kCellHight_interval+2];
                        [cell.imageContent setImage:imagethumb];
                    }
                    
                });
            });
           
            
            
//            UIImage *image = [UIImage imageWithContentsOfFile:messageDict.content];
//            float imageWidth =  image.size.width/image.size.height*(kCellHight_logo*3);
//            
//            [cell.imageContent autoSetDimensionsToSize:CGSizeMake(imageWidth, kCellHight_logo*3)];
//            [cell.imageBg autoSetDimensionsToSize:CGSizeMake(imageWidth+27, kCellHight_logo*3+8)];
//            [cell.imageContent autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.imageBg withOffset:kCellHight_interval*2];
//            [view addSubview:cell.imageContent];
            
        }
        else
        {
            //图片内容
            cell.imageContent = [UIImageView newAutoLayoutView];
            cell.imageContent.layer.masksToBounds = YES;
            cell.imageContent.layer.cornerRadius = 5.0;
            
            [view addSubview:cell.imageContent];
            [cell.imageContent autoSetDimensionsToSize:CGSizeMake(kCellHight_logo*3, kCellHight_logo*3)];
            [cell.imageBg autoSetDimensionsToSize:CGSizeMake(kCellHight_logo*3+27, kCellHight_logo*3+8)];
//            [cell.imageContent autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.imageBg withOffset:kCellHight_interval*2];
//            [cell.imageContent autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.imageBg withOffset:-kCellHight_interval];
            
            
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KIMAGE_DOWNLOAD_ROOT_PATH, messageDict.content]];
//            if ([messageDict.content hasPrefix:APPDELEGATE.UserID]) {
//                url = [NSURL URLWithString:[KOriginalPhotoImagePath stringByAppendingPathComponent:messageDict.content]];
//            }
//            [_photos addObject:[MWPhoto photoWithURL:url]];
            [cell.imageContent sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image == nil) {
                    return ;
                }
                float imageWidth =  image.size.width/image.size.height*(kCellHight_logo*3);
                for (NSLayoutConstraint *constraint in cell.imageContent.constraints) {
                    if ([constraint isEqual:constraint]) {
                        [cell.imageContent removeConstraint:constraint];
                    }
                }
                for (NSLayoutConstraint *constraint in cell.imageBg.constraints) {
                    if ([constraint isEqual:constraint]) {
                        [cell.imageBg removeConstraint:constraint];
                    }
                }
                [cell.imageContent autoSetDimensionsToSize:CGSizeMake(imageWidth, kCellHight_logo*3)];
                [cell.imageBg autoSetDimensionsToSize:CGSizeMake(imageWidth+27, kCellHight_logo*3+12)];
                [cell.imageContent autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:cell.imageBg withOffset:-kCellHight_interval-1];
                [cell.imageContent autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:cell.imageBg withOffset:kCellHight_interval+2];
            }];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(startBrowser:)];
        cell.imageContent.tag = [_photoMapArray indexOfObject:[NSString stringWithFormat:@"%@%@",messageDict.content , messageDict.rectime]];
        [cell.imageContent setUserInteractionEnabled:YES];
        [cell.imageContent addGestureRecognizer:tap];
        
    }
    else
    {
        [cell.fSVoiceBubble removeFromSuperview];
        CGSize size =[self computeContentSize:messageDict];
        [cell.imageBg autoSetDimensionsToSize:CGSizeMake(size.width+28, size.height+kCellHight_interval*4)];
        [cell.emojiLabel autoSetDimensionsToSize:[self computeContentSize:messageDict]];
        
        //如果发送过来的直接是个大表情 直接给出高度
        if ([messageDict.content hasPrefix:@"[\\"] &&[messageDict.content hasSuffix:@"]"]) {
            if ([messageDict.content hasPrefix:@"[\\"]) {
                
                if ([messageDict.content hasPrefix:@"[\\小璇_"]) {
                   cell.emojiLabel.customEmojiPlistName = @"xiaoxuanemoji";
                }
                else if ([messageDict.content hasPrefix:@"[\\小凯_"]) {
                    cell.emojiLabel.customEmojiPlistName = @"wangkaiemoji";
                }
                else
                {
                    cell.emojiLabel.customEmojiPlistName = @"laowangemoji";
                }
                
                cell.emojiLabel.numberOfLines = 0;
                cell.emojiLabel.font = [UIFont systemFontOfSize:50.0f];
                cell.emojiLabel.delegate = self;
                cell.emojiLabel.textAlignment = NSTextAlignmentLeft;
                cell.emojiLabel.backgroundColor = [UIColor clearColor];
                //emojiLabel.isNeedAtAndPoundSign = YES;
                cell.emojiLabel.customEmojiBundleName = nil;
                cell.emojiLabel.customEmojiRegex = @"\\[[\\\\w\\u4e00-\\u9fa5\\w]+\\]";
                //emojiLabel.disableThreeCommon = YES;
                //emojiLabel.disableEmoji = YES;
                cell.emojiLabel.text = messageDict.content;
            }
        }
        else
        {
            cell.emojiLabel.numberOfLines = 0;
            cell.emojiLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.emojiLabel.delegate = self;
            cell.emojiLabel.textAlignment = NSTextAlignmentLeft;
            cell.emojiLabel.backgroundColor = [UIColor clearColor];
           
            cell.emojiLabel.customEmojiPlistName = @"emoji";
            cell.emojiLabel.customEmojiBundleName = nil;
            cell.emojiLabel.customEmojiRegex = @"\\[[\\\\w\\u4e00-\\u9fa5\\w]+\\]";
            cell.emojiLabel.disableThreeCommon = NO;
//            cell.emojiLabel.disableEmoji = YES;
//            cell.emojiLabel.isNeedAtAndPoundSign = YES;
            cell.emojiLabel.text = messageDict.content;
            
         
            //这句测试剪切板
//            [_emojiLabel performSelector:@selector(copy:) withObject:nil afterDelay:0.01f];
        }
    }
    if ([Utils isBlankString:messageDict.fromUser]) {
        
        
        cell.sendStateView =[UIView newAutoLayoutView];
        [view addSubview:cell.sendStateView];
        [cell.sendStateView autoSetDimensionsToSize:CGSizeMake(20, 20)];
        if (![Utils isBlankString:messageDict.voice]) {
            [cell.sendStateView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:cell.fSVoiceBubble withOffset:-kCellHight_interval-20];
            
        }
        else
        {
            [cell.sendStateView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:cell.imageBg withOffset:-kCellHight_interval-20];
            
        }
       [cell.sendStateView autoPinEdgeToSuperviewEdge:ALEdgeTop  withInset:[self computeCellHight:messageDict]/2-10];
        
        if([messageDict.state intValue] == 0)
        {
            long long  timeInt =[[NSDate date] timeIntervalSince1970]*1000;
            if (timeInt -[messageDict.rectime longLongValue] >1000*1) {
                //未发送消息，可以重新发送
                UIButton *sendErrorView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                [sendErrorView setImage:ImageNamed(@"alert.png") forState:UIControlStateNormal];
                sendErrorView.tag = row;
                [sendErrorView addTarget:self action:@selector(reSendMsgAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.sendStateView addSubview:sendErrorView];
            }
            else
            {
                //发送消息时的状态标识
                UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
                [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮
                [cell.sendStateView addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
            }
           
        }
        if([messageDict.state intValue] == -1)
        {
            //未发送消息，可以重新发送
            UIButton *sendErrorView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [sendErrorView setImage:ImageNamed(@"alert.png") forState:UIControlStateNormal];
            sendErrorView.tag = row;
            [sendErrorView addTarget:self action:@selector(reSendMsgAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.sendStateView addSubview:sendErrorView];
        }
    }
    _didSetupConstraints = YES;
    return view;
}

-(void)startBrowser:(UITapGestureRecognizer*)tapGestureRecognizer
{
   
//   NSString *  tapGestureRecognizer.view.tag
//    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%d",tapGestureRecognizer.view.tag]];
    [_browser setCurrentPhotoIndex:tapGestureRecognizer.view.tag];
    // Present
    [self.navigationController pushViewController:_browser animated:YES];
}
-(void)playVideo:(UITapGestureRecognizer*)tapGestureRecognizer
{
    
// [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%d",tapGestureRecognizer.view.tag]];
   
   MessageEntity * messageDict = [_dialogueDetailDict objectAtIndex:tapGestureRecognizer.view.tag];
    NSString *baseUrl =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *strUrl = [baseUrl stringByAppendingPathComponent:messageDict.video];
    float imageWidth =  [messageDict.v_width floatValue]/[messageDict.v_height floatValue]*(kCellHight_logo*3);
    _movie = [[MPMoviePlayerController alloc] init];
    _movie.backgroundView.backgroundColor = [UIColor clearColor];
    _movie.view.backgroundColor = [UIColor clearColor];
    _movie.controlStyle = MPMovieControlStyleNone;
    
    
    if([Utils isBlankString:messageDict.fromUser])
    {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *folderPath = [path stringByAppendingPathComponent:@"videos"];
        strUrl =  [folderPath stringByAppendingPathComponent:messageDict.video];
        [_movie.view setFrame:CGRectMake(5, 6, imageWidth, kCellHight_logo*3)];
    }
    else
    {
        [_movie.view setFrame:CGRectMake(22, 3, imageWidth, kCellHight_logo*3)];
    }

    //视频URL
    NSURL *url = [NSURL fileURLWithPath:strUrl];
 
    
    
    if (tapGestureRecognizer.numberOfTapsRequired == 1) {
        NSLog(@"单指单击");
//        [_movie.view setFrame:CGRectMake(22, 3, imageWidth, kCellHight_logo*3)];
        [tapGestureRecognizer.view  addSubview:_movie.view];
    }else if(tapGestureRecognizer.numberOfTapsRequired == 2){
        //单指双击
        NSLog(@"单指双击");
//        [_movie.view setFrame:self.view.frame];
//        [self.view  addSubview:_movie.view];
    }
    [_movie setContentURL:url];
    _movie.shouldAutoplay = YES;
    [_movie prepareToPlay];
     _movie.initialPlaybackTime = -1;
    [_movie play];
}
-(void)moviePlayBackDidFinish:(NSNotification *)aNotification
{
    [_movie.view removeFromSuperview];
}
//是否重新发送消息
#pragma mark -----重新发送消息，点击发送按钮响应事件------

-(void)reSendMsgAction:(id)sender
{
    _reSendMsgRow = ((UIButton*)sender).tag;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否重新发送消息"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"发送",nil];
    alert.tag = 1;
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1:
        {
            if (buttonIndex == 1) {
                [self reSendMessage];
            }
        }
            break;
        default:
            break;
    }
}


-(void) reSendMessage
{
    MessageEntity * messageEntity = [_dialogueDetailDict objectAtIndex:_reSendMsgRow];
    messageEntity.state = [NSNumber numberWithInt:0];
    messageEntity.time = [Utils getCurrentTime];
    
    [DBHelper inTransaction:^(FMDatabase *db) {
        [DBMessageManager deleteByMessageId:messageEntity.messageId AndWithRectime:messageEntity.rectime FMDatabase:db DelResult:^(Boolean result) {
            if(!result)
            {
                NSLog(@"删除消息出错");
            }
        }];
        [DBMessageManager insertArray:[NSMutableArray arrayWithObject:messageEntity] FMDatabase:db ResultStat:^(Boolean result) {
            if(result)
            {
                [self reloadListFromDB:db];
            }

        }];
    }];
    
    //根据 显示内容加入view
    if (![Utils isBlankString:messageEntity.url]) {
        ;
    }
    else  if (![Utils isBlankString:messageEntity.video]) {
        //视频内容
        [self uploadVideo:messageEntity];
    }
    else  if (![Utils isBlankString:messageEntity.voice]) {
        [self uploadVoice:messageEntity];
    }
    else if ([messageEntity.msgType isEqualToString:@"group_image"] ||[messageEntity.msgType isEqualToString:@"user_image"] )
    {
        [self uploadImage:messageEntity];
    }
    else{
        [self sendTextToServer:messageEntity];
    }
}


//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(180.0f,20000.0f); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: font};
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:   @"\\[[\\\\w\\u4e00-\\u9fa5\\w]+\\]" options:0 error:nil];
    NSString *str  =[regularExpression stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@"[M]"];
    CGSize labelsize = [str boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
//    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble = [UIImage imageNamed:fromSelf?@"chatto_bg_focused.png":@"chatfrom_bg_focused.png"];
//    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:50 topCapHeight:40]];
    
    CGFloat top = 48; // 顶端盖高度
    CGFloat bottom = 20 ; // 底端盖高度
    CGFloat left = 45; // 左端盖宽度
    CGFloat right = 40; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImageView *bubbleImageView   =  [[UIImageView alloc] initWithImage:[bubble resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch]];

    MLEmojiLabel *emojiLabel = [MLEmojiLabel new];
    MLEmojiLabel *bubbleText = nil;
    if ([text hasPrefix:@"[\\"]) {
        
        if ([text hasPrefix:@"[\\小璇_"]) {
             emojiLabel.customEmojiPlistName = @"xiaoxuanemoji";
        }
        else if ([text hasPrefix:@"[\\小凯_"]) {
            emojiLabel.customEmojiPlistName = @"wangkaiemoji";
        }
        else
        {
             emojiLabel.customEmojiPlistName = @"laowangemoji";
        }
        emojiLabel.font = [UIFont systemFontOfSize:50.0f];
        emojiLabel.frame = CGRectMake(fromSelf?22.0f:22.0f, 0.0f, 80+5, 80+10);
        
        bubbleText =[self emojiLabel:text MLEmojiLabel:emojiLabel];
        bubbleImageView.frame = CGRectMake(0.0f, 0.0f, 80+30.0f, 80+20.0f);
        if(fromSelf)
            returnView.frame = CGRectMake(320-position-(80+30.0f), 0.0f, 80+30.0f, 80+30.0f);
        else
            returnView.frame = CGRectMake(position, 0.0f, 80+30.0f, 80+30.0f);
    }
    else
    {
        emojiLabel.customEmojiPlistName = @"emoji";
        emojiLabel.font = [UIFont systemFontOfSize:15.0f];

        #define kCommonWidth 250.0f
        emojiLabel.frame = CGRectMake(fromSelf?15.0f:22.0f, 6.0f, labelsize.width+10, labelsize.height+10);
//    CGSize size = [emojiLabel preferredSizeWithMaxWidth:kCommonWidth];
        bubbleText =[self emojiLabel:text MLEmojiLabel:emojiLabel];
        bubbleImageView.frame = CGRectMake(0.0f, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
        if(fromSelf)
            returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
        else
            returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    }
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
}


//泡泡语音
- (UIView *)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position{
    
    //根据语音长度
    int yuyinwidth = 66+fromSelf;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexRow;
    if(fromSelf)
        button.frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);
    else
        button.frame =CGRectMake(position, 10, yuyinwidth, 54);
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"chatto_bg_focused":@"chatfrom_bg_focused"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%ld''",(long)logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    
    return button;
}

//这个是通常的用法
- (MLEmojiLabel *)emojiLabel:(NSString *) text MLEmojiLabel:(MLEmojiLabel *)emojiLabel
{
    
//       MLEmojiLabel *emojiLabel = [MLEmojiLabel new];
//        emojiLabel.frame = CGRectMake(fromSelf?15.0f:22.0f, 6.0f, labelsize.width+10, labelsize.height+10);
        emojiLabel.numberOfLines = 0;
//        emojiLabel.font = [UIFont systemFontOfSize:15.0f];
        emojiLabel.delegate = self;
        emojiLabel.textAlignment = NSTextAlignmentLeft;
        emojiLabel.backgroundColor = [UIColor clearColor];
//        emojiLabel.isNeedAtAndPoundSign = YES;
//        emojiLabel.customEmojiPlistName = @"wangkaiemoji";
        emojiLabel.customEmojiBundleName = nil;
     emojiLabel.customEmojiRegex = @"\\[[\\\\w\\u4e00-\\u9fa5\\w]+\\]";
        //        emojiLabel.disableThreeCommon = YES;
//                emojiLabel.disableEmoji = YES;
        emojiLabel.text = text;
        //测试TTT原生方法
        [emojiLabel addLinkToURL:[NSURL URLWithString:@"http://sasasadan.com"] withRange:[emojiLabel.text rangeOfString:@"TableView"]];
    
        //这句测试剪切板
        [emojiLabel performSelector:@selector(copy:) withObject:nil afterDelay:0.01f];
    
    return emojiLabel;
}


- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
        {
            NSString * url = @"http://";
            if ([link hasPrefix:@"http://"]) {
                url = link;
            }
            else{
                url = [url stringByAppendingString:link];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
            NSLog(@"点击了链接%@",link);
        }
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
        {
            //直接拨打电话
            //NSString *allString = [NSString stringWithFormat:@"tel:%@",link];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
            //先提示再拨打电话
    
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",link];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            NSLog(@"点击了电话%@",link);
        }
            break;
        case MLEmojiLabelLinkTypeEmail:
        {
             NSString * url = @"mailto://";
             url = [url stringByAppendingString:link];
            [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:url]];
            NSLog(@"点击了邮箱%@",link);
        }
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}

- (void)voiceBubbleDidStartPlaying:(FSVoiceBubble *)voiceBubble
{
    _currentRow = voiceBubble.tag;
}




//录音部分初始化
-(void)audioInit
{
    NSError * err = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    [audioSession setActive:YES error:&err];
    
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    //通过可变字典进行配置项的加载
    NSDictionary *setAudioDic = [VoiceConverter GetAudioRecorderSettingDict];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.wav", strUrl, fileName]];
    _audioPlayURL = url;
    
    NSError *error;
    //初始化
    self.audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setAudioDic error:&error];
    //开启音量检测
    self.audioRecorder.meteringEnabled = YES;
//    self.audioRecorder.delegate = self;
    
}


-(void) uploadImage:(MessageEntity *) textMsg
{
    NSString *pathOfurl = [NSString stringWithFormat:@"%@%@", KFILE_ROOT_PATH, KIMAGE_UPLOAD_PATH];
    //        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    NSDictionary *parameters = @{@"uploadedfile":textMsg.content, @"user-name":APPDELEGATE.UserID};
    [EXHttpHelper uploadFileURL:[NSURL URLWithString:[KOriginalPhotoImagePath stringByAppendingPathComponent: textMsg.content]] parameters:parameters  addr:pathOfurl name:@"uploadedfile" fileName:textMsg.content mimeType:@"image/jpeg" success:^(int resultCode, id responseObject) {
        //向服务器发送消息
        [self sendTextToServer:textMsg];
    } failure:^(NSError *error) {
        WDLog(@"文件上传失败");
        textMsg.state = [NSNumber numberWithInt:-1];
        [DBHelper inTransaction:^(FMDatabase *db) {
            [DBMessageManager updateStateByID:textMsg.messageId Time:textMsg.time State:[NSNumber numberWithInt:-1] FMDatabase:db QueryResult:^(Boolean result) {
                [self reloadListFromDB:db];
            }];
        }];
    }];
}

#pragma mark === 上传语音后 发送消息===
-(void) uploadVoice:(MessageEntity *) textMsg
{
    NSString *strUrl =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *pathOfurl = [NSString stringWithFormat:@"%@%@", KFILE_ROOT_PATH, KVOICE_UPLOAD_PATH];
    
    [EXHttpHelper uploadFileURL:[NSURL URLWithString:[strUrl stringByAppendingPathComponent:textMsg.voice]] parameters:nil  addr:pathOfurl name:@"uploadedfile" fileName:textMsg.voice mimeType:@"application/octet-stream" success:^(int resultCode, id responseObject) {
        //向服务器发送消息
        [self sendTextToServer:textMsg];
        
    } failure:^(NSError *error) {
        WDLog(@"文件上传失败");
        textMsg.state = [NSNumber numberWithInt:-1];
        [DBHelper inTransaction:^(FMDatabase *db) {
            [DBMessageManager updateStateByID:textMsg.messageId Time:textMsg.time State:[NSNumber numberWithInt:-1] FMDatabase:db QueryResult:^(Boolean result) {
                [self reloadListFromDB:db];
                
            }];
        }];
    }];
}


#pragma mark === 上传视频后 发送消息===
-(void) uploadVideo:(MessageEntity *) textMsg
{
    
    NSString *pathOfurl = [NSString stringWithFormat:@"%@%@", KFILE_ROOT_PATH, KVIDEO_UPLOAD_PATH];
   
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *folderPath = [path stringByAppendingPathComponent:@"videos"];
    NSString *strUrl =  [folderPath stringByAppendingPathComponent:textMsg.video];
    [EXHttpHelper uploadFileURL:[NSURL URLWithString:strUrl] parameters:nil  addr:pathOfurl name:@"uploadedfile" fileName:textMsg.video mimeType:@"application/octet-stream" success:^(int resultCode, id responseObject) {
        //向服务器发送消息
        [self sendTextToServer:textMsg];
        
    } failure:^(NSError *error) {
        WDLog(@"文件上传失败");
        textMsg.state = [NSNumber numberWithInt:-1];
        [DBHelper inTransaction:^(FMDatabase *db) {
            [DBMessageManager updateStateByID:textMsg.messageId Time:textMsg.time State:[NSNumber numberWithInt:-1] FMDatabase:db QueryResult:^(Boolean result) {
                [self reloadListFromDB:db];
                
            }];
        }];
    }];
}

#pragma mark === 直接发送消息===
-(void)sendTextToServer:(MessageEntity *) textMsg
{
    //网络发送
    [EXHttpHelper POST:KACTION_SENDMESSAGE deviceType:KDEVICE_TYPE_WT parameters:textMsg.toDictionary success:^(int resultCode, id responseObject) {
        DLog(@"消息发送成功");;
        //消息状态 -1 发送失败  0 正在发送  1 发送成功
        textMsg.state = [NSNumber numberWithInt:1];
        [DBHelper inTransaction:^(FMDatabase *db) {
            [DBMessageManager updateStateByID:textMsg.messageId Time:textMsg.time State:[NSNumber numberWithInt:1] FMDatabase:db QueryResult:^(Boolean result) {
                [self reloadListFromDB:db];
            }];
        }];
    } failure:^(NSError *error) {
        DLog(@"消息发送失败");
        textMsg.state = [NSNumber numberWithInt:-1];
        [DBHelper inTransaction:^(FMDatabase *db) {
            [DBMessageManager updateStateByID:textMsg.messageId Time:textMsg.time State:[NSNumber numberWithInt:-1] FMDatabase:db QueryResult:^(Boolean result) {
                [self reloadListFromDB:db];
                
            }];
        }];
    }];
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
#pragma mark === 实现 EXCreateGroupViewController 的协议 ===
-(void) selectedFriDic:(NSMutableArray *)dic
{
    //创建群组
    WDLog(@"返回创建数组%@",dic);
}


-(void)getGroupInfo
{
    NSDictionary *dict = @{@"userName":APPDELEGATE.userName, @"obtainType":_groupId};
    [EXHttpHelper POST:KACTION_GROUP_LIST deviceType:KDEVICE_TYPE_WT parameters:dict success:^(int resultCode, id responseObject) {
        switch (resultCode) {
            case 0: //成功
            {
                [DBHelper inTransaction:^(FMDatabase *db) {
                    [DBDialogueListManager queryByID:_groupId FMDatabase:db QueryResult:^(DialogueListEntity *result) {
                        result.groupOwer = [responseObject objectForKey:@"groupOwer"];
                        result.groupName = [responseObject objectForKey:@"groupName"];
                        result.groupMemberCount = [responseObject objectForKey:@"groupMemberCount"];
                        [DBDialogueListManager updateByID:_groupId FMDatabase:db DialogueListEntity:result UpdateResult:^(Boolean result) {
                            NSLog(@"%@", result?@"YES":@"NO");
                        }];
//                        [DBDialogueMemberManager  insertArray:[responseObject objectForKey:@"groupMemberList"] FMDatabase:db WithGroupId:_groupId InsertResult:^(Boolean result) {
//                             NSLog(@"%@", result?@"YES":@"NO");
//                        }];
                    }];
                }];
             }
                break;
                
            default:
            {
                NSLog(@"未知错误, 服务器返回异常");
            }
                break;
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
