//
//  MYSExpertGroupConfirmExpandCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-31.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConfirmExpandCell.h"
#import "MYSFoundationCommon.h"
#import "UIColor+Hex.h"

@interface MYSExpertGroupConfirmExpandCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UIImageView *statusArrowImageView;

@end

@implementation MYSExpertGroupConfirmExpandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.didSetupConstraints = NO;
//        self.isOpen = NO;
        
        UILabel *titleTipLabel = [[UILabel alloc] init];
        self.titleTipLabel = titleTipLabel;
        titleTipLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        [self.contentView addSubview:titleTipLabel];
        
        
        
        
        UILabel *contnetLabel = [[UILabel alloc] init];
        contnetLabel.numberOfLines = 0;
        contnetLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        [self.contentView addSubview:contnetLabel];
        self.contentLabel = contnetLabel;

        
        UIView *bottomView = [[UIView alloc] init];
        [self.contentView addSubview:bottomView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottomView)];
        [bottomView addGestureRecognizer:tap];
        self.bottomView = bottomView;
        
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        statusLabel.text = @"展开";
        statusLabel.font = [UIFont systemFontOfSize:12];
        self.statusLabel = statusLabel;
        statusLabel.textAlignment = NSTextAlignmentRight;
        [bottomView addSubview:statusLabel];
        
        UIImageView *statusArrowImageView = [[UIImageView alloc] init];
        self.statusArrowImageView = statusArrowImageView;
        [bottomView addSubview:statusArrowImageView];

        
    }
//    [self updateViewConstraints];
    return self;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.titleTipLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
        [self.titleTipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13];
        [self.titleTipLabel autoSetDimensionsToSize:CGSizeMake(kScreen_Width - 20, 15)];
        
        
        [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
        [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        
        [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
        [self.bottomView autoSetDimension:ALDimensionWidth toSize:200];
        //        [self.bottomView autoSetDimension:ALDimensionHeight toSize:20];
        
        
        [self.statusLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.statusLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.statusArrowImageView withOffset:-10];
        [self.statusLabel autoSetDimension:ALDimensionWidth toSize:80];
        [self.statusLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        
        
        [self.statusArrowImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.statusArrowImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:4];
        [self.statusArrowImageView autoSetDimension:ALDimensionWidth toSize:12.5];
        //        [self.statusArrowImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.statusArrowImageView autoSetDimension:ALDimensionHeight toSize:8];
       
        self.didSetupConstraints = YES;
    }
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    if (self.isOpen) {
        self.statusLabel.text = @"关闭";
        self.statusArrowImageView.image = [UIImage imageNamed:@"doctor_button_down_"];
    } else {
         self.statusArrowImageView.image = [UIImage imageNamed:@"doctor_button_up_"];
        self.statusLabel.text = @"展开";
    }

}

- (void)setExpandHeight:(CGFloat)expandHeight
{
    _expandHeight = expandHeight;
}

- (void)setTipStr:(NSString *)tipStr
{
    _tipStr = tipStr;
    
    self.titleTipLabel.text = tipStr;
}

- (void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    
    CGSize contentStrSize = [MYSFoundationCommon sizeWithText:self.contentStr withFont:self.contentLabel.font constrainedToSize:CGSizeMake(kScreen_Width - 20, MAXFLOAT)];
    
    self.titleTipLabel.frame = CGRectMake(13, 13, kScreen_Width - 26, 20);
    
    if(self.isOpen == NO) {
        if (contentStrSize.height > self.expandHeight) {
            self.bottomView.hidden = NO;
            self.contentLabel.frame = CGRectMake(13, CGRectGetMaxY(self.titleTipLabel.frame), kScreen_Width - 20, self.expandHeight);
            self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), kScreen_Width - 20, 20);
            self.statusArrowImageView.frame = CGRectMake(kScreen_Width - 25, 4, 12.5, 12.5);
            self.statusLabel.frame = CGRectMake(0, 0, kScreen_Width - 25, 20);
            
        } else {
            self.bottomView.hidden = NO;
            self.contentLabel.frame = CGRectMake(13, CGRectGetMaxY(self.titleTipLabel.frame), kScreen_Width - 20, contentStrSize.height);
            self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), kScreen_Width - 20, 0);
            self.statusArrowImageView.frame = CGRectMake(kScreen_Width - 25, 4, 12.5, 0);
            self.statusLabel.frame = CGRectMake(0, 0, kScreen_Width - 25, 0);
            self.bottomView.hidden = YES;
        }
    } else {
        if (contentStrSize.height > self.expandHeight) {
            self.bottomView.hidden = NO;
            self.contentLabel.frame = CGRectMake(13, CGRectGetMaxY(self.titleTipLabel.frame), kScreen_Width - 20, contentStrSize.height);
            self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), kScreen_Width - 20, 20);
            self.statusArrowImageView.frame = CGRectMake(kScreen_Width - 25, 4, 12.5, 12.5);
            self.statusLabel.frame = CGRectMake(0, 0, kScreen_Width - 25, 20);

            self.bottomView.hidden = NO;
        } else {
            self.bottomView.hidden = NO;
            self.contentLabel.frame = CGRectMake(13, CGRectGetMaxY(self.titleTipLabel.frame), kScreen_Width - 20, contentStrSize.height);
            self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), kScreen_Width - 20, 0);
            self.statusArrowImageView.frame = CGRectMake(kScreen_Width - 25, 4, 12.5, 0);
            self.statusLabel.frame = CGRectMake(0, 0, kScreen_Width - 25, 0);
            self.bottomView.hidden = YES;
        }

    }

    
    
//    if(self.isOpen == NO) {
//        if (contentStrSize.height > self.expandHeight) {
//            self.bottomView.hidden = NO;
////            [self.contentLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomView withOffset:0];
////            [self.contentLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomView withOffset:20];
////            [self.contentLabel autoSetDimension:ALDimensionHeight toSize:self.expandHeight];
////            [self.bottomView autoSetDimension:ALDimensionHeight toSize:20];
//            [self.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentLabel withOffset:0];
//        
//        } else {
////            [self.contentLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomView withOffset:0];
//////            [self.contentLabel autoSetDimension:ALDimensionHeight toSize:30];
////            [self.bottomView autoSetDimension:ALDimensionHeight toSize:0];
//            self.bottomView.hidden = YES;
//        }
//    } else {
//        if (contentStrSize.height > self.expandHeight) {
//            
//           [self.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentLabel withOffset:0];
////            [self.contentLabel autoSetDimension:ALDimensionHeight toSize:self.expandHeight];
////            [self.contentLabel autoSetDimension:ALDimensionHeight toSize:contentStrSize.height];
////             [self.bottomView autoSetDimension:ALDimensionHeight toSize:20];
//            
//            self.bottomView.hidden = NO;
//        } else {
//            [self.contentLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomView withOffset:0];
//            [self.bottomView autoSetDimension:ALDimensionHeight toSize:0];
//            self.bottomView.hidden = YES;
//        }
//
//    }
    
     self.contentLabel.text = contentStr;
   
}


- (void)tapBottomView
{
    self.isOpen = !self.isOpen;
    if ([self.delegate respondsToSelector:@selector(expertGroupConfirmExpandCellDidClickStatusWithIndex:andStatusOpen:)]) {
        [self.delegate expertGroupConfirmExpandCellDidClickStatusWithIndex:self.index andStatusOpen:self.isOpen];
    }
}

@end
