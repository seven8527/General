//
//  TEPhoneConsultDetailViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@interface TEPhoneConsultDetailViewController : TEBaseViewController
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *consultId; // 咨询Id
@end
