//
//  TEConsultQuestionViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@interface TEConsultQuestionViewController : TEBaseViewController
@property (nonatomic, strong) NSString *consultId; // 咨询Id
@property (nonatomic, strong) NSString *nextQuestion; // 咨询的是第几个问题
@end
