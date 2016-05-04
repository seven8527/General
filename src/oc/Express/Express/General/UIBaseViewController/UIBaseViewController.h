//
//  UIBaseViewController.h
//  Express
//
//  Created by Owen on 15/10/3.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBaseViewController : UIViewController

- (void)setLeftBarImgBtn:(NSString *)imageName;
- (void)setLeftBarTextBtn:(NSString *)text;
- (void)leftBtnAction:(id)sender;


- (void)setRightBarImgBtn:(NSString *)imageName;
- (void)setRightBarTextBtn:(NSString *)text;
- (void)rightBtnAction:(id)sender;

@end
