//
//  TEChoosePatientViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TEChoosePatientViewControllerDelegate
- (void)didSelectedPatientId:(NSString *)patientId patientName:(NSString *)patientName;
@end

@interface TEChoosePatientViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) id<TEChoosePatientViewControllerDelegate> delegate;
@end
