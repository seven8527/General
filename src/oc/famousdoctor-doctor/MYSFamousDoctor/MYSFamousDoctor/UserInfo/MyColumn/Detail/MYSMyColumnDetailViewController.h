//
//  MYSMyColumnDetailViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSMyColumnDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    
    id mDic;
    NSString *mDcaid;
}

- (void)sendValue:(NSString *)dcaid;

@end
