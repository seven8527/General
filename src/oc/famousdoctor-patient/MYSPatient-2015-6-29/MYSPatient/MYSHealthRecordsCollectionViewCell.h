//
//  MYSHealthRecordsCollectionViewCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSHealthRecordsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) id model;
@property (nonatomic, assign) NSInteger healthRecordType; // 0 代表血压  1 代表 血糖 2 代表 体重
@end
