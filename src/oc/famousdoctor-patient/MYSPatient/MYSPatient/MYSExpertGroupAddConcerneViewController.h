//
//  MYSExpertGroupAddConcerneViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-12.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
#import "MYSExpertGroupDoctor.h"

@protocol  MYSExpertGroupAddConcerneViewDelegate <NSObject>
- (void)expertGroupAddConcerneView:(UITableView *)expertGroupAddConcerneView didSelectedWith:(id)model;
@end

@interface MYSExpertGroupAddConcerneViewController : MYSBaseViewController
@property (nonatomic, weak) id <MYSExpertGroupAddConcerneViewDelegate> delegate;
@end
