//
//  ECDialogueDetailTableViewCell.m
//  Express
//
//  Created by owen on 15/11/16.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXDialogueDetailTableViewCell.h"

@implementation EXDialogueDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   [self setBackgroundColor:UIColorFromRGB(KEEEEEEColor)];
    if (self) {
//
//        _timeLB = [UILabel newAutoLayoutView];
//        _timeLB.font  = [UIFont boldSystemFontOfSize:10];
//        _timeLB.backgroundColor = UIColorFromRGB(KC8C8C8Color);
//        _timeLB.textColor  = [UIColor whiteColor];
//        _timeLB.layer.cornerRadius = 8.0f;
//        _timeLB.textAlignment = NSTextAlignmentCenter;
//        _timeLB.clipsToBounds = YES;
//        [self addSubview:_timeLB];
//        
//        _sysMsg = [UILabel newAutoLayoutView];
//        _sysMsg.font  = [UIFont boldSystemFontOfSize:10];
//        _sysMsg.backgroundColor = UIColorFromRGB(KC8C8C8Color);
//        _sysMsg.textColor  = [UIColor whiteColor];
//        _sysMsg.layer.cornerRadius = 5.0f;
//        _sysMsg.textAlignment = NSTextAlignmentCenter;
//        _sysMsg.clipsToBounds = YES;
//        [self addSubview:_sysMsg];
//        
//        
//        
//        _fromNameLB = [UILabel newAutoLayoutView];
//        _fromNameLB.font  = [UIFont boldSystemFontOfSize:10];
//        _fromNameLB.textColor  = UIColorFromRGB(K595555Color);
//        _fromNameLB.layer.cornerRadius = 5.0f;
//        _fromNameLB.textAlignment = NSTextAlignmentLeft;
//        _fromNameLB.clipsToBounds = YES;
//        [self addSubview:_fromNameLB];
//        
//        
//        _fromImageLogo = [UIImageView newAutoLayoutView];
//        _fromImageLogo.contentMode =UIViewContentModeScaleAspectFit;
//        _fromImageLogo.layer.borderWidth = 1.0f;
//        _fromImageLogo.layer.borderColor = [UIColor whiteColor].CGColor;
//        _fromImageLogo.layer.cornerRadius = 20;
//        _fromImageLogo.clipsToBounds = YES;
//        [self addSubview:_fromImageLogo];
//        
//       
//        _fromBgView = [UIView newAutoLayoutView];
//        [self addSubview:_fromBgView];
//        
//        
//
//        _selfNameLB = [UILabel newAutoLayoutView];
//        _selfNameLB.font  = [UIFont boldSystemFontOfSize:12];
//        _selfNameLB.textColor  = UIColorFromRGB(K595555Color);
//        _selfNameLB.layer.cornerRadius = 5.0f;
//        _selfNameLB.textAlignment = NSTextAlignmentRight;
//        _selfNameLB.clipsToBounds = YES;
//        [self addSubview:_selfNameLB];
//        
//        _selfImageLogo = [UIImageView newAutoLayoutView];
//        _selfImageLogo.contentMode =UIViewContentModeScaleAspectFit;
//        _selfImageLogo.layer.borderWidth = 1.0f;
//        _selfImageLogo.layer.borderColor = [UIColor whiteColor].CGColor;
//        _selfImageLogo.layer.cornerRadius = 20;
//        _selfImageLogo.clipsToBounds = YES;
//        [self addSubview:_selfImageLogo];
//        
//        _selfBgView = [UIView newAutoLayoutView];
////        _selfBgImageView.contentMode =UIViewContentModeScaleAspectFit;
////        _selfBgImageView.layer.borderWidth = 1.0f;
////        _selfBgImageView.layer.borderColor = [UIColor whiteColor].CGColor;
////        _selfBgImageView.layer.cornerRadius = 5;
////        _selfBgImageView.clipsToBounds = YES;
////         [_selfBgImageView setImage:[UIImage imageNamed:@"chatto_bg_focused"]];
//        [self addSubview:_selfBgView];
//        
//       [self updateViewConstraints];
    }
    return  self;
}
-(void)updateViewConstraints
{
    
//    /**
//     *  autoSetDimension // 设置 view大小
//     *  ALDimensionHeight 设置高度 toSize 值
//     *  ALDimensionWidth    设置宽度 toSize 值
//     */
//    [self.timeLB autoSetDimensionsToSize:CGSizeMake(120, 20)];
//    [self.timeLB autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2];
//    [self.timeLB autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(SCREEN_WIDTH-120)/2];
////    [self.timeLB autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    
//    
//    
//    [self.sysMsg autoSetDimensionsToSize:CGSizeMake(100, 40)];
//    [self.sysMsg autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timeLB  withOffset:2];
//    [self.sysMsg autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(SCREEN_WIDTH-100)/2];
////    [self.sysMsg autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    
//
//    [self.fromNameLB autoSetDimensionsToSize:CGSizeMake(100, 15)];
//    [self.fromNameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timeLB  withOffset:2];
//    [self.fromNameLB autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70];
//    
//    [self.fromImageLogo autoSetDimensionsToSize:CGSizeMake(40, 40)];
//     [self.fromImageLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timeLB  withOffset:8];
//    [self.fromImageLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.fromNameLB  withOffset:8];
////    [self.fromImageLogo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
//    [self.fromImageLogo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
//    
//    [self.fromBgView autoSetDimensionsToSize:CGSizeMake(50, 50)];
//    [self.fromBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.fromNameLB  withOffset:2];
//     [self.fromBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timeLB  withOffset:2];
////    [self.fromBgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
//    [self.fromBgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.fromImageLogo  withOffset:5];
//    
//    
//    
//    [self.selfNameLB autoSetDimensionsToSize:CGSizeMake(100, 15)];
//    [self.selfNameLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.timeLB  withOffset:2];
//    [self.selfNameLB autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:70];
//    
//    [self.selfImageLogo autoSetDimensionsToSize:CGSizeMake(40, 40)];
//    [self.selfImageLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.selfNameLB  withOffset:8];
//    [self.selfImageLogo autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:-10];
//    
//    [self.selfBgView autoSetDimensionsToSize:CGSizeMake(50, 50)];
//    [self.selfBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.selfNameLB  withOffset:2];
//    [self.selfBgView autoPinEdge:ALEdgeRight  toEdge:ALEdgeLeft ofView:self.selfImageLogo  withOffset:-5];
 
}
@end
