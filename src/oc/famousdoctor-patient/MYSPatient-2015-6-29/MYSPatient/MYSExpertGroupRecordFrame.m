//
//  MYSExpertGroupRecordFrame.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupRecordFrame.h"
#import "MYSFoundationCommon.h"

#define leftMargin 15

@implementation MYSExpertGroupRecordFrame

- (void)setRecordModel:(MYSExpertGroupRecordModel *)recordModel
{
    _recordModel = recordModel;
    
    self.firstLineF = CGRectMake(leftMargin, 0, 2, 10.5);
    
    self.tipImageViewF = CGRectMake(leftMargin - 7/2, CGRectGetMaxY(self.firstLineF) + 6.5, 7, 7);
    
    CGSize maxSize = CGSizeMake(kScreen_Width - CGRectGetMaxX(self.tipImageViewF) - 15 - leftMargin, MAXFLOAT);
    
    NSString *title;
    if (recordModel.title.length > 30) {
        title = [NSString stringWithFormat:@"%@.....",[recordModel.title substringToIndex:30]];
    } else {
        title = recordModel.title;
    }
    
    CGSize titleSize = [MYSFoundationCommon sizeWithText:title withFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize];
    
    self.titleLabelF = CGRectMake(CGRectGetMaxX(self.tipImageViewF) +15, 14, titleSize.width, titleSize.height);
    
    self.timePicF = CGRectMake(CGRectGetMinX(self.titleLabelF), CGRectGetMaxY(self.titleLabelF) + 12, 10, 10);
    
    self.timeLabelF = CGRectMake(CGRectGetMaxX(self.timePicF) + 5, CGRectGetMaxY(self.titleLabelF) + 10, 200, 12);
    
    
    self.cellHeight = CGRectGetMaxY(self.timeLabelF) + 14;
    
    self.secondLineF = CGRectMake(leftMargin, CGRectGetMaxY(self.tipImageViewF) + 6.5, 2, self.cellHeight - CGRectGetMaxY(self.tipImageViewF) - 6.5 );
}

@end
