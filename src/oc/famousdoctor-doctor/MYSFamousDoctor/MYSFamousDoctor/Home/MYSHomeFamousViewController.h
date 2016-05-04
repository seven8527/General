//
//  MYSHomeFamousViewController.h
//  MYSFamousDoctor
//
//  名医汇-Home页面
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSHomeFamousViewController : BaseViewController <UIAlertViewDelegate>
{
    // 医师照片
    IBOutlet UIImageView *doctorImageView;
    // 医师名称
    IBOutlet UILabel *doctorName;
    // 医师单位
    IBOutlet UILabel *doctorUnit;
    // 网络咨询
    IBOutlet UILabel *net;
    // 电话咨询
    IBOutlet UILabel *call;
    // 面对面
    IBOutlet UILabel *faceToFace;
    
    BOOL isFirst;
}

@end
