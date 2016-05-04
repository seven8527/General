//
//  MYSMedicalDataCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-20.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMedicalDataCell.h"
#import "MYSMedicalSignalImageCell.h"
#import "UIColor+Hex.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"


#define  PIC_WIDTH 60
#define  PIC_HEIGHT 60
#define  INSETS 12

@interface MYSMedicalDataCell () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation MYSMedicalDataCell

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
        
        
        // 病历
        UITableView *imageTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, -90, 140, kScreen_Width) style:UITableViewStylePlain];
        imageTableView.backgroundColor = [UIColor clearColor];
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

- (void)setPicArray:(NSArray *)picArray
{
    _picArray = picArray;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.itemLabel.frame = CGRectMake(15, 14, 280, 12);
    
    self.imageTableView.frame = CGRectMake(15, CGRectGetMaxY(self.itemLabel.frame), kScreen_Width -2 * INSETS, PIC_WIDTH + 19);
    
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
    static NSString *medicalSignalImage = @"medicalSignalImage";
    MYSMedicalSignalImageCell *medicalSignalImageCell = [tableView dequeueReusableCellWithIdentifier:medicalSignalImage];
    if (medicalSignalImageCell == nil) {
        medicalSignalImageCell = [[MYSMedicalSignalImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:medicalSignalImage];
    }
//    cell.isContainHttp = self.isContainHttp;
//    [cell addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)]];
    medicalSignalImageCell.picurl = self.picArray[indexPath.row];
    medicalSignalImageCell.tag = indexPath.row;
    [medicalSignalImageCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
    return medicalSignalImageCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


- (void)showImage:(UITapGestureRecognizer*)tap
{
//    int count = _urls.count;
//    // 1.封装图片数据
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//    for (int i = 0; i<count; i++) {
//        // 替换为中等尺寸图片
//        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:url]; // 图片路径
//        photo.srcImageView = self.view.subviews[i]; // 来源于哪个UIImageView
//        [photos addObject:photo];
    //    }  // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.hiddenPhotoLoadingView = NO;
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
   

    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.picArray.count];
    for (int i = 0; i<self.picArray.count; i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[self.picArray[i] stringByReplacingOccurrencesOfString:@"_150X150" withString:@""]];
        photo.srcImageView = [self.imageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    browser.photos = photos; // 设置所有的图片
    [browser show];

    
}

@end
