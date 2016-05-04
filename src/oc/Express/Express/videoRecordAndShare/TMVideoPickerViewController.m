//
//  TMVideoPickerViewController.m
//  Twatch
//
//  Created by WangBo on 15/8/7.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import "TMVideoPickerViewController.h"
//#import "TMVideoSelectTableViewCell0.h"
#import "TMVideoSelectTableViewCell.h"
#import "PBJVision.h"
#import "PBJViewController.h"
#import "TMVideoButton.h"
#import "PlayViewController.h"
//#import "ShareTinyViewPointViewController.h"
//#import "TMVideoItemPlayView.h"

#define DEVICE_SIZE [[UIScreen mainScreen] applicationFrame].size

@interface TMVideoButton (ExtendedHit)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;

@end

@implementation TMVideoButton (ExtendedHit)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect relativeFrame = self.bounds;
    UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(-35, -35, -35, -35);
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

@end

static NSString const *ADDINGVIDEO = @"videos";

#define DELBTN_WID 44

@interface TMVideoPickerViewController ()

@property (nonatomic, assign) int numOfLine;
@property (nonatomic,strong) UIButton *checkinBtn;
@property (nonatomic,strong) NSMutableArray *tbSourceArr;

@property (nonatomic,strong) NSString *applicationDocumentsDir;
@property (nonatomic,strong) NSString *strfiledir;

@property (nonatomic,strong) NSString *selVideoName;
@property (nonatomic,strong) TMVideoButton *selCheckBtn;
@property (nonatomic,strong) PlayViewController *playCtrl;
@property (nonatomic,strong) UIView *bottomBar;

@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIView *deleteBackView;
@property (nonatomic, strong) UIButton *deleteIconBtn;
@property (nonatomic, strong) UIImageView *deleteImageView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *delLabel;
//@property (nonatomic, strong) UILabel *tipLabel;

//是否可删除
@property (nonatomic, assign) BOOL isCanDeleted;

@property (nonatomic, strong) NSMutableArray *delVideoArr;

@end

@implementation TMVideoPickerViewController

@synthesize checkinBtn;
@synthesize tbSourceArr;
@synthesize applicationDocumentsDir;
@synthesize strfiledir;
@synthesize delBtn;
//@synthesize tipLabel;

