//
//  TEPatientBasicDataViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEReusableTextFieldViewController.h"
#import "TEReusableTextViewViewController.h"
#import "TEBaseViewController.h"
#import "TEBaseTableViewController.h"

@interface TEPatientBasicDataViewController : TEBaseTableViewController <UITextFieldDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) NSString *patientId; // 患者id
@end
