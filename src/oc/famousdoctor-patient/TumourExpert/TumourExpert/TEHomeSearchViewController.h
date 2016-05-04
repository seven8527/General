//
//  TEHomeSearchViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-15.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseEmptyTableViewController.h"

@class TEHomeSearchViewController;
@protocol TEHomeSearchViewControllerDelegate <NSObject>
- (void)homeSearchViewController:(TEHomeSearchViewController *)viewControler searchWithText:(NSString *)text;
@end

@interface TEHomeSearchViewController : TEBaseEmptyTableViewController
@property (nonatomic, weak) id <TEHomeSearchViewControllerDelegate> delegate;
@end
