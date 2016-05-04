//
//  TECompleteConsultDetailsViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@interface TECompleteConsultDetailsViewController : TEBaseViewController
@property (nonatomic, assign) int TEConfirmConsultType;
@property (nonatomic, strong) NSString *orderNumber; //订单号
@end
