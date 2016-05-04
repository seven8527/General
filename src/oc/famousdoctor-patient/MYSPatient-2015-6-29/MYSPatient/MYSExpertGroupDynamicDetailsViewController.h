//
//  MYSExpertGroupDynamicDetailsViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-16.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"

@interface MYSExpertGroupDynamicDetailsViewController : MYSBaseViewController
@property (nonatomic, copy) NSString *dynamicId;
@property (nonatomic, strong) MYSDoctorHomeIntroducesModel *introducesModel;
@end
