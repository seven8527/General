//
//  MYSBaseTableViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSBaseTableViewController : UITableViewController



/**
 *  大量数据的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  加载本地或者网络数据源
 */
- (void)loadDataSource;

@end
