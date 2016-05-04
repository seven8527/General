//
//  MYSNetConsultationViewController.h
//  MYSFamousDoctor
//
//  网络咨询
//
//  Created by lyc on 15/4/10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"
#import "MYSNetConsultationTableViewCell.h"

@interface MYSNetConsultationViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MYSNetConsultationTableViewCellDelegate>
{
    // 完成按钮
    IBOutlet UIButton *completeBtn;
    // 未完成按钮
    IBOutlet UIButton *unCompleteBtn;
    
    IBOutlet UITableView *mTableView;
    
    // 存放未完成的数据
    NSMutableArray *mUnFinishData;
    // 存放已完成的数据
    NSMutableArray *mFinishData;
    
    BOOL selectUnFinishFlag;
    NSInteger pageNum;
}

@end
