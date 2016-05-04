//
//  MYSPersonalCheckOrderDetailsViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"

@interface MYSPersonalCheckOrderDetailsViewController : MYSBaseTableViewController
@property (nonatomic, copy) NSString *orderId; // 订单号
@property (nonatomic, copy) NSString *consultType; // 咨询类型
@property (nonatomic, copy) NSString *doctorPic; // 医生头像
@property (nonatomic, strong) UIImage *patientImage; // 患者头像
@end
