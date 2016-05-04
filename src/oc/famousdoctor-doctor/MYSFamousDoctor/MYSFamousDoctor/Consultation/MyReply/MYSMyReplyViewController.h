//
//  MYSMyReplyViewController.h
//  MYSFamousDoctor
//
//  我的回复
//
//  Created by lyc on 15/4/14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSMyReplyViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    
    NSMutableArray *mData;
    
    // 页码
    NSInteger pageNum;
    // 总条数
    NSInteger totalNum;
}

@end
