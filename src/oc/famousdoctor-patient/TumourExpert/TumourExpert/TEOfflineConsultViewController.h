//
//  TEOfflineConsultViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseViewController.h"
#import "TEChoosePatientViewController.h"
#import "TEChoosePatientDataViewController.h"
#import "TETextConsultInstructionCell.h"


@interface TEOfflineConsultViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate, TEChoosePatientViewControllerDelegate, TEChoosePatientDataViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSString *expertId; // 专家id
@end
