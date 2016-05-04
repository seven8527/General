//
//  DetailTableViewCell.m
//  BigNews
//
//  Created by owen on 15/8/17.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIColor+Random.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        [self configUIFrame];
    }
    
    return self;
}
-(void) configUIFrame
{
    _myImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-20, 150)];
    _myImageview.backgroundColor = [UIColor randomColor];
    _myImageview.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_myImageview];
    
    _detailLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, SCREEN_WIDTH-20, 100)];
    _detailLable.font = [UIFont boldSystemFontOfSize:16];
    _detailLable.numberOfLines =0;
    _detailLable.textColor = [UIColor randomColor];
    _detailLable.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self addSubview:_detailLable];
    
//    [self updateViewConstraints];
}

-(void) configUI
{
    _myImageview = [UIImageView newAutoLayoutView];
    _myImageview.backgroundColor = [UIColor randomColor];
    _myImageview.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_myImageview];
    
    _detailLable = [UILabel newAutoLayoutView];
    _detailLable.font = [UIFont systemFontOfSize:15];
    _detailLable.numberOfLines =0;
    _detailLable.lineBreakMode = NSLineBreakByWordWrapping;
  
    [self addSubview:_detailLable];
    
    [self updateViewConstraints];
}

-(void) updateViewConstraints
{
    
    [_myImageview autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH-20, 150)];
    [_myImageview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [_myImageview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
    [_detailLable autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH-20, 100 )];
    [_detailLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.myImageview withOffset:5 ];
    [_detailLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.myImageview];

}
@end
