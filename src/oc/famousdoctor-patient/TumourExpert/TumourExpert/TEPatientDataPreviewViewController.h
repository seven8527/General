//
//  TEPatientDataPreviewViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  TEPatientDataPreviewViewControllerDelegate
- (void)thePatientDataNameDidRevampWithText:(NSString *)patientDataName;
@end
@interface TEPatientDataPreviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, strong) NSString *patientDataId; // 患者资料Id
@property (nonatomic, strong) id <TEPatientDataPreviewViewControllerDelegate> delegate;
@end
