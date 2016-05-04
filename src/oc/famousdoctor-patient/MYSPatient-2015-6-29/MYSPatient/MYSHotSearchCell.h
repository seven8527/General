//
//  MYSHotSearchCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSHotSearchCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *hotSearchArray; // 搜索数组
@property (nonatomic, weak) UITableView *hotSearchTableView; // 热门搜索
@end
