//
//  MYSAddMedicalDataCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSAddMedicalDataCell.h"
#import "MYSMedicalSignalImageCell.h"
#import "UIColor+Hex.h"
#import "MYSAddMedicalPlusCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MYSFoundationCommon.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define  PIC_WIDTH 60
#define  PIC_HEIGHT 60
#define  INSETS 12

@interface MYSAddMedicalDataCell () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UILabel *numberTipLabel;
@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation MYSAddMedicalDataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imageTableView.delegate = self;
        // 病历项目
        UILabel *itemLabel = [[UILabel alloc] init];
        self.itemLabel = itemLabel;
        self.itemLabel.font = [UIFont boldSystemFontOfSize:13];
        self.itemLabel.textColor = [UIColor colorFromHexRGB:K747474Color];
        self.itemLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.itemLabel];
        
        
        UILabel *numberTipLabel = [UILabel newAutoLayoutView];
        [self.contentView addSubview:numberTipLabel];
        numberTipLabel.text = [NSString stringWithFormat:@"%ld/15",(unsigned long)self.picArray.count];
        numberTipLabel.font = [UIFont systemFontOfSize:14];
        numberTipLabel.textColor = [UIColor colorFromHexRGB:KB8B8B8Color];
        self.numberTipLabel = numberTipLabel;
        
        // 病历
        UITableView *imageTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, -90, 140, kScreen_Width) style:UITableViewStylePlain];
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
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize itemLabelSize = [MYSFoundationCommon sizeWithText:self.itemLabel.text withFont:self.itemLabel.font];
    
    self.itemLabel.frame = CGRectMake(15, 15, itemLabelSize.width, 12);
    
    self.numberTipLabel.frame = CGRectMake(CGRectGetMaxX(self.itemLabel.frame), 15, 100, 12);
    
    self.imageTableView.frame = CGRectMake(15, CGRectGetMaxY(self.itemLabel.frame), kScreen_Width -2 * INSETS, PIC_WIDTH + 19);
    
    if (self.picArray.count >3) {
        self.imageTableView.scrollEnabled = YES;
    } else {
        self.imageTableView.scrollEnabled = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.picArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *medicalSignalImage = @"medicalSignalImage";
    MYSMedicalSignalImageCell *medicalSignalImageCell = [tableView dequeueReusableCellWithIdentifier:medicalSignalImage];
    if (medicalSignalImageCell == nil) {
        medicalSignalImageCell = [[MYSMedicalSignalImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:medicalSignalImage];
    }
    
    MYSAddMedicalPlusCell *plusCell = [[MYSAddMedicalPlusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == self.picArray.count) {
        return plusCell;
    } else {
        if (self.isImage) {
            medicalSignalImageCell.picImageView.image = [self.picArray[indexPath.row] objectForKey:@"image"];
        } else {
            [medicalSignalImageCell.picImageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[indexPath.row]] placeholderImage:nil];
        }
        self.numberTipLabel.text = [NSString stringWithFormat:@"%ld/15",(unsigned long)self.picArray.count];
        medicalSignalImageCell.tag  = indexPath.row;
        [medicalSignalImageCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
        [medicalSignalImageCell addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)]];
        return medicalSignalImageCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.picArray.count) {
        LOG(@"点击了加号");
        if ([self.delegate respondsToSelector:@selector(picWillAddWithType:withCurrentCount:)]) {
            [self.delegate picWillAddWithType:self.type withCurrentCount:self.picArray.count];
        }
    } else {
        LOG(@"点击了图片");
        
    }
}

- (void)showImage:(UITapGestureRecognizer*)tap
{
    [self.selectedButton removeFromSuperview];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.picArray.count];
    for (int i = 0; i<self.picArray.count; i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        if(self.isImage) {
            photo.srcImageView = [[UIImageView alloc] initWithImage:[self.picArray[i] objectForKey:@"image"]]; // 来源于哪个UIImageView
        } else {
            photo.srcImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.picArray[i] stringByReplacingOccurrencesOfString:@"_150X150" withString:@""]]]]];
        }
        [photos addObject:photo];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.hiddenPhotoLoadingView = YES;
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
}


// 停止抖动
- (void)stop:(UIButton *)btn{
    [btn.layer removeAnimationForKey:@"shake"];
}

// 长按添加删除按钮
- (void)longPressGesture:(UIGestureRecognizer *)gester
{
    LOG(@"%ld", (long)gester.view.tag);
    if (gester.state == UIGestureRecognizerStateBegan)
    {
        UIButton *delectImageButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 56, 16, 16)];
        delectImageButton.tag = gester.view.tag;
        [delectImageButton setImage:[UIImage imageNamed:@"consult_button_close_"] forState:UIControlStateNormal];
        [delectImageButton addTarget:self action:@selector(delectImageWithButton:) forControlEvents:UIControlEventTouchUpInside];
        MYSMedicalSignalImageCell *cell =(MYSMedicalSignalImageCell *)gester.view;
        self.selectedButton = delectImageButton;
        [cell addSubview:delectImageButton];
    }
}

// 删除图片
- (void)delectImageWithButton:(UIButton *)button
{
    //    [self.picArray removeObjectAtIndex:button.tag];
    
    if ([self.delegate respondsToSelector:@selector(picWillDeleteWithType:andInteger:)]) {
        [self.delegate picWillDeleteWithType:self.type andInteger:button.tag];
    }
    
    //    [button removeFromSuperview];
    //    [self.imageTableView reloadData];
}

@end
