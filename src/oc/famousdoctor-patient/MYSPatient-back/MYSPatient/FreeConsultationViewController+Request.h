//
//  FreeConsultationViewController+Request.h
//  MYSPatient
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "FreeConsultationViewController.h"

@interface FreeConsultationViewController (Request)

#pragma mark 最新回复请求
- (void)sendNewReplayRequest;

#pragma mark 活跃医生请求
- (void)sendDoctorRequest;

@end
