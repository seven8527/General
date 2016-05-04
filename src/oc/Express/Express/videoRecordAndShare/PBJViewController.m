//
//  PBJViewController.m
//
//
//  Created by WangBo on 15/8/10.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import "PBJViewController.h"
#import "PBJVision.h"
#import <MediaPlayer/MPMediaPlayback.h>
//#import "BackNavigationButton.h"

#import <AssetsLibrary/AssetsLibrary.h>

//@interface UIButton (ExtendedHit)
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
//
//@end
//
//@implementation UIButton (ExtendedHit)
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGRect relativeFrame = self.bounds;
//    UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(-35, -35, -35, -35);
//    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
//    return CGRectContainsPoint(hitFrame, point);
//}
//
//@end

@interface PBJViewController () <
UIGestureRecognizerDelegate,
PBJVisionDelegate,
UIAlertViewDelegate>
{
    //PBJStrobeView *_strobeView;
    UIButton *_doneButton;
    UIButton *_flipButton;
    
    UIView *_previewView;
    AVCaptureVideoPreviewLayer *_previewLayer;
    UILabel *_instructionLabel;
    
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    BOOL _recording;
    
    ALAssetsLibrary *_assetLibrary;
    __block NSDictionary *_currentVideo;
}

@end



@interface PBJViewController()

@property (strong, nonatomic) UIButton *recordButton;
@property (assign, nonatomic) BOOL isReStartRecord;

//录制视频的定时器
@property (strong, retain) NSTimer *recordTimer;
@property (nonatomic, strong) UIProgressView *recordProgress;
@property (nonatomic, strong)  UILabel *showInfo;
@property (nonatomic, strong)  UIView *recordBackView;
@property (nonatomic, assign)  BOOL islessOneSec;

@end


@implementation PBJViewController

@synthesize recordButton = _recordButton;
@synthesize isReStartRecord;
@synthesize recordTimer = _recordTimer;
@synthesize recordProgress;
@synthesize showInfo;
@synthesize islessOneSec;

#pragma mark - init

- (void)dealloc
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    _longPressGestureRecognizer.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    [self _setup];
}

- (void)_setup
{
    _recordBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height)];
    [_recordBackView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_recordBackView];
    
    //self.view.backgroundColor = [UIColor blackColor];
    //self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    // done button
    //    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _doneButton.frame = CGRectMake(viewWidth - 20.0f - 20.0f, 20.0f, 20.0f, 20.0f);
    //
    //    UIImage *buttonImage = [UIImage imageNamed:@"capture_yep"];
    //    [_doneButton setImage:buttonImage forState:UIControlStateNormal];
    //
    //    [_doneButton addTarget:self action:@selector(_handleDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_doneButton];
    
    // elapsed time and red dot
    //    _strobeView = [[PBJStrobeView alloc] initWithFrame:CGRectZero];
    //    CGRect strobeFrame = _strobeView.frame;
    //    strobeFrame.origin = CGPointMake(15.0f, 15.0f);
    //    _strobeView.frame = strobeFrame;
    //[self.view addSubview:_strobeView];
    
    // preview
    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectZero;
    previewFrame.origin = CGPointMake(0, 60.0f);
    CGFloat previewWidth = self.view.frame.size.width;
    previewFrame.size = CGSizeMake(previewWidth, previewWidth);
    //_previewView.frame = previewFrame;
    _previewView.frame = CGRectMake(0, (self.view.frame.size.height - self.view.frame.size.width * 3/4)/2, self.view.frame.size.width, self.view.frame.size.width * 3/4);
    
    // add AV layer
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    CGRect previewBounds = _previewView.layer.bounds;
    _previewLayer.bounds = previewBounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.position = CGPointMake(CGRectGetMidX(previewBounds), CGRectGetMidY(previewBounds));
    [_previewView.layer addSublayer:_previewLayer];
    [_recordBackView addSubview:_previewView];
    //[self.view addSubview:_previewView];
    
    // instruction label
    //    _instructionLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    //    _instructionLabel.textAlignment = NSTextAlignmentCenter;
    //    _instructionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    //    _instructionLabel.textColor = [UIColor whiteColor];
    //    _instructionLabel.backgroundColor = [UIColor blackColor];
    //    _instructionLabel.text = NSLocalizedString(@"Touch and hold to record", @"Instruction message for capturing video.");
    //    [_instructionLabel sizeToFit];
    //    CGPoint labelCenter = _previewView.center;
    //    labelCenter.y += ((CGRectGetHeight(_previewView.frame) * 0.5f) + 35.0f);
    //    _instructionLabel.center = labelCenter;
    //    [self.view addSubview:_instructionLabel];
    
    // gesture view to record
    UIView *gestureView = [[UIView alloc] initWithFrame:CGRectZero];
    CGRect gestureFrame = self.view.bounds;
    gestureFrame.origin = CGPointMake(0, 60.0f);
    gestureFrame.size.height -= 10.0f;
    gestureView.frame = gestureFrame;
    [self.recordBackView addSubview:gestureView];
