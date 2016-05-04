//
//  MYSHomeDirectorViewController.h
//  MYSFamousDoctor
//
//  主任医师团-Home页面
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSHomeDirectorViewController : BaseViewController <UIAlertViewDelegate>
{
    // 医师照片
    IBOutlet UIImageView *doctorImageView;
    // 医师名称
    IBOutlet UILabel *doctorName;
    // 医师单位
    IBOutlet UILabel *doctorUnit;
    // 患者提问数
    IBOutlet UILabel *patientQuestions;
    // 我的回复数
    IBOutlet UILabel *myReply;
    
    BOOL isFirst;
}

@end
