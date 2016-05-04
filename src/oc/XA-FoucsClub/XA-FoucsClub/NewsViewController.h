//
//  NewsViewController.h
//  XA-FoucsClub
//
//  Created by Owen on 15/6/12.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *arrayList;
@property (nonatomic, strong) UITableView *tabView;

@end
