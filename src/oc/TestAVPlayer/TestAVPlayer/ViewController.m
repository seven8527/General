//
//  ViewController.m
//  TestAVPlayer
//
//  Created by owen on 16/1/12.
//  Copyright © 2016年 owen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    AVPlayer *player;
    BOOL    isPlaying;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    isPlaying  = NO;
    NSURL *url = [NSURL URLWithString:@"http://fdfs.xmcdn.com/group16/M06/E0/35/wKgDalaPlGOg-9WTADwXLZjNmaA826.mp3"];
    
    player = [[AVPlayer alloc]initWithURL:url];
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
