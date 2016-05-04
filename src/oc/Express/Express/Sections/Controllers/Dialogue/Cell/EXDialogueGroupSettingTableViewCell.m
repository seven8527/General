//
//  EXDialogueGroupSettingTableViewCell.m
//  Express
//
//  Created by owen on 15/11/30.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXDialogueGroupSettingTableViewCell.h"

@implementation EXDialogueGroupSettingTableViewCell

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
        _title = [UILabel newAutoLayoutView];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textColor = UIColorFromRGB(KC8C8C8Color);
        [self addSubview:_title];
        
        _switchBtn = [UISwitch newAutoLayoutView];
        _switchBtn.onTintColor = UIColorFromRGB(KFE784BColor);
        _switchBtn.tintColor = UIColorFromRGB(KE6E6E6Color);
        
        [self addSubview:_switchBtn];
        
        _arrayImageView = [UIImageView newAutoLayoutView];
        [_arrayImageView setImage:[UIImage imageNamed:@"icon_arrows.png"]];
        [self addSubview:_arrayImageView];
        
        _bottomView = [UIView newAutoLayoutView];
        _bottomView.backgroundColor = UIColorFromRGB(KE6E6E6Color);
         [self addSubview:_bottomView];
        
//        [self updateViewConstraints];
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
//    [self.title autoSetDimensionsToSize:CGSizeMake(80, 60)];
//    [self.title autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
//    [self.title autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    
//
//    [self.switchBtn autoSetDimensionsToSize:CGSizeMake(60, 30)];
//    [self.switchBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
//    [self.switchBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
//    
//    
//    [self.arrayImageView autoSetDimensionsToSize:CGSizeMake(10 ,  19)];
//    [self.arrayImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
//    [self.arrayImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
//    
//    
//    [self.bottomView autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH ,  15)];
//    [self.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.title];
//    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight ];
    
}
@end
