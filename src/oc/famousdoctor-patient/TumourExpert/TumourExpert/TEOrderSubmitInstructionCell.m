//
//  TEOrderSubmitInstructionCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-20.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderSubmitInstructionCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"

#define MESSAGE @"提示信息：\n1、所有问题均由咨询专家回复，根据病情需要，专家会给患者相应的提示。\n2、网站的专家助理将预先审核资料并和患者沟通，对资料进行整合、补充，然后转交给所咨询的专家。\n3、专家临床工作繁忙，均在休息时上网回复患者咨询，时限一般为3日内，请咨询患者耐心等待。\n"

#define REMIND @"特别提醒：\n在进行网银转账或银行汇款，请您在备注、附言、付款用途（不同银行提示有所不同）填写订单号与客户姓名。\n"

@implementation TEOrderSubmitInstructionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 开户名
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:12];
        self.nameLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.nameLabel.text = @"户名：北京华康云医健康科技有限公司";
        [self.contentView addSubview:self.nameLabel];
        
        // 账号
        self.accountLabel = [[UILabel alloc] init];
        self.accountLabel.font = [UIFont boldSystemFontOfSize:12];
        self.accountLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.accountLabel.text = @"账号：110061073018010097709";
        [self.contentView addSubview:self.accountLabel];
        
        // 开户银行
        self.bankLabel = [[UILabel alloc] init];
        self.bankLabel.font = [UIFont boldSystemFontOfSize:12];
        self.bankLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.bankLabel.text = @"开户银行：交通银行酒仙桥支行";
        [self.contentView addSubview:self.bankLabel];
        
        // 提示信息
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.font = [UIFont boldSystemFontOfSize:12];
        self.messageLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.text = MESSAGE;
        [self.contentView addSubview:self.messageLabel];
        
        // *
        self.starImageView = [[UIImageView alloc] init];
        self.starImageView.image = [UIImage imageNamed:@"star.png"];
        [self.contentView addSubview:self.starImageView];
        
        // 特别提醒
        self.remindLabel = [[UILabel alloc] init];
        self.remindLabel.font = [UIFont boldSystemFontOfSize:12];
        self.remindLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.remindLabel.numberOfLines = 0;
        self.remindLabel.text = REMIND;
        [self.contentView addSubview:self.remindLabel];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    CGSize boundingSize = CGSizeMake(288, CGFLOAT_MAX);
    CGSize messageSize = [MESSAGE boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:12]];
    CGSize remindSize = [REMIND boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:12]];
    
    if (self.payType == 0) {
        [self.nameLabel removeFromSuperview];
        [self.accountLabel removeFromSuperview];
        [self.bankLabel removeFromSuperview];
        
        self.messageLabel.frame = CGRectMake(16, 15, messageSize.width, messageSize.height);
        self.remindLabel.frame = CGRectMake(16, messageSize.height + 25, remindSize.width, remindSize.height);
        self.starImageView.frame = CGRectMake(10, messageSize.height + 30, 6, 6);
    } else {
        self.nameLabel.frame = CGRectMake(16, 11, 280, 21);
        self.accountLabel.frame = CGRectMake(16, 40, 280, 21);
        self.bankLabel.frame = CGRectMake(16, 69, 280, 21);
        
        self.messageLabel.frame = CGRectMake(16, 98, messageSize.width, messageSize.height);
        self.remindLabel.frame = CGRectMake(16, messageSize.height + 108, remindSize.width, remindSize.height);
        
        self.starImageView.frame = CGRectMake(10, messageSize.height + 113, 6, 6);
    }
}

// 计算cell的高度
+ (CGFloat)rowHeight:(int)payType
{
    CGSize boundingSize = CGSizeMake(288, CGFLOAT_MAX);
    CGSize messageSize = [MESSAGE boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:12]];
    CGSize remindSize = [REMIND boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:12]];
    
    if (payType == 1 || payType == 2) {
        return messageSize.height + remindSize.height + 35 + 90;
    }
    return messageSize.height + remindSize.height + 40;
}

@end
