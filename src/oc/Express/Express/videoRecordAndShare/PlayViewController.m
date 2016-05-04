//
//  PlayViewController.m
//
//
//  Created by WangBo on 15/8/10.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
//#import "UINavigationController+MyNavigationViewController.h"


#define DEVICE_BOUNDS [[UIScreen mainScreen] applicationFrame]
#define DEVICE_SIZE [[UIScreen mainScreen] applicationFrame].size
#define DEVICE_OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define DELTA_Y (DEVICE_OS_VERSION >= 7.0f? 20.0f : 0.0f)

@interface PlayViewController ()

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NSURL *videoFileURL;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) UIView *playerBackView;
@property (strong, nonatomic) UILabel *showInfo;
//@property (strong, nonatomic) NSTimer *timer;

@end

@implementation PlayViewController
@synthesize showInfo;

- (id)init:(NSURL *)videoFileURL
{
    self = [super init];
    if (self) {
        self.videoFileURL = videoFileURL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:16 / 255.0f green:16 / 255.0f blue:16 / 255.0f alpha:1.0f];
    
    //    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    //    UIImage *img = [PlayViewController getImage:self.videoFileURL];
    //    [imv setImage:img];
    //    [self.view addSubview:imv];
    
    //self.playerBackView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height)];
    self.playerBackView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.playerBackView setBackgroundColor:[UIColor blackColor]];
    //    [checkinBtn setTitle:@"提交" forState:UIControlStateNormal];
    //    [checkinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [checkinBtn setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateDisabled];
    //    [checkinBtn addTarget:self action:@selector(actionForCheckIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playerBackView];
    [self initPlayLayer];
    
    //    self.playButton = [[UIButton alloc] initWithFrame:_playerLayer.frame];
    //    [_playButton setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    //    [_playButton addTarget:self action:@selector(pressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.playerBackView addSubview:_playButton];
    
    int showinfoheight = 20;
    showInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, self.playerLayer.frame.origin.y + self.playerLayer.frame.size.height + 10, self.playerLayer.frame.size.width, showinfoheight)];
    showInfo.text = @"轻触退出";
    [showInfo setBackgroundColor:[UIColor clearColor]];
    showInfo.hidden = YES;
    [showInfo setTextColor:[UIColor whiteColor]];
    [showInfo setTextAlignment:NSTextAlignmentCenter];
    [showInfo setFont:[UIFont systemFontOfSize:12]];
    [self.playerBackView addSubview:showInfo];
    
    self.backButton = [[UIButton alloc] initWithFrame:self.playerBackView.bounds];
    [_backButton setBackgroundColor:[UIColor clearColor]];
    [_backButton addTarget:self action:@selector(pressBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerBackView addSubview:self.backButton];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFire:) userInfo:nil repeats:NO];
}


-(void)timeFire:(NSTimer *)timer
{
    //showInfo.hidden = NO;
    [timer invalidate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];
    //[self.labelForTitle setText:@"视频"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)initPlayLayer
{
    if (!_videoFileURL) {
        return;
    }
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:_videoFileURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, (self.playerBackView.layer.bounds.size.height - (DEVICE_SIZE.width * 4 / 3))/2, DEVICE_SIZE.width, DEVICE_SIZE.width * 4 / 3);
    if (DEVICE_SIZE.height > 480) {
        _playerLayer.frame = CGRectMake(0, (self.playerBackView.layer.bounds.size.height - (DEVICE_SIZE.width * 4 / 3))/2, DEVICE_SIZE.width, DEVICE_SIZE.width * 4 / 3);
    } else {
        _playerLayer.frame = CGRectMake(0, (DEVICE_SIZE.height - 400)/2, DEVICE_SIZE.width, 400);
    }
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerBackView.layer addSublayer:_playerLayer];
    [self.player play];
}

//- (void)initPlayLayer
//{
//    if (!_videoFileURL) {
//        return;
//    }
//
//    //    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:_videoFileURL];
//    //    [mp.view setFrame:CGRectMake(0, 0, 320, 240)];
//    //    [mp.view setBackgroundColor:[UIColor redColor]];
//    //    [self.playerBackView addSubview:mp.view];
//    //[mp play];
//
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:_videoFileURL];
//    //MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:_videoFileURL];
//    if (player) {
//
//
//        //初始视频播放状态监听事件
//        //[self installMovieNotificationObservers];
//
//        //设置视频视图，开始播放
//        [player setMovieSourceType:MPMovieSourceTypeFile];
//        [player setControlStyle:MPMovieControlStyleNone];
//        player.repeatMode = MPMovieRepeatModeNone;// 是否重播
//        player.scalingMode = MPMovieScalingModeFill;
//        [player.view setFrame:self.view.bounds];
//        player.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//        player.backgroundView.backgroundColor = [UIColor blackColor];
//        [self.playerBackView insertSubview:player.view atIndex:0];
//        [player play];
//    }
//
//}


- (void)pressPlayButton:(UIButton *)button
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

- (void)pressBackButton:(UIButton *)button
{
    [self.player pause];
    if (self.navigationController) {
        //[self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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


#pragma mark - PlayEndNotification
- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        //_playButton.alpha = 1.0f;
         showInfo.hidden = NO;
        [_playerItem seekToTime:kCMTimeZero];
        [_player play];
    }];
}

@end
