//
//  TMVideoButton.h
//  Twatch
//
//  Created by WangBo on 15/8/10.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMVideoButton : UIButton

@property (nonatomic, strong) NSString *strVideoName;

@property (nonatomic, strong) NSString *strVideoCaptureImageName;
@property (nonatomic, assign) NSInteger  rowNum;
@property (nonatomic, assign) id  checkBtn;

@end
