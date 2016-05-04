//
//  HealthInformationViewController+Request.h
//  MYSPatient
//
//  Created by lyc on 15/5/20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "HealthInformationViewController.h"

@interface HealthInformationViewController (Request)

#pragma mark 咨询头条请求
- (void)sendZXTTRequest;

#pragma mark 健康饮食请求
- (void)sendJKYSRequest;

@end
