//
//  MYSExpertGroupConcernedViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-12.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
#import "MYSExpertGroupDoctor.h"

@protocol  MYSExpertGroupConcerneViewDelegate <NSObject>
- (void)expertGroupConcerneView:(UITableView *)expertGroupAddConcerneView didSelectedWith:(id)model;
@end

@interface MYSExpertGroupConcernedViewController : MYSBaseViewController
@property (nonatomic, weak) id <MYSExpertGroupConcerneViewDelegate> delegate;
@property (nonatomic, strong) MYSExpertGroupDoctor *expertGroupDoctor;
@property (nonatomic, strong) NSMutableArray *departmentArray; // 科室数组
@end
