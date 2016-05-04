//
//  TEExpertDetailViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-22.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseTableViewController.h"

@interface TEExpertDetailViewController : TEBaseTableViewController <TEExpertDetailViewControllerProtocol>
@property (nonatomic, strong) NSString *expertId; // 专家Id
@end
