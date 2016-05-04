//
//  EXDialogueGroupSettingViewController.h
//  Express
//
//  Created by owen on 15/11/27.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "UIBaseViewController.h"

@interface EXDialogueGroupSettingViewController : UIBaseViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic, strong) NSString * groupId;
@property (nonatomic, strong) NSString * owerId; //群主id
@property (nonatomic, strong) UITableView *tableView;

@end
