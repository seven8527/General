//
//  MYSMedicalSignalImageCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSMedicalSignalImageCell : UITableViewCell
@property (nonatomic, weak) UIImageView *picImageView; // 病例单个图片
@property (nonatomic, copy) NSString *picurl;
@end
