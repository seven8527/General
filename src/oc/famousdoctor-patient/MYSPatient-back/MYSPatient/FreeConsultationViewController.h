//
//  FreeConsultationViewController.h
//  MYSPatient
//
//  免费咨询
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
#import "MJRefresh.h"

@interface FreeConsultationViewController : MYSBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIButton *freeBtn;
    
    // 0:最新回复  1:活跃医生
    NSInteger selectIndex;
    
    // 最新回复按钮
    IBOutlet UIButton *newReplayBtn;
    // 活跃医生按钮
    IBOutlet UIButton *doctorBtn;
    
    IBOutlet UITableView *mTableView;
    
    NSInteger newReplayPageNum;
    NSInteger doctorPageNum;
    
    // 存放最新回复数据
    NSMutableArray *newReplayArr;
    // 存放活跃医生数据
    NSMutableArray *doctorArr;
}

@end
