//
//  TETumourDetailViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POHorizontalList.h"
#import "TEBaseViewController.h"

@interface TETumourDetailViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate, POHorizontalListDelegate>
@property (nonatomic, strong) NSString *diseaseId; // 疾病ID
@property (nonatomic, strong) NSString *name; // 疾病中文名
@end
