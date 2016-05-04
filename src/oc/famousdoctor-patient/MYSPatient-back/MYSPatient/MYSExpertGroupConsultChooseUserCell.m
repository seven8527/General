//
//  MYSExpertGroupConsultChooseUserCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultChooseUserCell.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MYSFoundationCommon.h"

@interface MYSExpertGroupConsultChooseUserCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation MYSExpertGroupConsultChooseUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
        
        
        // 头像
        UIImageView *iconImageView = [UIImageView newAutoLayoutView];
        iconImageView.layer.cornerRadius = 15;
        iconImageView.clipsToBounds = YES;
        self.iconImageView = iconImageView;
        [self.contentView addSubview:iconImageView];
        
        // 姓名
        UILabel *nameLabel = [UILabel newAutoLayoutView];
        nameLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        UIButton *checkButton = [UIButton newAutoLayoutView];
        checkButton.layer.cornerRadius = 10;
        checkButton.clipsToBounds = YES;
        checkButton.userInteractionEnabled = NO;
        [checkButton setImage:[UIImage imageNamed:@"consult_radio2_"] forState:UIControlStateNormal];
        [checkButton setImage:[UIImage imageNamed:@"consult_radio1_"] forState:UIControlStateSelected];
//        [checkButton addTarget:self action:@selector(clickCheckButton) forControlEvents:UIControlEventTouchUpInside];
        self.checkButton = checkButton;
        [self.contentView addSubview:checkButton];
        
        
    }
    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:9];
        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.iconImageView autoSetDimensionsToSize:CGSizeMake(30, 30)];

        
        [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:17];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [self.nameLabel autoSetDimension:ALDimensionWidth toSize:100];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
        
        [self.checkButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
        [self.checkButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [self.checkButton autoSetDimensionsToSize:CGSizeMake(20, 20)];
        

        self.didSetupConstraints = YES;
    }
}

- (void)setPatientModel:(MYSExpertGroupPatientModel *)patientModel
{
    _patientModel = patientModel;
    
//    LOG(@"%@",[patientModel.patientIcon stringByReplacingOccurrencesOfString:@".jpg"withString:@"_150x150.jpg"]);
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:patientModel.patientIcon] placeholderImage:[UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:patientModel.patientSex andBirthday:patientModel.patientBirthday]]];
    
    self.nameLabel.text = patientModel.patientName;
    
    
}

//- (void)clickCheckButton {
//    self.checkButton.selected = !self.checkButton.selected;
//    //    self.isSelect = self.checkButton.selected;
//    if (self.checkButton.selected == YES) {
////        if ( [self.delegate respondsToSelector:@selector(expertGroupConsultMedicalRecordDidSelectWithIndex:)]) {
////            [self.delegate expertGroupConsultMedicalRecordDidSelectWithIndex:self.tag];
////        }
//    } else {
////        if ([self.delegate respondsToSelector:@selector(expertGroupConsultMedicalRecordDidDeselectWithIndex:)]) {
////            [self.delegate expertGroupConsultMedicalRecordDidDeselectWithIndex:self.tag];
////        }
//    }
//}

@end
