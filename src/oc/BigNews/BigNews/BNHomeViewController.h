//
//  BNHomeViewController.h
//  BigNews
//
//  Created by Owen on 15-8-13.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNBaseViewController.h"

@interface BNHomeViewController : BNBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataArray;
@end
