//
//  MYSExpertGroupConsultSelectUserCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultSelectUserCell.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MYSExpertGroupConsultSelectUserCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation MYSExpertGroupConsultSelectUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
        
        self.isHadNameLabel = YES;
        // 头像
        UIImageView *iconImageView = [UIImageView newAutoLayoutView];
        iconImageView.hidden = YES;
        iconImageView.layer.cornerRadius = 15;
        iconImageView.clipsToBounds = YES;
        self.iconImageView = iconImageView;
        [self.contentView addSubview:iconImageView];
        
        // 姓名
        UILabel *nameLabel = [UILabel newAutoLayoutView];
        nameLabel.hidden = YES;
        nameLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentRight;
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        
    }
    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        
       
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
//        [self.nameLabel autoSetDimension:ALDimensionHeight toSize:42];
//        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];

        
        
        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
//        [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.iconImageView autoSetDimensionsToSize:CGSizeMake(30, 30)];
         [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:6];
        self.didSetupConstraints = YES;
    }
    
    
}

- (void)setIsHadNameLabel:(BOOL)isHadNameLabel
{
    _isHadNameLabel = isHadNameLabel;
}


- (void)setModel:(id)model
{
    _model = model;
    if ([model patientName]) {
////        if ([model patientIcon]) {
//            self.iconImageView.hidden = NO;
//           [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[[model patientIcon] stringByReplacingOccurrencesOfString:@".jpg"withString:@"_150X150.jpg"]] placeholderImage:[UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:[model patientSex] andBirthday:[model patientBirthday]]]];
////        } else {
////            self.iconImageView.hidden = YES;
////        }
        
        self.nameLabel.hidden = NO;
        self.detailTextLabel.hidden = YES;
        if (self.isHadNameLabel) {
            self.nameLabel.text = [model patientName];
        } else {
            self.nameLabel.text = @"";
        }
        
//        CGSize nameSize = [MYSFoundationCommon sizeWithText:self.nameLabel.text  withFont:self.nameLabel.font];
//        if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
            [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//        } else {
//            [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
//        }
        //        if ([model patientIcon]) {
        self.iconImageView.hidden = NO;
//        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[[model patientIcon] stringByReplacingOccurrencesOfString:@".jpg"withString:@"_150X150.jpg"]] placeholderImage:[UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:[model patientSex] andBirthday:[model patientBirthday]]]];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[model patientIcon]] placeholderImage:[UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:[model patientSex] andBirthday:[model patientBirthday]]]];

        //        } else {
        //            self.iconImageView.hidden = YES;
        //        }
//        [self.nameLabel autoSetDimension:ALDimensionWidth toSize:nameSize.width];
    } else {
        self.detailTextLabel.hidden = NO;
        self.nameLabel.hidden = YES;
        self.iconImageView.hidden = YES;
    }
}

- (void)setPatientModel:(MYSExpertGroupPatientModel *)patientModel
{
    _patientModel = patientModel;
    if ([patientModel patientName]) {
        self.nameLabel.hidden = NO;
        self.detailTextLabel.hidden = YES;
        if (self.isHadNameLabel) {
            self.nameLabel.text = [patientModel patientName];
        } else {
            self.nameLabel.text = @"";
        }
        
//        CGSize nameSize = [MYSFoundationCommon sizeWithText:self.nameLabel.text  withFont:self.nameLabel.font];
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        self.iconImageView.hidden = NO;
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[[patientModel patientIcon] stringByReplacingOccurrencesOfString:@".jpg"withString:@"_150X150.jpg"]] placeholderImage:[UIImage imageNamed:[MYSFoundationCommon placeHolderImageWithGender:[patientModel patientSex] andBirthday:[patientModel patientBirthday]]]];
    } else {
        self.detailTextLabel.hidden = NO;
        self.nameLabel.hidden = YES;
        self.iconImageView.hidden = YES;
    }
}

- (void)setPatientPic:(UIImage *)patientPic
{
    self.iconImageView.hidden = NO;
    self.nameLabel.hidden = NO;
    _patientPic = patientPic;
    CGSize nameSize = [MYSFoundationCommon sizeWithText:self.nameLabel.text  withFont:self.nameLabel.font];
     [self.nameLabel autoSetDimension:ALDimensionWidth toSize:nameSize.width];
    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    } else {
        [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    }
   

    self.iconImageView.image = patientPic;
}

@end
