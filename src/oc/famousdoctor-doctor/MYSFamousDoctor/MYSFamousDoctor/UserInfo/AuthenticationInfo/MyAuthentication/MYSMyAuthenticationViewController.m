//
//  MYSMyAuthenticationViewController.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMyAuthenticationViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface MYSMyAuthenticationViewController ()

@end

@implementation MYSMyAuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"相关证件";
    NSURL *URL = [NSURL URLWithString:mURL];
    [mImage sd_setImageWithURL:URL];
}

- (void)sendValue:(NSString *)url
{
    mURL = url;
}

- (IBAction)imageClick:(id)sender
{
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.hiddenPhotoLoadingView = NO;
    browser.currentPhotoIndex = 0;
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:mURL];
    [photos addObject:photo];
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
