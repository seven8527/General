//
//  MYSDiseaseSearchViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"

@protocol MYSDiseaseSearchViewControllerDelegate <NSObject>
@optional
- (void)diseaseSerachViewDidSelectDiseaseId:(NSString *)diseaseId;

@end

@interface MYSDiseaseSearchViewController : MYSBaseTableViewController
@property (nonatomic, strong) NSString *diseaseTotal; // 疾病总数
@property (nonatomic, strong) NSMutableArray *diseaseArray; // 疾病数组，保存搜索结果
@property (nonatomic, copy) NSString *searchText; // 搜索词
@property (nonatomic, weak) id <MYSDiseaseSearchViewControllerDelegate> delegate;
@end
