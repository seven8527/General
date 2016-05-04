//
//  MYSExpertGroupDynamicFrame.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDynamicFrame.h"
#import "MYSFoundationCommon.h"

#define leftMargin 15

@implementation MYSExpertGroupDynamicFrame

- (void)setDynamicModel:(MYSDoctorHomeDynamicModel *)dynamicModel
{
    _dynamicModel = dynamicModel;
    
    self.firstLineF = CGRectMake(leftMargin, 0, 2, 10.5);
    
    self.tipImageViewF = CGRectMake(leftMargin - 7/2, CGRectGetMaxY(self.firstLineF) + 6.5, 7, 7);
    
    CGSize maxSize = CGSizeMake(kScreen_Width - CGRectGetMaxX(self.tipImageViewF) - 15 - leftMargin, MAXFLOAT);
    
    NSString *title;
    if (dynamicModel.title.length > 30) {
        title = [NSString stringWithFormat:@"%@.....",[dynamicModel.title substringToIndex:30]];
    } else {
        title = dynamicModel.title;
    }
    
    CGSize titleSize = [MYSFoundationCommon sizeWithText:title withFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize];
    
    self.titleLabelF = CGRectMake(CGRectGetMaxX(self.tipImageViewF) +15, 14, titleSize.width, titleSize.height);
    
//    CGFloat imageWidth = 268;
//    CGFloat imageHeight = 150;
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dynamicModel.picurl]]];
//    

//    NSLog(@"%f,%f",image.size.width,image.size.height);
//    if (image.size.height >= 150 && image.size.width >= 268) {
//        imageWidth = 268 * 150/ image.size.height;
//        imageHeight = 150 * 268/ image.size.width;
//    } else if(image.size.height > 150 && image.size.width <  268) {
//        imageHeight = 150;
//        imageWidth = 268 * 150 / image.size.height;
//    } else if (image.size.height < 150 && image.size.width > 268) {
//        imageWidth = 268;
//        imageHeight = 150 * 268 / image.size.width;
//    } else {
//        imageWidth = image.size.width;
//        imageHeight = image.size.height;
//    }
    

    if (dynamicModel.picurl) {
        if (dynamicModel.picurl.length > 0) {
            self.picImageF = CGRectMake(CGRectGetMinX(self.titleLabelF), CGRectGetMaxY(self.titleLabelF) + 10, 268, 150);
        }
    } else {
        self.picImageF = CGRectMake(CGRectGetMinX(self.titleLabelF), CGRectGetMaxY(self.titleLabelF) + 10, 0, 0);
    }
//    self.picImageF = CGRectMake(CGRectGetMinX(self.titleLabelF), CGRectGetMaxY(self.titleLabelF) + 10, imageWidth, imageHeight);
    
    self.timePicF = CGRectMake(CGRectGetMinX(self.picImageF), CGRectGetMaxY(self.picImageF) + 12, 10, 10);
    
    self.timeLabelF = CGRectMake(CGRectGetMaxX(self.timePicF) + 5, CGRectGetMaxY(self.picImageF) + 10, 200, 12);
    
    
    self.cellHeight = CGRectGetMaxY(self.timeLabelF) + 14;
    
    self.secondLineF = CGRectMake(leftMargin, CGRectGetMaxY(self.tipImageViewF) + 6.5, 2, self.cellHeight - CGRectGetMaxY(self.tipImageViewF) - 6.5 );
}

@end
