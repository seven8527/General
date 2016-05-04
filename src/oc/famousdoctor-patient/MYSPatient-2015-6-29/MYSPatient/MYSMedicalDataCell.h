//
//  MYSMedicalDataCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class MYSMedicalDataCell;
//@protocol MYSMedicalDataCellDelegete <NSObject>
//
//- (void)medicalDataCell:(MYSMedicalDataCell *)medicalDataCell showImageWithIndex:(NSInteger *)index andSection:(NSInteger *)section;
//
//@end

@interface MYSMedicalDataCell : UITableViewCell
@property (nonatomic, weak) UILabel *itemLabel; // 病历项目
@property (nonatomic, weak) UITableView *imageTableView; // 图片
@property (nonatomic, strong) NSArray *picArray; // 图片数组
//@property (nonatomic, weak) id <MYSMedicalDataCellDelegete> delegate;
//@property (nonatomic, assign) NSInteger *orgionSection;
@end
