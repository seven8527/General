//
//  EXGroupMemberViewController.h
//  Express
//
//  Created by owen on 15/12/1.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "UIBaseViewController.h"
#import "DialogueListEntity.h"

@interface EXGroupMemberViewController : UIBaseViewController
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) DialogueListEntity *  dialogueListEntity;
@property (nonatomic, strong) NSMutableArray * memberArray;

@end
