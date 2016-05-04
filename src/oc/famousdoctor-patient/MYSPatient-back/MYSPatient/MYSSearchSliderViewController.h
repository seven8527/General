//
//  MYSSearchSliderViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-18.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
#import "XLScrollViewer.h"
#import "MYSSearch.h"
#import "MYSDoctorSearchViewController.h"
#import "MYSDiseaseSearchViewController.h"

@interface MYSSearchSliderViewController : MYSBaseViewController
@property (nonatomic, strong) XLScrollViewer *scroll;//如果无需外部调用XLScrollViewer的属性，则无需写此属性
@property (nonatomic, strong) MYSSearch * search;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, strong) MYSDoctorSearchViewController *doctorSearchVC;
@property (nonatomic, strong) MYSDiseaseSearchViewController *diseaseSearchVC;
@end
