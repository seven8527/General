//
//  TEMedicalPreviewCell.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEMedicalPreviewCell : UITableViewCell
@property (nonatomic, strong) UILabel *itemLabel; // 病历项目
@property (nonatomic, strong) UIScrollView *imageScrollView; // 病历
@end
