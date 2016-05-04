//
//  TEMedicalCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEMedicalCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "TEPicMedicalCell.h"

#define  PIC_WIDTH 70
#define  PIC_HEIGHT 70
#define  INSETS 10
@interface TEMedicalCell ()
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger delectInteger;
@end

@implementation TEMedicalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imageTableView.delegate = self;
        // 病历项目
        UILabel *itemLabel = [[UILabel alloc] init];
        self.itemLabel = itemLabel;
        self.itemLabel.font = [UIFont boldSystemFontOfSize:17];
        self.itemLabel.textColor = [UIColor colorWithHex:0x383838];
        self.itemLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.itemLabel];
        
        
        // 病历
        UITableView *imageTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, -90, 140, 320) style:UITableViewStylePlain];
        self.imageTableView = imageTableView;
        self.imageTableView.showsHorizontalScrollIndicator = NO;
        self.imageTableView.showsVerticalScrollIndicator = NO;
        self.imageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.imageTableView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.imageTableView.delegate = self;
        self.imageTableView.dataSource = self;
        self.imageTableView.scrollsToTop = NO;
        self.imageTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        [self.contentView addSubview:self.imageTableView];
        
        
        // 增加图片
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.plusButton = plusButton;
        [self.plusButton setImage:[UIImage imageNamed:@"add_picture_unselected"] forState:UIControlStateNormal];
        [self.plusButton setImage:[UIImage imageNamed:@"add_picture_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.plusButton];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.itemLabel.frame = CGRectMake(20, 14, 280, 21);
    
    self.imageTableView.frame = CGRectMake(0, 50, kScreen_Width - PIC_WIDTH -2 * INSETS, PIC_WIDTH + 2 * INSETS);
    
    self.plusButton.frame = CGRectMake(kScreen_Width - PIC_WIDTH - 2 * INSETS + 5, 50, PIC_WIDTH, PIC_HEIGHT);
    
    if (self.picArray.count >3) {
        self.imageTableView.scrollEnabled = YES;
    } else {
        self.imageTableView.scrollEnabled = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.picArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    TEPicMedicalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TEPicMedicalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.isContainHttp = self.isContainHttp;
    [cell addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)]];
    cell.picurl = self.picArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


// 停止抖动
- (void)stop:(UIButton *)btn{
    [btn.layer removeAnimationForKey:@"shake"];
}

// 长按添加删除按钮
- (void)longPressGesture:(UIGestureRecognizer *)gester
{
    if (gester.state == UIGestureRecognizerStateBegan)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示" message:@"删除图片资料" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        TEPicMedicalCell * cell =(TEPicMedicalCell *)gester.view;
        
        self.delectInteger = [self.picArray indexOfObject:cell.picurl];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(picWillDeleteWithType:andInteger:)]) {
            [self.delegate picWillDeleteWithType:self.type andInteger:self.delectInteger];
        }
    }
}

@end
