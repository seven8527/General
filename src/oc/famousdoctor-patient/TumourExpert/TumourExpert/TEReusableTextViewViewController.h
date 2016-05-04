//
//  TEReusableTextViewViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@protocol TEReusableTextViewViewControllerDelegate
- (void)didFinishedTextViewContent:(NSString *)content byFlag:(NSString *)flag;
@end

@interface TEReusableTextViewViewController : TEBaseViewController
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *exampleContent;
@property (nonatomic, assign) id <TEReusableTextViewViewControllerDelegate> delegate;
@end
