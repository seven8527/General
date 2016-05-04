//
//  MYSUserInfoViewController.h
//  MYSFamousDoctor
//
//  个人信息
//
//  Created by lyc on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSUserInfoViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    IBOutlet UITableView *mTableView;
    
    // 主任医师TopCell
    IBOutlet UITableViewCell *zhurenTopCell;
    
    // 主任医师TopCell
    IBOutlet UITableViewCell *famousTopCell;
    
    IBOutlet UITableViewCell *updateCell;
    IBOutlet UITableViewCell *aboutUsCell;
    
    IBOutlet UITableViewCell *bottomCell;
    
    NSMutableArray *mData;
}

@end
