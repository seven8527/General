//
//  TEPhoneConsultViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEReusableTextFieldViewController.h"
#import "TEChoosePatientViewController.h"
#import "TEChoosePatientDataViewController.h"
#import "TEPhoneConsultInstructionCell.h"
#import "TEBaseViewController.h"

@interface TEPhoneConsultViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate, TEReusableTextViewViewControllerDelegate, TEChoosePatientViewControllerDelegate, TEChoosePatientDataViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSString *expertId; // 专家id
@end
