//
//  TEPaymentConsultDetailsViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@interface TEPaymentConsultDetailsViewController : TEBaseViewController
@property (nonatomic, assign) int TEConfirmConsultType;
@property (nonatomic, copy) NSString *patientName; // 患者
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, strong) NSString *orderNumber; //订单号
@end
