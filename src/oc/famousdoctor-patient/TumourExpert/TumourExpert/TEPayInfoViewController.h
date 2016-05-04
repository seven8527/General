//
//  TEPayInfoViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEMultipleSectionTableViewController.h"

@interface TEPayInfoViewController : TEMultipleSectionTableViewController
@property (nonatomic, copy) NSString *payStatue;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *payPrice;
@property (nonatomic, copy) NSString *payModeName;
@end
