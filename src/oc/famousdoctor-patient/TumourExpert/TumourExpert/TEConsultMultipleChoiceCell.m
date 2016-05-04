//
//  TEConsultMultipleChoiceCell.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsultMultipleChoiceCell.h"
#import "UIColor+Hex.h"

@implementation TEConsultMultipleChoiceCell
@synthesize mSelected = _mSelected;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _mSelected = NO;
        CGRect indicatorFrame = CGRectMake(15, abs(self.frame.size.height - 15)/ 2, 15, 15);
        
        _mSelectedIndicator = [[UIImageView alloc] initWithFrame:indicatorFrame];
        _mSelectedIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_mSelectedIndicator];
        
        _accessLable = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 70, self.frame.size.height)];
        _accessLable.userInteractionEnabled = YES;
        _accessLable.text = @"点击查看";
        _accessLable.font = [UIFont systemFontOfSize:14];
        _accessLable.textAlignment = NSTextAlignmentCenter;
        _accessLable.textColor = [UIColor colorWithHex:0x00947d];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accessLableTap)];
        [_accessLable addGestureRecognizer:tap];
        [self addSubview:_accessLable];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(35, 0, [UIScreen mainScreen].bounds.size.width - 100 , 39);
    self.textLabel.backgroundColor = [UIColor clearColor];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    if (_mSelected)
    {
        if (((UITableView *)self.superview).isEditing)
        {
            self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        }
        else
        {
            self.backgroundView.backgroundColor = [UIColor clearColor];
        }
        [_mSelectedIndicator setImage:[UIImage imageNamed:@"radioButton_selected"]];
        if (self.showSelectedIndicator == YES) {
            _mSelectedIndicator.hidden = NO;
        } else {
            _mSelectedIndicator.hidden = YES;
        }

    }
    else
    {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [_mSelectedIndicator setImage:[UIImage imageNamed:@"radioButton_unselected"]];
        if (self.showSelectedIndicator == YES) {
            _mSelectedIndicator.hidden = NO;
        } else {
            _mSelectedIndicator.hidden = YES;
        }

    }
    
    if (self.showAccessLable == YES) {
        _accessLable.hidden = NO;
    } else {
        _accessLable.hidden = YES;
    }
    
    [UIView commitAnimations];
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    //[self setNeedsLayout];
}


#pragma mark -
#pragma mark Public

- (void)changeMSelectedState
{
    _mSelected = !_mSelected;
    [self setNeedsLayout];
}

- (void)accessLableTap
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.contentModel forKey:@"consultMultiple"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"consultMultiple" object:nil userInfo:dict];
}
@end
