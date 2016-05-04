//
//  BNHomeTableViewCell.m
//  BigNews
//
//  Created by owen on 15/8/14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNHomeTableViewCell.h"
#import "MacroDefinition.h"
#import "Const.h"
#import "UIColor+Random.h"

@implementation BNHomeTableViewCell

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
    if (self) {
        
        
        _bgImageView = [UIImageView newAutoLayoutView];
        _bgImageView.contentMode =UIViewContentModeScaleAspectFit;
       
        //设置圆角
        _bgImageView.layer.cornerRadius = 8;
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.layer.borderColor = [UIColor randomColor].CGColor;
        _bgImageView.layer.borderWidth = 1;
        _bgImageView.backgroundColor =[UIColor randomColor];
        
        [self addSubview:_bgImageView];

        _title       = [UILabel newAutoLayoutView];
        _title.font  = [UIFont boldSystemFontOfSize:19];
        _title.textColor = [UIColor randomColor];
        [self addSubview:_title];
        
        
        _arrowIamgeView = [UIImageView newAutoLayoutView];
        [_arrowIamgeView setImage:ImageNamed(@"icon_arrows.png")];
        [self addSubview:_arrowIamgeView];
        
        [self updateViewConstraints];

    }
   
//    [self updateViewConstraints];
    return self;
}

-(void)updateViewConstraints
{
    
    /**
     *  autoSetDimension // 设置 view大小 
     *  ALDimensionHeight 设置高度 toSize 值
     *  ALDimensionWidth    设置宽度 toSize 值
     */
    [self.bgImageView autoSetDimension:ALDimensionHeight toSize:100];
    [self.bgImageView autoSetDimension:ALDimensionWidth toSize:170];
    
    /**
     *  直接设置宽度和高度
     *
     *  @param width#>  width description#> 设置宽度值
     *  @param height#> height description#> 设置高度值
     *
     */
//    [self.bgImageView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH-20, 100)];
    
    /**
     *  设置相对父view 的位置
     */
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2];
//    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:2];
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
//    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5];
//   [self.bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 10, 5, 10)];

    //设置对其模式
//    [self.bgImageView autoAlignAxisToSuperviewAxis:ALAxisBaseline];
    
    
    //设置titl位置
    
    [self.title autoSetDimensionsToSize:CGSizeMake(100, 30)];
    [self.title autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.bgImageView withOffset:20];
    [self.title autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [self.title autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.arrowIamgeView autoSetDimensionsToSize:CGSizeMake(9, 17.5)];
    [self.arrowIamgeView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [self.arrowIamgeView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
 
}
@end
