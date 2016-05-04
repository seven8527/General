//
//  TEEditConsultDetailsViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"
#import "TEOrderDetailsModel.h"

@class TEEditConsultDetailsViewController;

@protocol TEEditConsultDetailsViewControllerDelegate
@end

@interface TEEditConsultDetailsViewController : TEBaseViewController 
@property (nonatomic, assign) int TEConfirmConsultType;
@property (nonatomic, strong) TEOrderDetailsModel *orderDetails;
@property (nonatomic, strong) NSString *orderNumber; //订单号
@end
