//
//  PersionViewController.h
//  XA-FoucsClub
//
//  Created by Owen on 15/6/12.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersionViewController : UIViewController<UITableViewDataSource , UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong)  UITableView *tabView;
@property (nonatomic, strong)   NSMutableArray * InfoArray;
@property (nonatomic, assign)  int indexOfPage;
@property (nonatomic, strong) NSNumber *  idOfInfo;
@property (nonatomic, strong)  UISearchBar *searchBar;
@end
