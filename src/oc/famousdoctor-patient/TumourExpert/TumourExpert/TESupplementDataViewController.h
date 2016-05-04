//
//  TESupplementDataViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@interface TESupplementDataViewController : TEBaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSString *patientDataId; // 患者资料id
@end
