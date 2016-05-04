//
//  BNListOfNewsViewController.h
//  BigNews
//
//  Created by owen on 15/8/14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNBaseViewController.h"

@interface BNListOfNewsViewController : BNBaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSString * titles;
@property (nonatomic, strong) NSString * url;
@end
