//
//  MYSFaceToFaceViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"
#import "MYSFaceToFaceTableViewCell.h"

@interface MYSFaceToFaceViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MYSFaceToFaceTableViewCellDelegate>
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
