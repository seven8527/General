//
//  MYSExpertGroupConsultDoctorCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultDoctorCell.h"
#import "UIColor+Hex.h"
#import "MYSFoundationCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MYSExpertGroupConsultDoctorCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *consultTypeLabel;
@property (nonatomic, weak) UIImageView *hospitalImageView;
@property (nonatomic, weak) UIButton *hospitalButton;
@property (nonatomic, weak) UIImageView *departmentImageView;
@property (nonatomic, weak) UIButton *departmentButton;
@end

@implementation MYSExpertGroupConsultDoctorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
        
        // 头像
        UIImageView *iconImageView = [UIImageView newAutoLayoutView];
        iconImageView.layer.cornerRadius = 30;
        iconImageView.clipsToBounds = YES;
        self.iconImageView = iconImageView;
        [self.contentView addSubview:iconImageView];
        
        // 姓名
        UILabel *nameLabel = [UILabel newAutoLayoutView];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        // 价格
        UILabel *priceLabel = [UILabel newAutoLayoutView];
//        priceLabel.textColor = [UIColor orangeColor];
        priceLabel.layer.cornerRadius = 3;
        priceLabel.font = [UIFont systemFontOfSize:12];
        priceLabel.clipsToBounds = YES;
        self.priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
        
        
        UILabel *consultTypeLabel = [UILabel newAutoLayoutView];
        consultTypeLabel.font = [UIFont systemFontOfSize:12];
        consultTypeLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        self.consultTypeLabel = consultTypeLabel;
        [self.contentView addSubview:consultTypeLabel];
        
        UIImageView *hospitalImageView = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:hospitalImageView];
        self.hospitalImageView = hospitalImageView;
        
        UIButton *hospitalButton = [UIButton newAutoLayoutView];
        hospitalButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [hospitalButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
        hospitalButton.userInteractionEnabled = NO;
        self.hospitalButton = hospitalButton;
        [self.contentView addSubview:hospitalButton];
        
        
        UIImageView *departmentImageView = [UIImageView newAutoLayoutView];
        [self.contentView addSubview:departmentImageView];
        self.departmentImageView = departmentImageView;
        
        UIButton *departmentButton = [UIButton newAutoLayoutView];
        departmentButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [departmentButton setTitleColor:[UIColor colorFromHexRGB:K9E9E9EColor] forState:UIControlStateNormal];
        departmentButton.userInteractionEnabled = NO;
        self.departmentButton = departmentButton;
        [self.contentView addSubview:departmentButton];
        
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
//        [self.nameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.priceLabel withOffset:-15];
        
        
        [self.hospitalImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:15];
        [self.hospitalImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:12];
        [self.hospitalImageView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        
        
        [self.hospitalButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.hospitalImageView withOffset:5];
        [self.hospitalButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:12];
        [self.hospitalButton autoSetDimension:ALDimensionHeight toSize:12];
        
        [self.departmentImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:15];
        [self.departmentImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
        [self.departmentImageView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        
        
        [self.departmentButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.departmentImageView withOffset:5];
        [self.departmentButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15];
        [self.departmentButton autoSetDimension:ALDimensionHeight toSize:11];

        
       
        [self.consultTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:16];
        [self.consultTypeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [self.consultTypeLabel autoSetDimension:ALDimensionHeight toSize:13];

        [self.priceLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:17];
        [self.priceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel withOffset:11];
        [self.priceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.consultTypeLabel withOffset:-4];
        [self.priceLabel autoSetDimension:ALDimensionHeight toSize:16];
        
        
        self.didSetupConstraints = YES;
    }
    
    
}


- (void)setAskModel:(MYSExpertGroupAskModel *)askModel
{
    _askModel = askModel;
    
    self.nameLabel.text = askModel.expertName;
    
    
    [self.hospitalButton setTitle:askModel.hospitalName forState:UIControlStateNormal];
    
    [self.departmentButton setTitle:askModel.department forState:UIControlStateNormal];
    
     self.consultTypeLabel.text = self.consultType;
    CGSize consultTypeSize = [MYSFoundationCommon sizeWithText:self.consultTypeLabel.text withFont:self.consultTypeLabel.font];
    
    [self.consultTypeLabel autoSetDimension:ALDimensionWidth toSize:consultTypeSize.width];
    
    NSArray *words = @[@{[NSString stringWithFormat:@"￥%@/",askModel.price]: [UIFont systemFontOfSize:16]},
                       @{@"次": [UIFont systemFontOfSize:12]},];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *wordToColorMapping in words) {
        for (NSString *word in wordToColorMapping) {
            UIFont *font = [wordToColorMapping objectForKey:word];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor colorFromHexRGB:KEF8004Color], NSFontAttributeName : font};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
            [string appendAttributedString:subString];
        }
    }

    self.priceLabel.attributedText = string;

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:askModel.expertIcon] placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
    
    self.departmentImageView.image = [UIImage imageNamed:@"doctor_icon2_"];
    
    self.hospitalImageView.image = [UIImage imageNamed:@"doctor_icon1_"];
}

- (void)setOrderDetails:(MYSPersonalOrderDetailsModel *)orderDetails
{
    _orderDetails = orderDetails;
    
    self.nameLabel.text = orderDetails.expertName;
    
    
    [self.hospitalButton setTitle:orderDetails.hospital forState:UIControlStateNormal];
    
    [self.departmentButton setTitle:orderDetails.department forState:UIControlStateNormal];
    
    self.consultTypeLabel.text = self.consultType;
    CGSize consultTypeSize = [MYSFoundationCommon sizeWithText:self.consultTypeLabel.text withFont:self.consultTypeLabel.font];
    
    [self.consultTypeLabel autoSetDimension:ALDimensionWidth toSize:consultTypeSize.width];
    
    NSArray *words = @[@{[NSString stringWithFormat:@"￥%@/",orderDetails.truePrice]: [UIFont systemFontOfSize:16]},
                       @{@"次": [UIFont systemFontOfSize:12]},];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *wordToColorMapping in words) {
        for (NSString *word in wordToColorMapping) {
            UIFont *font = [wordToColorMapping objectForKey:word];
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor colorFromHexRGB:KEF8004Color], NSFontAttributeName : font};
            NSAttributedString *subString = [[NSAttributedString alloc] initWithString:word attributes:attributes];
            [string appendAttributedString:subString];
        }
    }
    
    self.priceLabel.attributedText = string;
    
    
    self.departmentImageView.image = [UIImage imageNamed:@"doctor_icon2_"];
    
    self.hospitalImageView.image = [UIImage imageNamed:@"doctor_icon1_"];

}

- (void)setDoctorPic:(NSString *)doctorPic
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:doctorPic] placeholderImage:[UIImage imageNamed:@"favicon_doctor_man"]];
}

- (void)setConsultType:(NSString *)consultType
{
    _consultType = consultType;
}

@end
