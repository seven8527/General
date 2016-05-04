//
//  TEPicMedicalCell.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEPicMedicalCell : UITableViewCell
@property (nonatomic, weak) UIImageView *picImageView; // 病例单个图片
@property (nonatomic, copy) NSString *picurl;
@property (nonatomic, copy) NSString *isContainHttp;
@end
