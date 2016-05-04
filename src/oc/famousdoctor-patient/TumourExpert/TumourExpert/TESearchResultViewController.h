//
//  TESearchResultViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseEmptyTableViewController.h"

@interface TESearchResultViewController : TEBaseEmptyTableViewController  
@property (nonatomic, strong) NSString *keyword;  // 关键字
@property (nonatomic, strong) NSString *searchType; // 搜索类型
@property (nonatomic, strong) NSString *searchId; // 搜索Id
@end
