//
//  TEOrderCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEOrderModel.h"

#define TEORDERCELLLEFTMARGIN             25.0f

#define TEORDERCELLORDERIDLABELTOPMARGIN     20.0f
#define TEORDERCELLICONTOPMARGIN   10.0f
#define TEORDERCELLDOCTORTOPMARGIN   13.0f
#define TEORDERCELLDOCTORBOTTOMMARGIN   10.0f
#define TEORDERCELLICONBOTTOMMARGIN   10.0f
#define TEORDERCELLTYPETOPMARGIN   8.0f
#define TEORDERCELLPRICETOPMARGIN   8.0f
#define TEORDERCELLSTATETOPMARGIN   8.0f
#define TEORDERCELLSTATEBOTTOMMARGIN   10.0f

#define TEORDERCELLLABELHEIGHT       21.0f

#define TEORDERCELLBIGFONT 17.0f
#define TEORDERCELLSMALLFONT 14.0f

#define TEORDERCELLBLACKCOLOR     0x383838
#define TEORDERCELLGRAYCOLOR      0x6b6b6b
#define TEORDERCELLORANGECOLOR    0xe47929
#define TEORDERCELLLIHGTGRAYCOLOR 0x9e9e9e
#define TEORDERCELLGREENCOLOR     0x00947d
#define TEORDERCELLLIGHTGREENCOLOR     0x58ad9c


