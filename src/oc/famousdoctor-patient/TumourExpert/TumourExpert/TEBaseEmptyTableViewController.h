//
//  TEBaseEmptyTableViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-7.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface TEBaseEmptyTableViewController : TEBaseTableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSString *titleForEmpty;
@end
