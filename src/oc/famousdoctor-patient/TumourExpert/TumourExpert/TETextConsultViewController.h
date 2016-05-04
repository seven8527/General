//
//  TETextConsultViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEChoosePatientViewController.h"
#import "TEChoosePatientDataViewController.h"
#import "TETextConsultInstructionCell.h"
#import "TEBaseViewController.h"

@interface TETextConsultViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate, TEChoosePatientViewControllerDelegate, TEChoosePatientDataViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSString *expertId; // 专家id
@end
