//
//  TEEditPatientViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseTableViewController.h"

@interface TEEditPatientViewController : TEBaseTableViewController  <UITextFieldDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) NSString *patientId; // 患者id
@property (nonatomic, strong) NSString *archiveNumber; // 档案号
@end
