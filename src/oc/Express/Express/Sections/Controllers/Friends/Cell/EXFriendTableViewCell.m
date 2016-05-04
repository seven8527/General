//
//  EXFriendTableViewCell.m
//  Express
//
//  Created by owen on 15/11/5.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXFriendTableViewCell.h"

@implementation EXFriendTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgLogo = [UIImageView newAutoLayoutView];
        _imgLogo.contentMode =UIViewContentModeScaleAspectFit;
        _imgLogo.layer.borderWidth = 1.0f;
        _imgLogo.layer.borderColor = [UIColor whiteColor].CGColor;
        _imgLogo.layer.cornerRadius = 20.0f;
        _imgLogo.clipsToBounds = YES;
        [self addSubview:_imgLogo];
        
        _name       = [UILabel newAutoLayoutView];
        _name.font  = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_name];
        [self updateViewConstraints];
        
    }
    return self;
}

-(void)updateViewConstraints
{
    
    /**
     *  autoSetDimension // 设置 view大小
     *  ALDimensionHeight 设置高度 toSize 值
     *  ALDimensionWidth    设置宽度 toSize 值
     */
    [self.imgLogo autoSetDimensionsToSize:CGSizeMake(40, 40)];
    [self.imgLogo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.imgLogo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
   
    
      //设置titl位置
    [self.name autoSetDimensionsToSize:CGSizeMake(150, 20)];
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imgLogo withOffset:10];
    [self.name autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    
    
}
@end
