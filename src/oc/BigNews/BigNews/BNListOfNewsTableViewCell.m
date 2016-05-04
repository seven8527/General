//
//  BNListOfNewsTableViewCell.m
//  BigNews
//
//  Created by Owen on 15-8-15.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNListOfNewsTableViewCell.h"
#import "UIColor+Random.h"

@implementation BNListOfNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _img = [UIImageView newAutoLayoutView];
        _img.layer.masksToBounds = YES;
        _img.layer.cornerRadius = 5;
        _img.layer.backgroundColor=[UIColor randomColor].CGColor;
        _img.contentMode = UIViewContentModeScaleAspectFit;
        _img.layer.borderColor = [UIColor randomColor].CGColor;
        _img.layer.borderWidth = 1;
        [self addSubview:_img];
        
        _time = [UILabel newAutoLayoutView];
        _time.font = [UIFont systemFontOfSize:15];
        [self addSubview:_time];
        
        _title = [UILabel newAutoLayoutView];
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textColor = [UIColor randomColor];
        _title.numberOfLines = 2;
        [self addSubview:_title];
        
        
        _content = [UILabel newAutoLayoutView];
        _content.font = [UIFont systemFontOfSize:15];
        _content.numberOfLines =3;
        [self addSubview:_content];
        
        [self updateViewConstraints];
    }
//    [self updateViewConstraints];
    return  self;
}

-(void) updateViewConstraints
{
    [self.img autoSetDimensionsToSize:CGSizeMake(100, 60)];
    [self.img autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.img autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3];
    
    [self.title autoSetDimension:ALDimensionHeight toSize:35];
    [self.title autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.img withOffset:10];
    [self.title autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.title autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.img];
    
    
    [self.time autoSetDimension:ALDimensionHeight toSize:25];
    [self.time autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.img];
    [self.time autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.img withOffset:10 ];
    [self.time autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    
    [self.content autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH-20, 60)];
    [self.content autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.img withOffset:4];
    [self.content autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
}

@end
