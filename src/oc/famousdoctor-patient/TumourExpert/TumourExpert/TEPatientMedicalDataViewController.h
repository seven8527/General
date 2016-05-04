//
//  TEPatientMedicalDataViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@interface TEPatientMedicalDataViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *patientId; // 患者id
@property (nonatomic, strong) NSString *patientDataId; // 患者资料id
@end
