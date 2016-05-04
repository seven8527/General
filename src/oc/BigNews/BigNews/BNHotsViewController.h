//
//  BNHotsViewController.h
//  BigNews
//
//  Created by Owen on 15-8-14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNBaseViewController.h"

@interface BNHotsViewController : BNBaseViewController<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotsDataArray;
@property (nonatomic, strong) NSMutableArray *pointDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISegmentedControl *segment;
@end
