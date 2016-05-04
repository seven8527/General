//
//  TESeekAreaViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseViewController.h"

@protocol TESeekAreaViewControllerDelegate <NSObject>
- (void)didSelectedAreaId:(NSString *)areaId areaName:(NSString *)areaName;
@end

@interface TESeekAreaViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <TESeekAreaViewControllerDelegate> delegate;
@end
