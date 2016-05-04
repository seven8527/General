//
//  TEReusableTextFieldViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@protocol TEReusableTextFieldViewControllerDelegate
- (void)didFinishedTextFieldContent:(NSString *)content byFlag:(NSString *)flag;
@end

@interface TEReusableTextFieldViewController : TEBaseViewController <UITextFieldDelegate>
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) NSInteger keyboardType;
@property (nonatomic, assign) id <TEReusableTextFieldViewControllerDelegate> delegate;
@end
