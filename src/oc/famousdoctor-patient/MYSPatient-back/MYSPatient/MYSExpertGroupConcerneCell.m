//
//  MYSExpertGroupConcerneCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-12.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConcerneCell.h"
#import "MYSFoundationCommon.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSSearchDoctorModel.h"
#import "MYSExpertGroupDoctorModel.h"

@interface  MYSExpertGroupConcerneCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UITextField *positionalLabel;
@property (nonatomic, weak) UIImageView *hospitalImageView;
@property (nonatomic, weak) UIButton *hospitalButton;
@property (nonatomic, weak) UIImageView *depatrmentImageView;
@property (nonatomic, weak) UIButton *departmentButton;
@property (nonatomic, weak) UIButton *picAskButton;
@property (nonatomic, weak) UIButton *phoneAskButton;
@property (nonatomic, weak) UIButton *offLineAskButton;
@end

@implementation MYSExpertGroupConcerneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
        UIImageView *iconImageView = [UIImageView newAutoLayoutView];
        iconImageView.layer.cornerRadius = 30;
        iconImageView.clipsToBounds = YES;
        self.iconImageView = iconImageView;
        [self.contentView addSubview:iconImageView];
        
        UILabel *nameLabel = [UILabel newAutoLayoutView];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        UITextField *positionalLabel = [UITextField newAutoLayoutView];
        positionalLabel.textAlignment = NSTextAlignmentCenter;
        positionalLabel.textColor = [UIColor colorFromHexRGB:KFFFFFFColor];
        positionalLabel.layer.cornerRadius = 3;
        positionalLabel.font = [UIFont systemFontOfSize:12];
        positionalLabel.clipsToBounds = YES;
        positionalLabel.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 1)];
        positionalLabel.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 1)];
        positionalLabel.rightViewMode = UITextFieldViewModeAlways;
        positionalLabel.leftViewMode = UITextFieldViewModeAlways;
        positionalLabel.userInteractionEnabled = NO;
        self.positionalLabel = positionalLabel;
        [self.contentView addSubview:positionalLabel];
        
        
        UIImageView *hospiatalImageView = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:hospiatalImageView];
        hospiatalImageView.image = [UIImage imageNamed:@"doctor_icon1_"];
        self.hospitalImageView = hospiatalImageView;
        
        UIButton *hospitalButton = [UIButton newAutoLayoutView];
        hospitalButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [hospitalButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
        hospitalButton.userInteractionEnabled = NO;
        self.hospitalButton = hospitalButton;
        [self.contentView addSubview:hospitalButton];
        
        
        UIImageView *departmentImageView = [UIImageView newAutoLayoutView];
        departmentImageView.image = [UIImage imageNamed:@"doctor_icon2_"];
        [self.contentView addSubview:departmentImageView];
        self.depatrmentImageView = departmentImageView;
        
        UIButton *departmentButton = [UIButton newAutoLayoutView];
        departmentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [departmentButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
        departmentButton.userInteractionEnabled = NO;
        self.departmentButton = departmentButton;
        [self.contentView addSubview:departmentButton];

        UIButton *concerneButton = [UIButton newAutoLayoutView];
        concerneButton.hidden = YES;
        [concerneButton setImage:[UIImage imageNamed:@"doctor_button_add_"] forState:UIControlStateNormal];
        self.concerneButton = concerneButton;
        [self.contentView addSubview:concerneButton];
        
        
        UILabel *concerneLabel = [UILabel newAutoLayoutView];
        concerneLabel.hidden = YES;
        concerneLabel.text = @"已关注";
        concerneLabel.font = [UIFont systemFontOfSize:12];
        concerneLabel.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
        self.concerneLabel = concerneLabel;
        [self.contentView addSubview:concerneLabel];
/*
        // 网络咨询按钮
        UIButton *picAskButton = [UIButton newAutoLayoutView];
        picAskButton.tag = 0;
        [picAskButton setTitle:@"" forState:UIControlStateNormal];
        [picAskButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [picAskButton.layer setBorderWidth:1];
       [picAskButton.layer setBorderColor:[UIColor colorFromHexRGB:K00907FColor].CGColor];
        picAskButton.layer.cornerRadius = 5;
        [picAskButton setTitleColor:[UIColor colorFromHexRGB:K00907FColor] forState:UIControlStateNormal];
        [picAskButton addTarget:self action:@selector(clickPicAskButton) forControlEvents:UIControlEventTouchUpInside];
        self.picAskButton = picAskButton;
        [self.contentView addSubview:picAskButton];
        
        // 电话咨询按钮
        UIButton *phoneAskButton = [UIButton newAutoLayoutView];
        phoneAskButton.tag = 1;
        [phoneAskButton setTitle:@"" forState:UIControlStateNormal];
        [phoneAskButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [phoneAskButton.layer setBorderWidth:1];
        [phoneAskButton.layer setBorderColor:[UIColor colorFromHexRGB:K69AF41Color].CGColor];
        phoneAskButton.layer.cornerRadius = 5;
        [phoneAskButton setTitleColor:[UIColor colorFromHexRGB:K69AF41Color] forState:UIControlStateNormal];
        [phoneAskButton addTarget:self action:@selector(clickPhoneAskButton) forControlEvents:UIControlEventTouchUpInside];
        self.phoneAskButton = phoneAskButton;
        [self.contentView addSubview:phoneAskButton];
        
        // 面对面咨询按钮
        UIButton *offLineAskButton = [UIButton newAutoLayoutView];
        offLineAskButton.tag = 2;
        offLineAskButton.layer.cornerRadius = 5;
        [offLineAskButton setTitle:@"" forState:UIControlStateNormal];
        [offLineAskButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [offLineAskButton.layer setBorderWidth:1];
        [offLineAskButton.layer setBorderColor:[UIColor colorFromHexRGB:KEF8004Color].CGColor];
        [offLineAskButton setTitleColor:[UIColor colorFromHexRGB:KEF8004Color] forState:UIControlStateNormal];
        [offLineAskButton addTarget:self action:@selector(clickOfflineAskButton) forControlEvents:UIControlEventTouchUpInside];
        self.offLineAskButton = offLineAskButton;
     [self.contentView addSubview:offLineAskButton];
 */

    }
 

    [self updateViewConstraints];
    
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {

        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.iconImageView autoSetDimensionsToSize:CGSizeMake(60, 60)];
        
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:15];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
        [self.nameLabel autoSetDimension:ALDimensionHeight toSize:15];
        
        [self.hospitalImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:15];
        [self.hospitalImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:12];
        [self.hospitalImageView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        
        
        [self.hospitalButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.hospitalImageView withOffset:5];
        [self.hospitalButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:12];
        [self.hospitalButton autoSetDimension:ALDimensionHeight toSize:12];
        
        [self.depatrmentImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:15];
        [self.depatrmentImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.hospitalButton withOffset:10];
        [self.depatrmentImageView autoSetDimensionsToSize:CGSizeMake(11, 11)];

        
        [self.departmentButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.depatrmentImageView withOffset:5];
        [self.departmentButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.hospitalButton withOffset:10];
        [self.departmentButton autoSetDimension:ALDimensionHeight toSize:11];
        
        [self.concerneButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.concerneButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:18];
        [self.concerneButton autoSetDimensionsToSize:CGSizeMake(13, 13)];
        
        [self.concerneLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.concerneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:18];
        [self.concerneLabel autoSetDimensionsToSize:CGSizeMake(40, 13)];
        
        [self.positionalLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:16];
        [self.positionalLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel withOffset:11];
        [self.positionalLabel autoSetDimension:ALDimensionHeight toSize:16];
        
        [self.picAskButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.iconImageView withOffset:10];
        [self.picAskButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.picAskButton autoSetDimensionsToSize:CGSizeMake((kScreen_Width - 50) / 3, 35)];
        
        [self.phoneAskButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.iconImageView withOffset:10];
        [self.phoneAskButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.picAskButton  withOffset:10];
        [self.phoneAskButton autoSetDimensionsToSize:CGSizeMake((kScreen_Width - 50) / 3, 35)];
        
        [self.offLineAskButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.iconImageView withOffset:10];
        [self.offLineAskButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.phoneAskButton withOffset:10];
        [self.offLineAskButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.offLineAskButton autoSetDimensionsToSize:CGSizeMake((kScreen_Width - 50) / 3, 35)];
    
        self.didSetupConstraints = YES;
    }
   
    
}