@implementation TEOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 订单编号
        UILabel *promptOrderIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEORDERCELLLEFTMARGIN, TEORDERCELLORDERIDLABELTOPMARGIN, 100, TEORDERCELLLABELHEIGHT)];
        promptOrderIdLabel.text = @"订单编号：";
        promptOrderIdLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLBIGFONT];
        promptOrderIdLabel.textColor = [UIColor colorWithHex:TEORDERCELLBLACKCOLOR];
        [self.contentView addSubview:promptOrderIdLabel];
        
        self.orderIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, TEORDERCELLORDERIDLABELTOPMARGIN, 200, TEORDERCELLLABELHEIGHT)];
        self.orderIDLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLBIGFONT];
        self.orderIDLabel.textColor = [UIColor colorWithHex:TEORDERCELLBLACKCOLOR];
        [self.contentView addSubview:self.orderIDLabel];
        
        // 医生头像
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TEORDERCELLLEFTMARGIN, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT + TEORDERCELLICONTOPMARGIN, 53, 53)];
        [self.contentView addSubview:self.iconImageView];
        
        // 医生标签
        self.doctorLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT + TEORDERCELLDOCTORTOPMARGIN, 68, TEORDERCELLLABELHEIGHT)];
        self.doctorLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLBIGFONT];
        self.doctorLabel.textColor = [UIColor colorWithHex:TEORDERCELLBLACKCOLOR];
        [self.contentView addSubview:self.doctorLabel];
        
        // 职称标签
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 2 + TEORDERCELLDOCTORTOPMARGIN + TEORDERCELLDOCTORBOTTOMMARGIN, 83, TEORDERCELLLABELHEIGHT)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        self.titleLabel.textColor = [UIColor colorWithHex:TEORDERCELLGRAYCOLOR];
        [self.contentView addSubview:self.titleLabel];
        
        // 医院标签
        self.hospitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 2 + TEORDERCELLDOCTORTOPMARGIN + TEORDERCELLDOCTORBOTTOMMARGIN, 143, TEORDERCELLLABELHEIGHT)];
        self.hospitalLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        self.hospitalLabel.textColor = [UIColor colorWithHex:TEORDERCELLGRAYCOLOR];
        [self.contentView addSubview:self.hospitalLabel];
        
        // 画线
        UIImageView *separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(TEORDERCELLLEFTMARGIN, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN, 280, 1)];
        separateLine.image = [[UIImage imageNamed:@"line_d1d1d1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [self.contentView addSubview:separateLine];
        
        // 咨询类型
        UILabel *promptAskTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEORDERCELLLEFTMARGIN, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN, 70, TEORDERCELLLABELHEIGHT)];
        promptAskTypeLabel.text = @"咨询类型：";
        promptAskTypeLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        promptAskTypeLabel.textColor = [UIColor colorWithHex:TEORDERCELLBLACKCOLOR];
        [self.contentView addSubview:promptAskTypeLabel];
        
        self.askTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN, 100, TEORDERCELLLABELHEIGHT)];
        self.askTypeLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        self.askTypeLabel.textColor = [UIColor colorWithHex:TEORDERCELLLIHGTGRAYCOLOR];
        [self.contentView addSubview:self.askTypeLabel];
        
        // 时间
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN, 135, TEORDERCELLLABELHEIGHT)];
        self.timeLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        self.timeLabel.textColor = [UIColor colorWithHex:TEORDERCELLLIHGTGRAYCOLOR];
        [self.contentView addSubview:self.timeLabel];
        
        // 价格
        UILabel *promptPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEORDERCELLLEFTMARGIN, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 2 + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN + TEORDERCELLPRICETOPMARGIN, 70, TEORDERCELLLABELHEIGHT)];
        promptPriceLabel.text = @"订单金额：";
        promptPriceLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        promptPriceLabel.textColor = [UIColor colorWithHex:TEORDERCELLBLACKCOLOR];
        [self.contentView addSubview:promptPriceLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 2 + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN + TEORDERCELLPRICETOPMARGIN, 100, TEORDERCELLLABELHEIGHT)];
        self.priceLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        self.priceLabel.textColor = [UIColor colorWithHex:TEORDERCELLORANGECOLOR];
        [self.contentView addSubview:self.priceLabel];
        
        // 状态
        UILabel *promptStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(TEORDERCELLLEFTMARGIN, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 3 + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN + TEORDERCELLPRICETOPMARGIN + TEORDERCELLSTATETOPMARGIN, 70, TEORDERCELLLABELHEIGHT)];
        promptStateLabel.text = @"订单状态：";
        promptStateLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        promptStateLabel.textColor = [UIColor colorWithHex:TEORDERCELLBLACKCOLOR];
        [self.contentView addSubview:promptStateLabel];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 3 + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN + TEORDERCELLPRICETOPMARGIN + TEORDERCELLSTATETOPMARGIN, 100, TEORDERCELLLABELHEIGHT)];
        self.stateLabel.font = [UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT];
        self.stateLabel.textColor = [UIColor colorWithHex:TEORDERCELLLIHGTGRAYCOLOR];
        [self.contentView addSubview:self.stateLabel];
        
        // 取消订单
        self.cancelOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelOrderButton.frame = CGRectMake(165, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 3 + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN + TEORDERCELLPRICETOPMARGIN + TEORDERCELLSTATETOPMARGIN, 60, TEORDERCELLLABELHEIGHT);
        [self.cancelOrderButton setTitleColor:[UIColor colorWithHex:TEORDERCELLLIGHTGREENCOLOR] forState:UIControlStateNormal];
        [self.cancelOrderButton.titleLabel setFont:[UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT]];
        self.cancelOrderButton.hidden = YES;
        [self.contentView addSubview:self.cancelOrderButton];
        
        // 支付按钮
        self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.payButton.frame = CGRectMake(240, TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 3 + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN + TEORDERCELLPRICETOPMARGIN + TEORDERCELLSTATETOPMARGIN, 60, TEORDERCELLLABELHEIGHT);
        [self.payButton setTitleColor:[UIColor colorWithHex:TEORDERCELLGREENCOLOR] forState:UIControlStateNormal];
        [self.payButton.titleLabel setFont:[UIFont boldSystemFontOfSize:TEORDERCELLSMALLFONT]];
        self.payButton.hidden = YES;
        [self.contentView addSubview:self.payButton];

    }
    return self;
}


+ (CGFloat)rowHeightWitObject:(id)object
{
    	return TEORDERCELLORDERIDLABELTOPMARGIN + TEORDERCELLLABELHEIGHT * 4 + TEORDERCELLICONTOPMARGIN + 53 + TEORDERCELLICONBOTTOMMARGIN + TEORDERCELLTYPETOPMARGIN + TEORDERCELLPRICETOPMARGIN + TEORDERCELLSTATETOPMARGIN + TEORDERCELLSTATEBOTTOMMARGIN;
}

@end
