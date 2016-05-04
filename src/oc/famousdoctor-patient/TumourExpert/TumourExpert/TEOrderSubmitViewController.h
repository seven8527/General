//
//  TEOrderSubmitViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEAskModel.h"
#import "TEChoosePayModeViewController.h"
#import "TEBaseViewController.h"

@interface TEOrderSubmitViewController : TEBaseViewController <UITableViewDataSource, UITableViewDelegate, TEChoosePayModeViewControllerDelegate>
@property (nonatomic, strong) TEAskModel *askModel;
@property (nonatomic, strong) NSString *consultType;
@property (nonatomic, strong) NSString *patientId;
@property (nonatomic, strong) NSString *patientDataId;
@end
