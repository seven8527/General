//
//  TEBaseViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-3.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TEBarButtonItemActionBlock)(void);

typedef NS_ENUM(NSInteger, TEBarbuttonItemStyle) {
    TEBarbuttonItemStyleSetting = 0,
    TEBarbuttonItemStyleMore,
    TEBarbuttonItemStyleCamera,
};

@interface TEBaseViewController : UIViewController

/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;

/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading;

/**
 *  显示带有某个文本加载的loading
 *
 *  @param text 目标文本
 */
- (void)showLoadingWithText:(NSString *)text;

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view;

/**
 *  显示成功的HUD
 */
- (void)showSuccess;
/**
 *  显示错误的HUD
 */
- (void)showError;

/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏
 */
- (void)hideLoading;

- (void)configureBarbuttonItemStyle:(TEBarbuttonItemStyle)style action:(TEBarButtonItemActionBlock)action;

@end
