//
//  TEOrderViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlixLibService.h"
#import "TEBaseEmptyTableViewController.h"

@interface TEOrderViewController : TEBaseEmptyTableViewController

@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。

-(void)paymentResult:(NSString *)result;

@end

