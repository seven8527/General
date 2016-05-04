//
//  DialogueViewController.h
//  Express
//
//  Created by owen on 15/11/3.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "UIBaseViewController.h"
#import "EXCreateGroupViewController.h"

@interface EXDialogueViewController : UIBaseViewController<UITableViewDelegate, UITableViewDataSource, EXCreateGroupViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dialogueDict;
@end
