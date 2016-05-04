//
//  BNBaseViewController.h
//  BigNews
//
//  Created by Owen on 15-8-12.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNBaseViewController : UIViewController

- (void)setLeftBarImgBtn:(NSString *)imageName;
- (void)setLeftBarTextBtn:(NSString *)text;
- (void)leftBtnAction:(id)sender;


- (void)setRightBarImgBtn:(NSString *)imageName;
- (void)setRightBarTextBtn:(NSString *)text;
- (void)rightBtnAction:(id)sender;

@end
