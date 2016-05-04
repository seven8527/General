//
//  TEPhoneConsultInstructionCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-20.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPhoneConsultInstructionCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"

#define MESSAGE  @"提示信息：\n1、所有问题均由咨询专家回复，根据病情需要，专家会给患者相应的提示。\n2、网站的专家助理将预先审核资料并和患者沟通，对资料进行整合、补充，然后转交给所咨询的专家。\n3、专家临床工作繁忙，均在休息时上网回复患者咨询，时限一般为3日内，请咨询患者耐心等待。\n"

@implementation TEPhoneConsultInstructionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加手势
        self.phoneGestureView = [[UIView alloc] init];
        [self.contentView addSubview:self.phoneGestureView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneSelected)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self.phoneGestureView addGestureRecognizer:tapGestureRecognizer];
        
        // 同意提示信息按钮
        self.phoneCheckbox = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.phoneCheckbox setImage:[UIImage imageNamed:@"agreement_gray.png"] forState:UIControlStateNormal];
        [self.phoneCheckbox setImage:[UIImage imageNamed:@"agreement_green.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.phoneCheckbox];

        // 提示服务说明
        self.promptInstructionLabel = [[UILabel alloc] init];
        self.promptInstructionLabel.font = [UIFont boldSystemFontOfSize:12];
        self.promptInstructionLabel.textColor = [UIColor colorWithHex:0x383838];
        self.promptInstructionLabel.text = @"同意";
        [self.contentView addSubview:self.promptInstructionLabel];
        
        // 电话咨询协议
        self.agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.agreementButton.frame = CGRectMake(50, 11, 100, 21);
        [self.agreementButton setTitleColor:[UIColor colorWithHex:0x00947d] forState:UIControlStateNormal];
        [self.agreementButton setTitle:@"电话咨询协议" forState:UIControlStateNormal];
        [self.agreementButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.agreementButton];
        
        // 服务说明内容
        self.instructionLabel = [[UILabel alloc] init];
        self.instructionLabel.font = [UIFont boldSystemFontOfSize:12];
        self.instructionLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.instructionLabel.numberOfLines = 0;
        self.instructionLabel.text = MESSAGE;
        [self.contentView addSubview:self.instructionLabel];
        
        // 添加手势
        self.agreementGestureView = [[UIView alloc] init];
        [self.contentView addSubview:self.agreementGestureView];
        UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreementSelected)];
        tapGestureRecognizer2.numberOfTapsRequired = 1;
        tapGestureRecognizer2.numberOfTouchesRequired = 1;
        [self.agreementGestureView addGestureRecognizer:tapGestureRecognizer2];
        
        // 同意提示信息按钮
        self.agreementCheckbox = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.agreementCheckbox setImage:[UIImage imageNamed:@"agreement_gray.png"] forState:UIControlStateNormal];
        [self.agreementCheckbox setImage:[UIImage imageNamed:@"agreement_green.png"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.agreementCheckbox];
        
        // 同意提示信息
        self.agreementLabel = [[UILabel alloc] init];
        self.agreementLabel.font = [UIFont boldSystemFontOfSize:12];
        self.agreementLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
        self.agreementLabel.text = @"同意提示信息";
        [self.contentView addSubview:self.agreementLabel];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
    CGSize boundingSize = CGSizeMake(288, CGFLOAT_MAX);
    CGSize messageSize = [MESSAGE boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:12]];
    
    self.phoneCheckbox.frame = CGRectMake(16, 15, 13, 13);
    self.promptInstructionLabel.frame = CGRectMake(36, 11, 25, 21);
    self.agreementButton.frame = CGRectMake(50, 11, 100, 21);
    self.instructionLabel.frame = CGRectMake(16, 32, messageSize.width, messageSize.height);
    self.agreementCheckbox.frame = CGRectMake(16, messageSize.height + 42, 13, 13);
    self.agreementLabel.frame = CGRectMake(36, messageSize.height + 38, 100, 21);
    
    self.phoneGestureView.frame = CGRectMake(-10, 0, kScreen_Width+10, 50);
    self.agreementGestureView.frame = CGRectMake(-10, messageSize.height + 30, kScreen_Width+10, 50);
}

// 计算cell的高度
+ (CGFloat)rowHeight
{
    CGSize boundingSize = CGSizeMake(288, CGFLOAT_MAX);
    CGSize messageSize = [MESSAGE boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:12]];
    return messageSize.height + 74;
}

// 勾选
- (void)phoneSelected
{
    self.phoneCheckbox.selected = !self.phoneCheckbox.selected;
    
    [self.delegate didSelectedPhone:self.phoneCheckbox.selected agreement:self.agreementCheckbox.selected];
}

// 勾选
- (void)agreementSelected
{
    self.agreementCheckbox.selected = !self.agreementCheckbox.selected;
    
    [self.delegate didSelectedPhone:self.phoneCheckbox.selected agreement:self.agreementCheckbox.selected];
}

@end
