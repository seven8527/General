//
//  MYSBeGoodAtViewController.m
//  MYSFamousDoctor
//
//  擅长详情
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBeGoodAtViewController.h"

#define TEXT_FONT [UIFont systemFontOfSize:15]
#define MARGIN_LEFT 15

@interface MYSBeGoodAtViewController ()

@end

@implementation MYSBeGoodAtViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"擅长";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = mShanchang;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = TEXT_FONT;
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
#else
    contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
#endif
    contentLabel.text = title;
    contentLabel.textColor = [UIColor blackColor];
    [self.view addSubview:contentLabel];
    
    CGFloat titleHeight = [self calculateLabelHeight:title];
    contentLabel.frame = CGRectMake(MARGIN_LEFT, MARGIN_LEFT, kScreen_Width - MARGIN_LEFT * 2, titleHeight);
}

- (void)sendValue:(NSString *)content
{
    mShanchang = content;
}

/**
 * 计算一个文字段的高度
 */
- (CGFloat)calculateLabelHeight:(NSString *)content
{
    // 给一个比较大的高度，宽度不变
    CGSize size =CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 5000);
    CGSize  actualsize;
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000)
    // 获取当前文本的属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: TEXT_FONT, NSFontAttributeName,nil];
    actualsize =[content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
#else
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
    actualsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#else
    actualsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
#endif
#endif
    
    return actualsize.height;
}

@end
