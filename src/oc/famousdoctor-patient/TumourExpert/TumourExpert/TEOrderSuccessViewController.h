//
//  TEOrderSuccessViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEOrderModel.h"
#import "TEBaseTableViewController.h"

@interface TEOrderSuccessViewController : TEBaseTableViewController

@property (nonatomic, strong)TEOrderModel *orderModel;
@property (nonatomic, assign) int TEConfirmConsultType;
@property (nonatomic, copy) NSString *patientName; // 患者
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *payType;
-(void)paymentResult:(NSString *)result;
@end
