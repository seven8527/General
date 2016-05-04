//
//  MYSPhoneConsultationViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"
#import "MYSPhoneConsultationTableViewCell.h"
#import "MYSPhoneConsultationTableViewCell1.h"

@interface MYSPhoneConsultationViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MYSPhoneConsultationTableViewCellDelegate, MYSPhoneConsultationTableViewCell1Delegate>
{
    IBOutlet UITableView *mTableView;
    
    // 已通话按钮
    IBOutlet UIButton *callBtn;
    // 未通话按钮
    IBOutlet UIButton *unCallBtn;
    
    // 存放已拨打数据
    NSMutableArray *mCallData;
    // 存放未拨打数据
    NSMutableArray *mUnCallData;
    
    BOOL selectUnCallFlag;
    NSInteger pageNum;
}

@end
