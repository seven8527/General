//
//  HealthInfomationDetailViewController.h
//  MYSPatient
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"

@interface HealthInfomationDetailViewController : MYSBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    
    NSArray *mData;
    
//    NSString *mID;
}
@property (nonatomic ,strong) NSString * mID;
@end
