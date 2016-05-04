//
//  TEPicMedicalCell.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPicMedicalCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "TEUITools.h"
#import "UIImageView+NetLoading.h"



#define deleImageWH 25 // 删除按钮的宽高
#define kAdeleImage @"close.png" // 删除按钮图片

@interface TEPicMedicalCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) UIView *backView;
@end

@implementation TEPicMedicalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 70, 70)];
        self.picImageView = picImageView;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)];
        [picImageView addGestureRecognizer:tap];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        picImageView.userInteractionEnabled = YES;
        picImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self addSubview:picImageView];
        
    }
    return self;
}


- (void)setIsContainHttp:(NSString *)isContainHttp
{
    _isContainHttp = isContainHttp;
}

- (void)setPicurl:(NSString *)picurl
{
    _picurl = picurl;
    NSString *imageUrl = picurl;
    if (![picurl hasPrefix:@"http://"]) {
        if (self.isContainHttp) {
            imageUrl = [self.isContainHttp stringByAppendingString:picurl];
        }
    }
     [self.picImageView accordingToNetLoadImagewithUrlstr:imageUrl and:@"logo.png"];
}

//  查看图片
- (void)showImage:(UITapGestureRecognizer*)tap
{
    // 替换为中等尺寸图片
    //    NSString *url = self.picurl;
    NSString *imageUrl = self.picurl;
    if (![self.picurl hasPrefix:@"http://"]) {
        if (self.isContainHttp) {
            imageUrl = [self.isContainHttp stringByAppendingString:self.picurl];
        }
    }
    MJPhoto *photo = [[MJPhoto alloc] init];
    if ([TEUITools enableLoadPic]) {
        if ([imageUrl rangeOfString:@"_150X150"].location != NSNotFound) {
           imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_150X150" withString:@""];
        }
        photo.url = [NSURL URLWithString:imageUrl]; // 图片路径
    }
    photo.srcImageView = (UIImageView *)tap.view; // 来源于哪个UIImageView
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = [NSArray arrayWithObject:photo]; // 设置所有的图片
    [browser show];
    
}


//CGRect defaultFrame;
//id dImageView;
//
////  查看图片
//- (void)showImage:(UITapGestureRecognizer*)tap
//{
//    
//    UIImageView *imageView = (UIImageView *)tap.view;
//    UIImage *image = imageView.image;
//    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
//    UIView *backView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    self.backView = backView;
//    [[UIApplication sharedApplication].keyWindow addSubview:backView];
//    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
//    
//    UIScrollView *sv = [[UIScrollView alloc]init];
//    [sv addGestureRecognizer:tap1];
//    sv.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    [backView addSubview:sv];
//    sv.delegate = self;
//    UIImageView *iv = [[UIImageView alloc]init];
//    self.iv =iv;
//    CGFloat origin_x = abs(sv.frame.size.width - image.size.width)/2.0;
//    CGFloat origin_y = abs(sv.frame.size.height - image.size.height)/2.0;
//    //            self.iv.frame = CGRectMake(origin_x, origin_y, sv.frame.size.width, sv.frame.size.width*image.size.height/image.size.width);
//    iv.frame = CGRectMake(origin_x, origin_y, image.size.width,image.size.height);
//    [iv setImage:image];
//    
//    [sv addSubview:iv];
//    
//    CGSize maxSize = sv.frame.size;
//    CGFloat widthRatio = maxSize.width/image.size.width;
//    CGFloat heightRatio = maxSize.height/image.size.height;
//    CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
//    /*
//     
//     ** 设置UIScrollView的最大和最小放大级别（注意如果MinimumZoomScale == MaximumZoomScale，
//     
//     ** 那么UIScrllView就缩放不了了
//     
//     */
//    [sv setMinimumZoomScale:initialZoom * 0.5];
//    [sv setMaximumZoomScale:40];
//    // 设置UIScrollView初始化缩放级别
//    [sv setZoomScale:initialZoom];
//    
//}
//
//// 隐藏图片
//- (void)hideImage:(UITapGestureRecognizer*)tap
//{
//    UIView *backgroundView = tap.view;
//    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView.frame = defaultFrame;
//        self.backView.alpha = 0;
//    } completion:^(BOOL finished) {
//        self.backView.hidden = YES;
//        [self.backView removeFromSuperview];
//        ((UIImageView*)dImageView).alpha = 1;
//        [backgroundView removeFromSuperview];
//    }];
//}
//
//// 设置UIScrollView中要缩放的视图
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return self.iv;
//}
//
//// 让UIImageView在UIScrollView缩放后居中显示
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
//    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
//    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
//    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
//    self.iv.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                                 scrollView.contentSize.height * 0.5 + offsetY);
//}

@end
