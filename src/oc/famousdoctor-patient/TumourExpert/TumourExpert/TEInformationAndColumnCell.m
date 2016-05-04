//
//  TEInformationAndColumnCell.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEInformationAndColumnCell.h"
#import "UIColor+Hex.h"
@interface TEInformationAndColumnCell ()


@end
@implementation TEInformationAndColumnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.highlighted = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *picImageView = [[UIImageView alloc] init];
        picImageView.frame = CGRectMake(20, 14, 14, 14);
        self.picImageView = picImageView;
        [self.contentView addSubview:picImageView];
        
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = [UIFont systemFontOfSize:17];
        titleLable.textColor = [UIColor colorWithHex:0x6b6b6b];
        titleLable.frame = CGRectMake(42, 0, self.bounds.size.width - 42 , self.bounds.size.height);
        self.titleLable = titleLable;
        [self.contentView addSubview:titleLable];
        
    }
    return self;
}

@end
