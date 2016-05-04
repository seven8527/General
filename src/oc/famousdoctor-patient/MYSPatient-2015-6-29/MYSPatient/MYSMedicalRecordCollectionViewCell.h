//
//  MYSMedicalRecordCollectionViewCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSExpertGroupPatientRecordDataModel.h"
@interface MYSMedicalRecordCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) MYSExpertGroupPatientRecordDataModel *model;
@property (nonatomic, strong) NSMutableArray *picArray;
@end
