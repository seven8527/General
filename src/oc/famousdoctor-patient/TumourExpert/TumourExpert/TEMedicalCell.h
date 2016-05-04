//
//  TEMedicalCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TEMedicalCellDelegate <NSObject>
- (void)picWillDeleteWithType:(NSString *)type andInteger:(NSInteger)integer;
@end
@interface TEMedicalCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UILabel *itemLabel; // 病历项目
@property (nonatomic, weak) UIButton *plusButton; // 增加图片
@property (nonatomic, weak) UITableView *imageTableView; // 图片
@property (nonatomic, strong) NSArray *picArray; // 图片数组
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *isContainHttp;
@property (nonatomic, weak) id <TEMedicalCellDelegate> delegate;
@end