- (void)setDoctorModel:(MYSSearchDoctorModel *)doctorModel
{
    _doctorModel = doctorModel;
    
    self.nameLabel.text = doctorModel.doctorName;
   
    [self.hospitalButton setTitle:doctorModel.hospital forState:UIControlStateNormal];
    [self.departmentButton setTitle:doctorModel.department forState:UIControlStateNormal];
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:doctorModel.headPortrait] placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
     self.positionalLabel.text  = [doctorModel.qualifications stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.positionalLabel.backgroundColor = [UIColor colorFromHexRGB:KEF8004Color];


    if (doctorModel.qualifications) {
        self.positionalLabel.hidden = NO;
    } else {
        self.positionalLabel.hidden = YES;
    }
}

- (void)setExpertGroupDoctorModel:(MYSExpertGroupDoctorModel *)expertGroupDoctorModel
{
    _expertGroupDoctorModel = expertGroupDoctorModel;
    
    self.nameLabel.text = expertGroupDoctorModel.doctorName;
    
    [self.hospitalButton setTitle:expertGroupDoctorModel.hospital forState:UIControlStateNormal];
    [self.departmentButton setTitle:expertGroupDoctorModel.department forState:UIControlStateNormal];
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:expertGroupDoctorModel.headPortrait] placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
    self.positionalLabel.text  = [expertGroupDoctorModel.qualifications stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.positionalLabel.backgroundColor = [UIColor colorFromHexRGB:KEF8004Color];
    
    if (expertGroupDoctorModel.qualifications) {
        self.positionalLabel.hidden = NO;
    } else {
        self.positionalLabel.hidden = YES;
    }
}

- (void)clickPicAskButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"expertGroupClickPicAskButton" object:self.expertGroupDoctorModel userInfo:nil];
}

- (void)clickPhoneAskButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"expertGroupClickPhoneAskButton" object:self.expertGroupDoctorModel userInfo:nil];
}

- (void)clickOfflineAskButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"expertGroupClickOfflineAskButton" object:self.expertGroupDoctorModel userInfo:nil];
}

@end