//=============
//    BackNavigationButton *goBackButton = [[BackNavigationButton alloc] initWithFrame:CGRectMake(0, IS_IOS7 ? 20.0 : 0.0,44, 44)];
//    [goBackButton setBackgroundImage:[UIImage imageNamed:@"title_back"] forState:UIControlStateNormal];
//    [goBackButton setBackgroundImage:[UIImage imageNamed:@"title_back_click"] forState:UIControlStateHighlighted];
//    [goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.recordBackView insertSubview:goBackButton belowSubview:gestureView];
//=============
    // flip button
    _flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *flipImage = [UIImage imageNamed:@"capture_flip"];
    [_flipButton setImage:flipImage forState:UIControlStateNormal];
    
    CGRect flipFrame = _flipButton.frame;
    flipFrame.size = CGSizeMake(25.0f, 20.0f);
    flipFrame.origin = CGPointMake(10.0f, CGRectGetHeight(self.view.bounds) - 10.0f);
    _flipButton.frame = CGRectMake(viewWidth - 20.0f - 20.0f, 20.0f, 20.0f, 20.0f);
//=============
//    _flipButton.frame = CGRectMake(viewWidth - 10.0f - 44.0f, IS_IOS7 ? 20.0 : 0.0, 44.0f, 44.0f);
//=============
    [_flipButton addTarget:self action:@selector(_handleFlipButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flipButton];
    
    //设置录制按钮
    CGRect preViewRect = _previewView.frame;
    
    int igap = 1;
    int iproHeight = 1;
    recordProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, _previewView.frame.origin.y + _previewView.frame.size.height + igap, _previewView.frame.size.width, iproHeight)];
    [recordProgress setBackgroundColor:[UIColor blueColor]];
    recordProgress.transform = CGAffineTransformMakeScale(1.0f,1.0f);
    [self.recordBackView insertSubview:recordProgress belowSubview:gestureView];
    
    UIView *testview = [[UIView alloc] initWithFrame:CGRectMake(0, _previewView.frame.origin.y + _previewView.frame.size.height + igap, _previewView.frame.size.width, iproHeight)];
    [testview setBackgroundColor:[UIColor greenColor]];
    
    CGFloat buttonW = 80.0f;
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake((preViewRect.size.width - buttonW) / 2, _recordBackView.frame.origin.y + _recordBackView.frame.size.height - buttonW, buttonW, buttonW)];
    [_recordButton setImage:[UIImage imageNamed:@"video_longvideo_btn_shoot.png"] forState:UIControlStateNormal];//video_longvideo_btn_shoot_click
    [_recordButton setImage:[UIImage imageNamed:@"video_longvideo_btn_shoot_click.png"] forState:UIControlStateSelected];
    [_recordButton setImage:[UIImage imageNamed:@"video_longvideo_btn_shoot_click.png"] forState:UIControlStateHighlighted];
    _recordButton.userInteractionEnabled = YES;
    [self.recordBackView insertSubview:_recordButton belowSubview:gestureView];
    
    int showinfoheight = 20;
    showInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, recordProgress.frame.origin.y + recordProgress.frame.size.height + 10, recordProgress.frame.size.width, showinfoheight)];
    showInfo.text = @"向上移动取消视频录制";
    [showInfo setBackgroundColor:[UIColor clearColor]];
    showInfo.hidden = YES;
    [showInfo setTextColor:[UIColor whiteColor]];
    [showInfo setTextAlignment:NSTextAlignmentCenter];
    [showInfo setFont:[UIFont systemFontOfSize:12]];
    [self.recordBackView insertSubview:showInfo belowSubview:gestureView];
    
    
}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self.tabBarController.tabBar setHidden:YES];
    //[self.labelForTitle setText:@"小视频"];
    
    [self _resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PBJVision sharedInstance] stopPreview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

