//
//  TEChoosePayModeViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TEChoosePayModeViewControllerDelegate
- (void)didSelectedPayModeId:(NSInteger)payModeId payModeName:(NSString *)payModeName;
@end

@interface TEChoosePayModeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) id<TEChoosePayModeViewControllerDelegate> delegate;
@end
