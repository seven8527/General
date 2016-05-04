//
//  MYSExpertGroupSliderViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

//#import "ViewPagerController.h"
#import "MYSBaseViewController.h"
#import "MYSExpertGroupDynamicViewController.h"
#import "MYSExpertGroupExpertiseViewController.h"
#import "MYSExpertGroupRecordViewController.h"
#import "XLScrollViewer.h"
@interface MYSExpertGroupSliderViewController : MYSBaseViewController
@property (nonatomic, strong) MYSExpertGroupExpertiseViewController *expertiseVC;
@property (nonatomic, strong) MYSExpertGroupDynamicViewController *dynamicVC;
@property (nonatomic, strong) MYSExpertGroupRecordViewController *recordVC;
@property (nonatomic, strong) id model;
@property (nonatomic, strong) XLScrollViewer *scroll;//如果无需外部调用XLScrollViewer的属性，则无需写此属性
@end
