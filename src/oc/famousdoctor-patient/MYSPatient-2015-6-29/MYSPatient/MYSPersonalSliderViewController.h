//
//  MYSPersonalSliderViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
#import "XLScrollViewer.h"

@interface MYSPersonalSliderViewController : MYSBaseViewController
//@property (nonatomic, strong) id model;
@property (nonatomic, strong) XLScrollViewer *scroll;//如果无需外部调用XLScrollViewer的属性，则无需写此属性
@end
