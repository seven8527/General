//
//  TMVideoPickerViewController.h
//  Twatch
//
//  Created by WangBo on 15/8/7.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBaseViewController.h"
#import "PBJViewController.h"

@protocol TMVideoPickerViewControllerDelegate<NSObject>

-(void)didFinishSelectVideoFileName:(NSString *)strVideoPathAndName;

@end

@interface TMVideoPickerViewController : UIBaseViewController<UITableViewDataSource, UITableViewDelegate, PBJViewControllerDelegate>

@property(nonatomic, strong)  IBOutlet UITableView *tableview;

@property(nonatomic, strong)  NSMutableArray *videoArr;

@property(nonatomic, assign) id<TMVideoPickerViewControllerDelegate> delegate;

@end
