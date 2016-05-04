//
//  MYSAddMedicalDataCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSAddMedicalDataCellDelegate <NSObject>
- (void)picWillDeleteWithType:(NSString *)type andInteger:(NSInteger)integer;

- (void)picWillAddWithType:(NSString *)type withCurrentCount:(NSInteger)currentCount;
@end

@interface MYSAddMedicalDataCell : UITableViewCell
@property (nonatomic, weak) UILabel *itemLabel; // 病历项目
@property (nonatomic, weak) UIButton *plusButton; // 增加图片
@property (nonatomic, weak) UITableView *imageTableView; // 图片
@property (nonatomic, strong) NSMutableArray *picArray; // 图片数组
@property (nonatomic, copy) NSString *type; // 所属
@property (nonatomic, assign) BOOL isImage; // 图片数组是否为image 是为image  不是为路径
@property (nonatomic, weak) id <MYSAddMedicalDataCellDelegate> delegate;
@end
