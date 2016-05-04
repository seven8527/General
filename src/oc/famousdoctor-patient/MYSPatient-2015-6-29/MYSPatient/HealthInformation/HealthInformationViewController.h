//
//  HealthInformationViewController.h
//  MYSPatient
//
//  健康资讯
//
//  Created by lyc on 15/5/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
#import "MJRefresh.h"

@interface HealthInformationViewController : MYSBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    // 咨询头条按钮
    IBOutlet UIButton *zxttBtn;
    // 健康饮食按钮
    IBOutlet UIButton *jkysBtn;
    
    IBOutlet UIView *zxttLineView;
    IBOutlet UIView *jkysLineView;
    
    // 0:咨询头条  1:健康饮食
    NSInteger selectIndex;
    
    // 资讯头条数据存储数组
    NSMutableArray *zxttDataArr;
    // 健康饮食数据存储数组
    NSMutableArray *jkysDataArr;
    
    NSInteger zxttPageNum;
    NSInteger jkysPageNum;
}

@end