//录制进度
- (void)changeProgress
{
    self.recordProgress.progressTintColor = [UIColor greenColor];
    
    if ((int)self.recordProgress.progress == 1) {
        //时间到了
        [self _endCapture];
        return;
    }
    //进度条
    self.recordProgress.progress = self.recordProgress.progress + (float)0.01;
    
    //进度时间标签
    //_currentSecond = _currentSecond+0.1;
    //self.recordTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",((int)_currentSecond%3600)/60, (int)_currentSecond%60];
}


#pragma mark - private start/stop helper methods

- (void)_startCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _instructionLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [_instructionLabel removeFromSuperview];
    }];
    [[PBJVision sharedInstance] startVideoCapture];
    
    if (_recordTimer) {
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    
    islessOneSec = NO;
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
}

- (void)_pauseCapture
{
    [[PBJVision sharedInstance] pauseVideoCapture];
}

- (void)_resumeCapture
{
    [[PBJVision sharedInstance] resumeVideoCapture];
}

- (void)_endCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] endVideoCapture];
    
    //关闭定时器
    if (_recordTimer) {
        [_recordTimer invalidate];
        _recordTimer = nil;
    }
    
    if (self.recordProgress.progress < 0.1) {
        islessOneSec = YES;
    }
    self.recordProgress.progress = 0.0;
}

- (void)_reStartCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] reStartVideoCapture];
}

- (void)_resetCapture
{
    //[_strobeView stop];
    _longPressGestureRecognizer.enabled = YES;
    
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    [vision setCameraMode:PBJCameraModeVideo];
    [vision setCameraDevice:PBJCameraDeviceBack];
    [vision setCameraOrientation:PBJCameraOrientationPortrait];
    [vision setFocusMode:PBJFocusModeAutoFocus];
}

#pragma mark - UIButton

- (void)_handleFlipButton:(UIButton *)button
{
    PBJVision *vision = [PBJVision sharedInstance];
    if (vision.cameraDevice == PBJCameraDeviceBack) {
        [vision setCameraDevice:PBJCameraDeviceFront];
    } else {
        [vision setCameraDevice:PBJCameraDeviceBack];
    }
}

//- (void)_handleDoneButton:(UIButton *)button
//{
//    // resets long press
//    _longPressGestureRecognizer.enabled = NO;
//    _longPressGestureRecognizer.enabled = YES;
//
//    [self _endCapture];
//}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self _resetCapture];
}

#pragma mark - UIGestureRecognizer

- (void)_handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!_recording)
                [self _startCapture];
            else
                [self _resumeCapture];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            int mmm = 3;
            mmm++;
        }
            
        case UIGestureRecognizerStateCancelled:
        {
            int mmm = 2;
            mmm++;
        }
        case UIGestureRecognizerStateFailed:
        {
            [self _pauseCapture];
            break;
        }
        default:
            break;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_recordButton.superview];
    if (CGRectContainsPoint(_recordButton.frame, touchPoint)) {
        [self _startCapture];
        showInfo.hidden = NO;
        [_recordButton setSelected:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_recordButton.superview];
    if (CGRectContainsPoint(_recordButton.frame, touchPoint) || touchPoint.y > _recordButton.frame.origin.y) {
        self.isReStartRecord = NO;
        [self _endCapture];
        showInfo.hidden = YES;
    }else{
        self.isReStartRecord = YES;
        [self _endCapture];
        showInfo.hidden = YES;
        
    }
    [_recordButton setSelected:NO];
    
    //[_recorder stopCurrentVideoRecording];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isReStartRecord = YES;
    [self _endCapture];
    showInfo.hidden = YES;
    [_recordButton setSelected:NO];
}


