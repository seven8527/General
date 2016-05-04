//
//  MYSExpertGroupDynamicFrame.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSDoctorHomeDynamicModel.h"
@interface MYSExpertGroupDynamicFrame : NSObject
@property (nonatomic, strong) MYSDoctorHomeDynamicModel *dynamicModel;
@property (nonatomic, assign) CGRect titleLabelF;
@property (nonatomic, assign) CGRect picImageF;
@property (nonatomic, assign) CGRect timePicF;
@property (nonatomic, assign) CGRect timeLabelF;
@property (nonatomic, assign) CGRect firstLineF;
@property (nonatomic, assign) CGRect tipImageViewF;
@property (nonatomic, assign) CGRect secondLineF;
@property (nonatomic, assign) CGFloat cellHeight;
@end
