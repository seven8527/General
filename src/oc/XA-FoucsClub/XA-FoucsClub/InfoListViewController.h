//
//  InfoListViewController.h
//  XA-FoucsClub
//
//  Created by Owen on 15/6/17.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  UITableView *tabView;
@property (nonatomic, strong)   NSMutableArray * InfoArray;
@property (nonatomic, assign)  int indexOfPage;
@property (nonatomic, strong) NSNumber *  idOfInfo;
@end