#pragma mark - PBJVisionDelegate

- (void)visionSessionWillStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStop:(PBJVision *)vision
{
}

- (void)visionPreviewDidStart:(PBJVision *)vision
{
    _longPressGestureRecognizer.enabled = YES;
}

- (void)visionPreviewWillStop:(PBJVision *)vision
{
    _longPressGestureRecognizer.enabled = NO;
}

- (void)visionModeWillChange:(PBJVision *)vision
{
}

- (void)visionModeDidChange:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision cleanApertureDidChange:(CGRect)cleanAperture
{
}

- (void)visionWillStartFocus:(PBJVision *)vision
{
}

- (void)visionDidStopFocus:(PBJVision *)vision
{
}

// video capture

- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
    //[_strobeView start];
    _recording = YES;
}

- (void)visionDidPauseVideoCapture:(PBJVision *)vision
{
    //[_strobeView stop];
}

- (void)visionDidResumeVideoCapture:(PBJVision *)vision
{
    //[_strobeView start];
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    _recording = NO;
    
    if (error) {
        NSLog(@"encounted an error in video capture (%@)", error);
        return;
    }
    
    _currentVideo = videoDict;
    
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:videoPath]) {
        if (self.isReStartRecord) {
            NSError *error1 = nil;
            [fileManager removeItemAtPath:videoPath error:&error1];
            
            if (error) {
                NSLog(@"删除视频文件出错:%@", error1);
            }
        }else{
            if (islessOneSec) {
                islessOneSec = NO;
                [SVProgressHUD showErrorWithStatus: @"录制时间太短"];
//                MBProgressHUD * hud = [[MBProgressHUD alloc] init];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"录制时间太短";
//                [[[UIApplication sharedApplication].delegate window] addSubview:hud];
//                [hud show:YES];
//                [hud hide:YES afterDelay:1];
                return;
            }
            UIImage *captureImg = [PBJViewController getImage:videoPath];
            NSString *strImgUrl = [videoPath stringByReplacingOccurrencesOfString:@".mp4" withString:@".png"];
            [UIImagePNGRepresentation(captureImg) writeToFile:strImgUrl atomically:YES];
            
            
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *folderPath = [path stringByAppendingPathComponent:@"videos"];
            
            NSString *strImgFileName = [folderPath stringByAppendingPathComponent:@"captureImage"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            //NSMutableArray *allFileNameArr = [NSMutableArray array];
            
            
            if([fileManager fileExistsAtPath:strImgFileName]){
                
                NSMutableArray *imgArr = [NSMutableArray arrayWithContentsOfFile:strImgFileName];
                NSString *strVideoName = [[NSFileManager defaultManager] displayNameAtPath:videoPath];
                [imgArr addObject:[strVideoName stringByReplacingOccurrencesOfString:@".mp4" withString:@".png"]];
                [imgArr writeToFile:strImgFileName atomically:YES];
                
            }else{
                
                NSMutableArray *imgArr = [NSMutableArray array];
                NSString *strVideoName = [[NSFileManager defaultManager] displayNameAtPath:videoPath];
                [imgArr addObject:[strVideoName stringByReplacingOccurrencesOfString:@".mp4" withString:@".png"]];
                [[NSFileManager defaultManager] createFileAtPath:strImgFileName contents:nil attributes:nil];
                [imgArr writeToFile:strImgFileName atomically:YES];
            }
            [self checkinVideoTopic:videoPath];
            
        }
    }
    
    //    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    //    [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Saved!" message: @"Saved to the camera roll."
    //                                                       delegate:self
    //                                              cancelButtonTitle:nil
    //                                              otherButtonTitles:@"OK", nil];
    //        [alert show];
    //    }];
}

-(void) checkinVideoTopic:(NSString *)strVideoName
{
    if ([self.delegate respondsToSelector:@selector(didFinishRecordVideoFile:)]) {
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate didFinishRecordVideoFile:strVideoName];
    }
    
}

+(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    //AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(1, 1);
    //CMTime time = CMTimeMakeWithSeconds(0.0, 20);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}


@end
