//
//  TEEditPersonalDataViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-9-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEMultipleSectionTableViewController.h"

@class TEUserModel;

@interface TEEditPersonalDataViewController : TEMultipleSectionTableViewController <UITextFieldDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) TEUserModel *userModel;
@end
