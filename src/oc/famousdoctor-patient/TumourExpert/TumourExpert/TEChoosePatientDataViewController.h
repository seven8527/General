//
//  TEChoosePatientDataViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TEChoosePatientDataViewControllerDelegate
- (void)didSelectedPatientDataId:(NSString *)patientDataId patientDataName:(NSString *)patientDataName;
@end

@interface TEChoosePatientDataViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) id<TEChoosePatientDataViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *patientId; // 患者Id
@end

