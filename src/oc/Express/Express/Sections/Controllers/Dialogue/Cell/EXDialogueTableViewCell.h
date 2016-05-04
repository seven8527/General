//
//  EXDialogueTableViewCell.h
//  Express
//
//  Created by owen on 15/11/10.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXDialogueTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgLogo;
@property (nonatomic, strong) UILabel     *name;
@property (nonatomic, strong) UILabel     *content;
@property (nonatomic, strong) UILabel     *time;
@property (nonatomic, strong) UILabel     *count;

//两个成员的组
@property (nonatomic, strong) UIImageView * group2_imgLogo;
@property (nonatomic, strong) UIImageView * imgCell1;
@property (nonatomic, strong) UIImageView * imgCell2;


//三 四 五个成员的组
@property (nonatomic, strong) UIImageView * group3_imgLogo;
@property (nonatomic, strong) UIImageView * group4_imgLogo;
@property (nonatomic, strong) UIImageView * group5_imgLogo;


@property (nonatomic, strong) UIImageView * imgCell3_1;
@property (nonatomic, strong) UIImageView * imgCell3_2;
@property (nonatomic, strong) UIImageView * imgCell3_3;

@property (nonatomic, strong) UIImageView * imgCell4_1;
@property (nonatomic, strong) UIImageView * imgCell4_2;
@property (nonatomic, strong) UIImageView * imgCell4_3;
@property (nonatomic, strong) UIImageView * imgCell4_4;

@property (nonatomic, strong) UIImageView * imgCell5_1;
@property (nonatomic, strong) UIImageView * imgCell5_2;
@property (nonatomic, strong) UIImageView * imgCell5_3;
@property (nonatomic, strong) UIImageView * imgCell5_4;
@property (nonatomic, strong) UIImageView * imgCell5_5;
@end