+ (void)initialize;
{
    [PBJVision createVideoFolderIfNotExist];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tbSourceArr = [NSMutableArray array];
    self.selCheckBtn = nil;
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self setLeftBarImgBtn:nil];
    [self setRightBarTextBtn:@"编辑"];
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, isIOS7 ? 20.0 : 0.0,54, 44)];
//    [backButton setBackgroundColor:[UIColor clearColor]];
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    
//    delBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, isIOS7?20:0, 64, 44)];
//    [delBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [delBtn setTitleColor:UIColorFromRGB(KE6E6E6Color) forState:UIControlStateNormal];
//    [delBtn setTitleColor:UIColorFromRGB(KE6E6E6Color) forState:UIControlStateHighlighted];
//    [delBtn addTarget:self action:@selector(delBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:delBtn];
//
//    //添加删除图标按钮
//    int delBtnWid = DELBTN_WID;
////    _deleteBackView = [[UIView alloc] initWithFrame: CGRectMake(260, IS_IOS7?20:0, delBtnWid, delBtnWid)];
//    _deleteBackView = [[UIView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH - 60, isIOS7?20:0, 64, 44)];
//
//    int IMG_WID = 25;
//    int IMG_HEIGHT = 25;
//    _deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DELBTN_WID - IMG_WID)/2,(DELBTN_WID - IMG_HEIGHT)/2, IMG_WID, IMG_HEIGHT)];
//    [_deleteImageView setUserInteractionEnabled:YES];
//    _delLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 64, 44)];
//    [_deleteBackView addSubview:_delLabel];
//    [_delLabel setTextColor:UIColorFromRGB(KE6E6E6Color)];
//    [_delLabel setTextAlignment:NSTextAlignmentCenter];
//    //[_deleteBackView addSubview:_deleteImageView];
    
    
//    _deleteIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_deleteIconBtn setFrame:CGRectMake(0, 0, delBtnWid, delBtnWid)];
//    [_deleteIconBtn setBackgroundColor:[UIColor clearColor]];
//    [_deleteIconBtn addTarget:self action:@selector(delIconBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_deleteBackView addSubview:_deleteIconBtn];
//    
//    [self.view addSubview:_deleteBackView];
//    [_deleteBackView setHidden:YES];

    
    self.videoArr = [[NSMutableArray alloc] init];
    _numOfLine = 0;
    
    int bottomheight = 44;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, DEVICE_SIZE.height - 58 - bottomheight +  + (isIOS7 ? 20 : 0))];
    
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    
     self.tableview.backgroundColor = [UIColor whiteColor];

    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if ([ self.tableview respondsToSelector:@selector(setSeparatorInset:)])
    {
        [ self.tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([ self.tableview respondsToSelector:@selector(setLayoutMargins:)])
    {
        [ self.tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:self.tableview];
    [self getAllTableDataArr];
    [self.tableview reloadData];
    
    
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0,  DEVICE_SIZE.height - bottomheight + (isIOS7 ? 20 : 0), self.view.frame.size.width, bottomheight)];
    [_bottomBar setBackgroundColor:[UIColor whiteColor]];
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:_bottomBar.bounds];
    [bottomImgView setImage:[UIImage imageNamed:@"bg_content"]];
    [_bottomBar addSubview:bottomImgView];
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, DEVICE_SIZE.width, 0.5)];
    [sepView setBackgroundColor:[UIColor lightGrayColor]];
    [_bottomBar addSubview:sepView];
    //[_bottomBar setBackgroundColor:self.naviBackgroundColor];
    
    checkinBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, bottomheight, bottomheight)];
    [checkinBtn setTitle:@"完成" forState:UIControlStateNormal];
    [checkinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //[checkinBtn setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateDisabled];
    [checkinBtn addTarget:self action:@selector(actionForCheckIn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:checkinBtn];
   
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setFrame:CGRectMake(SCREEN_WIDTH - 60, 0, bottomheight, bottomheight)];
    //[_cancelBtn setBackgroundColor:[UIColor clearColor]];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[_cancelBtn setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateDisabled];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_cancelBtn];
    [_cancelBtn setHidden:YES];
    
    [self.view addSubview:_bottomBar];
    _delVideoArr = [[NSMutableArray alloc] init];
    [_delVideoArr removeAllObjects];
    self.selVideoName = @"";
    
}

-(void) rightBtnAction:(id)sender
{
    if (_isCanDeleted) {
        [self delIconBtnClicked:sender];
    }
    else
    {
        [self setRightBarTextBtn:@"删除"];
        [self delBtnClicked:sender];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    [self setTitle:@"小视频"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

//点击进入视频删除界面
-(void)delBtnClicked:(id)sender
{
    [delBtn setHidden:YES];
    [_cancelBtn setHidden:NO];
    [_deleteBackView setHidden:NO];
    //[delBtn setTitle:@"删除" forState:UIControlStateNormal];
    //[_deleteImageView setImage:[UIImage imageNamed:@"title_del.png"]];
    [_delLabel setText:@"删除"];
    [checkinBtn setHidden:YES];

    
    _isCanDeleted = YES;
     self.selCheckBtn.selected = NO;
     self.selVideoName = @"";
}

//点击删除图标按钮删除视频
-(void)delIconBtnClicked:(id)sender
{
    if (self.delVideoArr == nil || [self.delVideoArr count] == 0) {
        return;
    }
    
    [delBtn setHidden:NO];
    [_cancelBtn setHidden:YES];
    [_deleteBackView setHidden:YES];
    //[_deleteImageView setImage:[UIImage imageNamed:@"title_del_click.png"]];
    [checkinBtn setHidden:NO];
    
    _isCanDeleted = NO;
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    for (int i = 0; i < [self.delVideoArr count]; i++) {
        NSString *storePath = [self.delVideoArr objectAtIndex:i];
        if([[NSFileManager defaultManager] fileExistsAtPath:storePath])
        {
            NSError *err;
            [fileMgr removeItemAtPath:storePath error:&err];
            
            NSString *strVideoCaptureName = [storePath stringByReplacingOccurrencesOfString:@".mp4" withString:@".png"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:strVideoCaptureName]) {
                NSError *err1;
                [fileMgr removeItemAtPath:strVideoCaptureName error:&err1];
            }
        }
    }
    [self getAllTableDataArr];
    [_tableview reloadData];
}

//用户取消删除相册
-(void)cancelBtnClicked:(id)sender
{
    [delBtn setHidden:NO];
    [_cancelBtn setHidden:YES];
    [_deleteBackView setHidden:YES];
    [checkinBtn setHidden:NO];
    
    _isCanDeleted = NO;
    self.selCheckBtn.selected = NO;
    self.selVideoName = @"";
    [self.delVideoArr removeAllObjects];
    [_tableview reloadData];
    [self setRightBarTextBtn:@"编辑"];
}


//用户选择分享视频
-(void) actionForCheckIn:(id)sender
{
    if (self.selVideoName != nil && ![self.selVideoName isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(didFinishSelectVideoFileName:)]) {
            [self.navigationController popViewControllerAnimated:NO];
            [self.delegate didFinishSelectVideoFileName:self.selVideoName];
        }
    }
}

//视频录制完成
-(void)didFinishRecordVideoFile:(NSString *)strVideoPathAndName
{
    if ([self.delegate respondsToSelector:@selector(didFinishSelectVideoFileName:)]) {
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate didFinishSelectVideoFileName:strVideoPathAndName];
    }
}

