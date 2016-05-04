//
//  MYSPatientQuestionsViewController.h
//  MYSFamousDoctor
//
//  患者提问
//
//  Created by lyc on 15/4/14.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"
#import "MYSPatientQuestionsTableViewCell.h"

@interface MYSPatientQuestionsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MYSPatientQuestionsTableViewCellDelegate>
{
    IBOutlet UITableView *mTableView;
    
    NSMutableArray *mData;
    
    // 页码
    NSInteger pageNum;
    // 总条数
    NSInteger totalNum;
}

@end
