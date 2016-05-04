//
//  TEPatientBasicDataCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientBasicDataCell.h"

@implementation TEPatientBasicDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 19, 6, 6)];
        _startImageView.image = [UIImage imageNamed:@"star.png"];
        _startImageView.hidden = YES;
        [self.contentView addSubview:_startImageView];
    }
    return self;
}

@end
