//
//  MYSDoctorSearchViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"
#import "MYSSearchDoctorModel.h"

@protocol MYSDoctorSearchViewControllerDelegate <NSObject>
@optional
- (void)doctorSerachViewDidSelectDoctor:(MYSSearchDoctorModel *)searchDoctorModel;

@end

@interface MYSDoctorSearchViewController : MYSBaseTableViewController
@property (nonatomic, strong) NSString *doctorTotal; // 医生总数
@property (nonatomic, strong) NSMutableArray *doctorArray; // 医生数组，保存搜索结果
@property (nonatomic, copy) NSString *searchText; // 搜索词
@property (nonatomic, weak) id <MYSDoctorSearchViewControllerDelegate> delegate;
@end
