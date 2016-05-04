//
//  EXGroupCardViewController.m
//  Express
//
//  Created by owen on 15/12/1.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXGroupCardViewController.h"
#import "QRCodeGenerator.h"

@interface EXGroupCardViewController ()

@end

@implementation EXGroupCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"群名片"];
    [self setLeftBarImgBtn:nil];
    [self configUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configUI
{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, (SCREEN_HEIGHT-SCREEN_WIDTH/2)/2, SCREEN_WIDTH/2, SCREEN_WIDTH/2)];
    UIImage *image = [QRCodeGenerator qrImageForString:_groupId imageSize:SCREEN_WIDTH/2];
    [imageview setImage:image];
    [self.view addSubview:imageview];
    
}

@end
