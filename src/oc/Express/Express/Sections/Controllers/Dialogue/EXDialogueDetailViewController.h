//
//  EXDialogueDetailViewController.h
//  Express
//
//  Created by owen on 15/11/12.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "UIBaseViewController.h"
#import "DBDialogueListManager.h"
#import "MLEmojiLabel.h"
#import "FSVoiceBubble.h"
#import "FaceBoard.h"
#import "LVRecordTool.h"
#import "ZYQAssetPickerController.h"
#import "EXCreateGroupViewController.h"
#import "TMVideoPickerViewController.h"



@interface EXDialogueDetailViewController : UIBaseViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,  MLEmojiLabelDelegate, FSVoiceBubbleDelegate, LVRecordToolDelegate, UIActionSheetDelegate, ZYQAssetPickerControllerDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate, EXCreateGroupViewControllerDelegate, UIAlertViewDelegate,  MWPhotoBrowserDelegate ,TMVideoPickerViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dialogueDetailDict;
@property (nonatomic, strong) NSString  * groupId;
@property (nonatomic, strong) NSNumber  *groupType; 
@property (nonatomic, assign) BOOL   isShowName;


@property (nonatomic, strong) UIButton * sendBtn;
@property (nonatomic, strong) UIButton * addMediaBtn;
@property (nonatomic, strong) UIButton * changeTocontextBtn;
@property (nonatomic, strong) UIButton * changeToVoiceBtn;;
@property (nonatomic, strong) UIButton * voiceBtn;
@property (nonatomic, strong) UIButton * smiliesBtn;
@property (nonatomic, strong) UITextView * contextTextView;
@property (nonatomic, strong) UIView  * bottomView;

@property (nonatomic, strong)   FaceBoard *faceBoard;



@end
