//
//  MYSExpertGroupConsultDoctorCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSExpertGroupAskModel.h"
#import "MYSPersonalOrderDetailsModel.h"

@interface MYSExpertGroupConsultDoctorCell : UITableViewCell
@property (nonatomic, strong) MYSExpertGroupAskModel *askModel;
@property (nonatomic, copy) NSString *consultType;
@property (nonatomic, strong) MYSPersonalOrderDetailsModel *orderDetails;
@property (nonatomic, copy) NSString *doctorPic;
@end
