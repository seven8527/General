//
//  MYSExpertGroupRecordFrame.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSExpertGroupRecordModel.h"

@interface MYSExpertGroupRecordFrame : NSObject
@property (nonatomic, strong) MYSExpertGroupRecordModel * recordModel;
@property (nonatomic, assign) CGRect titleLabelF;
@property (nonatomic, assign) CGRect timePicF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect firstLineF;
@property (nonatomic, assign) CGRect tipImageViewF;
@property (nonatomic, assign) CGRect secondLineF;
@property (nonatomic, assign) CGFloat cellHeight;
@end
