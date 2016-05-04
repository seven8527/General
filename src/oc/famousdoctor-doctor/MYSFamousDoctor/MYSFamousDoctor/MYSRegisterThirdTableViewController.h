//
//  MYSRegisterThirdTableViewController.h
//  MYSFamousDoctor
//
//  Created by yanwb on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSRegisterThirdTableViewController : UITableViewController
{
    // 医生名称
    NSString *mName;
    // 医生医院
    NSString *mHospitol;
    // 医生科室
    NSString *mDepartment;
    // 医生电话
    NSString *mPhone;
    // 核实电话（固话）
    NSString *mTelephone;
    
    NSInteger selectImageIndex;
    
    NSString *headImageURL;
    NSString *certificateImageURL;
}

- (void)sendValue:(NSString *)name hospitol:(NSString *)hospitol department:(NSString *)department phone:(NSString *)phone telephone:(NSString *)telephone;

@end