-(void)getAllTableDataArr
{
    [self deleteVideosbeforeSevenDays];
    [self getUserRecordVideoFileNameAndImageFileName];
    [self caculateVideoPathArr];
}

-(void)deleteVideosbeforeSevenDays
{
    
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSince1970]*1000;
    NSNumber *numStage = [NSNumber numberWithDouble:interval];
    NSString *nowTimeStr = [NSString stringWithFormat:@"%0.0lf",[numStage doubleValue]];
    
    NSInteger nowTime = [nowTimeStr integerValue];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *folderPath = [path stringByAppendingPathComponent:@"videos"];
    
    NSString *strImgFileName = [folderPath stringByAppendingPathComponent:@"captureImage"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:strImgFileName]){
        
        NSArray *imgArr = [NSArray arrayWithContentsOfFile:strImgFileName];
        NSMutableArray *newImgArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < [imgArr count]; i++) {
            NSString *strtemp = [imgArr objectAtIndex:i];
            NSString *strTempImgFileName = [folderPath stringByAppendingPathComponent:strtemp];
            NSString *strTempVideoFileName = [folderPath stringByAppendingPathComponent:[strtemp stringByReplacingOccurrencesOfString:@".png" withString:@".mp4"]];
            
            
            NSString *strTempTime = [strtemp stringByReplacingOccurrencesOfString:@".png" withString:@""];
            NSInteger tempTime = [strTempTime integerValue];
            if ((nowTime - tempTime) > 3600 * 24 * 7 * 1000) {
                if ([fileManager fileExistsAtPath:strTempImgFileName]) {
                    NSError *Error;
                    [fileManager removeItemAtPath:strTempImgFileName error:&Error];
                }else{
                    [newImgArr addObject:strtemp];
                }
                
                if ([fileManager fileExistsAtPath:strTempVideoFileName]) {
                    NSError *Error;
                    [fileManager removeItemAtPath:strTempVideoFileName error:&Error];
                }
            }
        }
        
        if (newImgArr.count > 0) {
             [newImgArr writeToFile:strImgFileName atomically:YES];
        }
       
    }
}

