//
//  EXCreateGroupViewController.h
//  Express
//
//  Created by owen on 15/11/27.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "UIBaseViewController.h"
#import "DialogueListEntity.h"

@protocol EXCreateGroupViewControllerDelegate <NSObject>

-(void) selectedFriDic:(NSMutableArray *)dic;

@end


@interface EXCreateGroupViewController : UIBaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * friendsDic;
@property (nonatomic, assign) bool  isCreate; //是否为创建群， 不是创建群， 传进来得是已经添加的成员（这些成员的状态不能改变的）
@property (nonatomic, strong) NSMutableArray * selectedFriDic; //已经选中的。
@property (nonatomic, strong) NSMutableArray * unavailableFriDic; // 不可选 的好友
@property (nonatomic, strong) NSString * groupid; // 群id

@property (nonatomic, retain) id<EXCreateGroupViewControllerDelegate>  delegate;
@property (nonatomic, strong) DialogueListEntity*  dialogueListEntity;

@end