-(void)getUserRecordVideoFileNameAndImageFileName
{
    
//    NSString *userName = sharedic.username;
//    NSNumber *nsid = sharedic.sid;
//    
//    NSString *voice = [NSString stringWithFormat:@"%@", sharedic.voice];
//    NSArray *filelist = [NSArray arrayWithArray:[sharedic.filelist componentsSeparatedByString:@","]];
    
//    applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    strfiledir = [applicationDocumentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", userName, nsid]];
//    strfiledir = [strfiledir stringByAppendingPathComponent:ADDINGVIDEO];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:strfiledir])
//    {
//        [[NSFileManager defaultManager] createDirectoryAtPath:strfiledir
//                                  withIntermediateDirectories:NO
//                                                   attributes:nil
//                                                        error:nil];
   // }
    
    //self.tbSourceArr = [NSMutableArray array];
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *folderPath = [path stringByAppendingPathComponent:@"videos"];

    NSString *strImgFileName = [folderPath stringByAppendingPathComponent:@"captureImage"];
    //NSString *strVideoFileName = [folderPath stringByAppendingString:@"captureVideo"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
  
    NSMutableArray *allFileNameArr = [NSMutableArray array];
    if([fileManager fileExistsAtPath:strImgFileName]){
        
        NSArray *imgArr = [NSArray arrayWithContentsOfFile:strImgFileName];
        
        for (int i = 0; i < [imgArr count]; i++) {
            NSString *strtemp = [imgArr objectAtIndex:i];
            NSString *strTempImgFileName = [folderPath stringByAppendingPathComponent:strtemp];
            NSString *strTempVideoFileName = [folderPath stringByAppendingPathComponent:[strtemp stringByReplacingOccurrencesOfString:@".png" withString:@".mp4"]];
            if ([fileManager fileExistsAtPath:strTempImgFileName] && [fileManager fileExistsAtPath:strTempVideoFileName]) {
                [allFileNameArr addObject:@[strTempImgFileName,strTempVideoFileName]];
            }
        }
    }
    
    [self.videoArr removeAllObjects];
//    for (int i = 0; i < [allFileNameArr count]; i++) {
//        NSMutableArray *tempArr = [NSMutableArray array];
//        //[tempArr addObject:[allFileNameArr objectAtIndex:i]];
//        //[tempArr addObject:[allFileNameArr objectAtIndex:i]];
//        [self.videoArr addObject:tempArr];
//    }
    [self.videoArr addObjectsFromArray:allFileNameArr];
    
//    tinyViewPointData.filelist = [NSString stringWithFormat:@"%@", [sharefileNameList componentsJoinedByString:@","]];
//    
//    NSArray *sfilelist = [NSArray arrayWithArray:[tinyPoint.filelist componentsSeparatedByString:@","]];
//    for (int i=0; i<[sfilelist count]; i++)
//    {
//        NSString *filename = [NSString stringWithFormat:@"%@", [sfilelist objectAtIndex:i]];
//        NSString *storePath = [strfiledir1 stringByAppendingPathComponent:filename];
//        UIImage  *shareImage = [UIImage imageWithContentsOfFile:storePath];
//        NSData *imageData = UIImageJPEGRepresentation(shareImage, 1.0);
//        
//        if(imageData)
//        {
//            [shareImages addObject:imageData];
//        }
//        
//        shareImage=nil;
//    }
    
    
}

+ (NSString *)getVideoSaveFilePathString
{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        
        path = [path stringByAppendingPathComponent:@"videos"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        
        NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
        
        return fileName;

}

-(void) caculateVideoPathArr
{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSArray *AddingArr = @[ADDINGVIDEO,ADDINGVIDEO];
    [tempArr addObject:AddingArr];
    
    
    [tempArr addObjectsFromArray:self.videoArr];
    
    [tbSourceArr removeAllObjects];
    
    int rowNum = [tempArr count] / 3 + 1;
    for (int i = 0; i < rowNum; i++) {
        NSMutableArray *threeArr = [NSMutableArray array];
        for (int j = 0; j < 3; j++) {
            if (i * 3 + j < [tempArr count]) {
                [threeArr addObject:tempArr[i * 3 + j]];
            }
        }
        if ([threeArr count] > 0) {
            [tbSourceArr addObject:threeArr];
        }
    }
}

-(void)addButtonClicked:(id)sender
{
    PBJViewController *videoRecoderCtrl = [[PBJViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    videoRecoderCtrl.delegate = self;
    [self.navigationController pushViewController:videoRecoderCtrl animated:YES];
}

-(void)playButtonClicked:(id)sender
{
    TMVideoButton *btn = (TMVideoButton *)sender;
    self.hidesBottomBarWhenPushed = YES;
    //PlayViewController *playCtrl = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil withVideoFileURL:btn.strVideoName];
    self.playCtrl = [[PlayViewController alloc] init:[NSURL fileURLWithPath:btn.strVideoName isDirectory:YES]];//[NSURL URLWithString:btn.strVideoName]
    [self.navigationController pushViewController:self.playCtrl animated:YES];
    
}

//-(void)playButtonClicked:(id)sender
//{
//    NSString *strVVVName = @"/var/mobile/Containers/Data/Application/A1684822-27CB-4717-B966-F5A2326CAC2D/Documents/13629290430_112/1439882305415.mp4";
//    TMVideoButton *btn = (TMVideoButton *)sender;
//    
//    TMVideoItemPlayView *view = [[TMVideoItemPlayView alloc] initWithFrame:CGRectMake(0, 100, 200, 150)];
//    [view conigViewData1:strVVVName];
//    //[view conigViewData1:btn.strVideoName];
//    [self.view addSubview:view];
//    
//}

-(void)checkButtonClicked:(id)sender
{
    TMVideoButton *btn = (TMVideoButton *)sender;
    self.selVideoName = btn.strVideoName;
    if (![self.selCheckBtn isEqual:btn]) {
        self.selCheckBtn.selected = NO;
        self.selCheckBtn = btn;
        self.selCheckBtn.selected = YES;
    }
   
}

-(void)checkButtonClicked1:(UILongPressGestureRecognizer*)longRecognizer
{
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        
        TMVideoButton *btn = (TMVideoButton *)longRecognizer.view;
        self.selVideoName = btn.strVideoName;
        TMVideoButton *btnCheck = (TMVideoButton *)btn.checkBtn;
        if (![self.selCheckBtn isEqual:btnCheck]) {
            self.selCheckBtn.selected = NO;
            self.selCheckBtn = btnCheck;
            self.selCheckBtn.selected = YES;
        }else{
            self.selCheckBtn.selected = !self.selCheckBtn.selected;
        }
        
        if(!self.selCheckBtn.selected){
            self.selVideoName = @"";
        }
    }
}

//-(void)tapButtonClicked:(UITapGestureRecognizer*)tapRecognizer
//{
//    //if (tapRecognizer.state == UIGestureRecognizerStateBegan) {
//        TMVideoButton *btn = (TMVideoButton *)tapRecognizer.view;
//        self.selVideoName = btn.strVideoName;
//        TMVideoButton *btnCheck = (TMVideoButton *)btn.checkBtn;
//        CGPoint tapPoint = [tapRecognizer locationInView:btn.superview];
//        if (CGRectContainsPoint(btnCheck.frame, tapPoint)) {
//            
//            
//            if (![self.selCheckBtn isEqual:btnCheck]) {
//                self.selCheckBtn.selected = NO;
//                self.selCheckBtn = btnCheck;
//                self.selCheckBtn.selected = YES;
//            }else{
//                self.selCheckBtn.selected = !self.selCheckBtn.selected;
//            }
//            
//            if(!self.selCheckBtn.selected){
//                self.selVideoName = @"";
//            }
//        }else{
//            self.hidesBottomBarWhenPushed = YES;
//            //PlayViewController *playCtrl = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil withVideoFileURL:btn.strVideoName];
//            self.playCtrl = [[PlayViewController alloc] init:[NSURL fileURLWithPath:btn.strVideoName isDirectory:YES]];//[NSURL URLWithString:btn.strVideoName]
//            [self.navigationController pushViewController:self.playCtrl animated:YES];
//        }
//        
//    //}
//}

-(void)tapButtonClicked:(UITapGestureRecognizer*)tapRecognizer
{
//    [self playButtonClicked:nil];
//    return;
    if (self.isCanDeleted) {
        TMVideoButton *btn = (TMVideoButton *)tapRecognizer.view;
        TMVideoButton *btnCheck = (TMVideoButton *)btn.checkBtn;
        if ([self.delVideoArr count] == 0) {
            [self.delVideoArr addObject:btn.strVideoName];
            btnCheck.selected = YES;
            return;
        }
        
        for (int i = 0; i < [self.delVideoArr count]; i++) {
            NSString *strFileName = [self.delVideoArr objectAtIndex:i];
            if ([strFileName isEqualToString:btn.strVideoName]) {
                btnCheck.selected = NO;
                [self.delVideoArr removeObjectAtIndex:i];
                break;
            }
            
            if (i == [self.delVideoArr count] - 1) {
                [self.delVideoArr addObject:btn.strVideoName];
                btnCheck.selected = YES;
                break;
            }
        }
    }else{
        TMVideoButton *btn = (TMVideoButton *)tapRecognizer.view;
        self.selVideoName = btn.strVideoName;
        TMVideoButton *btnCheck = (TMVideoButton *)btn.checkBtn;
        CGPoint tapPoint = [tapRecognizer locationInView:btn.superview];
        if (CGRectContainsPoint(btnCheck.frame, tapPoint)) {
            
            
            if (![self.selCheckBtn isEqual:btnCheck]) {
                self.selCheckBtn.selected = NO;
                self.selCheckBtn = btnCheck;
                self.selCheckBtn.selected = YES;
            }else{
                self.selCheckBtn.selected = !self.selCheckBtn.selected;
            }
            
            if (self.selCheckBtn.selected) {
                [self.checkinBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else {
                [self.checkinBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            if(!self.selCheckBtn.selected){
                self.selVideoName = @"";
            }
        }else{
            self.hidesBottomBarWhenPushed = YES;
            //PlayViewController *playCtrl = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil withVideoFileURL:btn.strVideoName];
            self.playCtrl = [[PlayViewController alloc] init:[NSURL fileURLWithPath:btn.strVideoName isDirectory:YES]];//[NSURL URLWithString:btn.strVideoName]
            [self.navigationController pushViewController:self.playCtrl animated:YES];
        }
    }

}



#pragma UITableViewDataSource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tbSourceArr count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.tbSourceArr count]) {
        
         static NSString *CellIdentifier = @"TMVideoPickerFootTableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TMVideoPickerFootTableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
        
        UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 40)];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [tipLabel setText:@"只保存七天内的视频"];
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
        [tipLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [cell.contentView addSubview:tipLabel];
        
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"TMVideoSelectTableViewCell";
        
        TMVideoSelectTableViewCell* cell = (TMVideoSelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TMVideoSelectTableViewCell" owner:self options:nil];
            if ([array count] > 0) {
                cell = (TMVideoSelectTableViewCell *)[array objectAtIndex:0];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *tempArr = [self.tbSourceArr objectAtIndex:indexPath.row];
        for (int i = 0; i < [tempArr count]; i++) {
            NSArray *imgAndVideoArr = [tempArr objectAtIndex:i];
            NSString * strVideoCaptureImageName = [imgAndVideoArr objectAtIndex:0];
            NSString * strVideoName = [imgAndVideoArr objectAtIndex:1];
            
            UIImage *img = [UIImage imageNamed:strVideoCaptureImageName];  //添加视频截图的url地址
            
            if (i == 0) {
                if (indexPath.row == 0){
                    
                    [cell.leftVideoImageView setBackgroundColor:[UIColor blackColor]];//tianjiazhaopian_click
                    
                    cell.leftBtn.strVideoName = @"adding";
                    cell.leftBtn.strVideoCaptureImageName = @"adding";
                    cell.leftBtn.tag = 0;
                    cell.leftBtn.rowNum = 0;
                    [cell.leftBtn setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian_click"] forState:UIControlStateSelected];
                    [cell.leftBtn setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian"] forState:UIControlStateNormal];
                    [cell.leftBtn addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.leftBtn setFrame:cell.leftVideoImageView.frame];
                    
                    cell.leftCheck.tag = 0;
                    cell.leftCheck.hidden = YES;
                    
                }else{
                    
                    [cell.leftVideoImageView setBackgroundImage:img forState:UIControlStateNormal];//tianjiazhaopian_click
                    
                    cell.leftBtn.strVideoName = strVideoName;
                    cell.leftBtn.strVideoCaptureImageName = strVideoCaptureImageName;
                    cell.leftBtn.tag = 0;
                    cell.leftBtn.rowNum = 0;
                    //[cell.leftBtn setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateSelected];
                    //[cell.leftBtn setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
                    //[cell.leftBtn addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    cell.leftBtn.checkBtn = cell.leftCheck;
                    //cell.leftBtn.exclusiveTouch = YES;
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButtonClicked:)];
                    tapGesture.numberOfTapsRequired = 1;
                    [cell.leftBtn addGestureRecognizer:tapGesture];
                    [cell.leftBtn setFrame:CGRectMake(45, 35, 30, 30)];
                    
                    cell.leftCheck.tag = 0;
                    cell.leftCheck.hidden = NO;
                    [cell.leftCheck setImage:[UIImage imageNamed:@"AssetsPickerChecked"] forState:UIControlStateSelected];//AssetsPickernormal
                    [cell.leftCheck setImage:[UIImage imageNamed:@"AssetsPickernormal"] forState:UIControlStateNormal];
                    //[cell.leftCheck addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    cell.leftCheck.exclusiveTouch = YES;
                    
                    
                    //                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(checkButtonClicked1:)];
                    //                longPress.minimumPressDuration = 1.0;
                    //                [cell.leftBtn addGestureRecognizer:longPress];
                    
                }
                
            }else if(i == 1){//video
                
                //[cell.midVideoImageView setBackgroundColor:[UIColor blackColor]];
                [cell.midVideoImageView setBackgroundImage:img forState:UIControlStateNormal];
                //[cell.midVideoImageView setImage:img];
                cell.midBtn.strVideoName = strVideoName;
                cell.midBtn.strVideoCaptureImageName = strVideoCaptureImageName;
                cell.midBtn.tag = 1;
                cell.midBtn.rowNum = 1;
                cell.midBtn.hidden = NO;
                [cell.midBtn addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.midBtn.checkBtn = cell.midCheck;
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButtonClicked:)];
                tapGesture.numberOfTapsRequired = 1;
                [cell.midBtn addGestureRecognizer:tapGesture];
                
                //[cell.midBtn setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateSelected];
                //[cell.midBtn setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
                
                cell.midCheck.tag = 1;
                cell.midCheck.hidden = NO;
                [cell.midCheck setImage:[UIImage imageNamed:@"AssetsPickerChecked"] forState:UIControlStateSelected];
                [cell.midCheck setImage:[UIImage imageNamed:@"AssetsPickernormal"] forState:UIControlStateNormal];
                [cell.midCheck setFrame:CGRectMake(165.0 * SCREEN_WIDTH / 320.0, cell.midCheck.frame.origin.y, cell.midCheck.frame.size.width, cell.midCheck.frame.size.height)];
                //            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(checkButtonClicked1:)];
                //            longPress.minimumPressDuration = 1.0;
                //            [cell.midBtn addGestureRecognizer:longPress];
                
            }else{
                
                [cell.rightVideoImageView setBackgroundImage:img forState:UIControlStateNormal];
                //[cell.rightVideoImageView setImage:img];
                cell.rightBtn.strVideoName = strVideoName;
                cell.rightBtn.strVideoCaptureImageName = strVideoCaptureImageName;
                cell.rightBtn.tag = 2;
                cell.rightBtn.rowNum = 2;
                cell.rightBtn.hidden = NO;
                [cell.rightBtn addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.rightBtn.checkBtn = cell.rightCheck;
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButtonClicked:)];
                tapGesture.numberOfTapsRequired = 1;
                [cell.rightBtn addGestureRecognizer:tapGesture];
                
                //[cell.rightBtn setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateSelected];
                //[cell.rightBtn setBackgroundImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
                
                cell.rightCheck.tag = 2;
                cell.rightCheck.hidden = NO;
                [cell.rightCheck setImage:[UIImage imageNamed:@"AssetsPickerChecked"] forState:UIControlStateSelected];
                [cell.rightCheck setImage:[UIImage imageNamed:@"AssetsPickernormal"] forState:UIControlStateNormal];
                
                //            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(checkButtonClicked1:)];
                //            longPress.minimumPressDuration = 1.0;
                //            [cell.rightBtn addGestureRecognizer:longPress];
                
            }
        }
        
        [cell setSelected:NO];
        
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.tbSourceArr count]) {
        return 40;
    } else {
        return 95;

    }
}

@end
