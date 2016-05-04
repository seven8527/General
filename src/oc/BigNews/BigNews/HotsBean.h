//
//  HotsBean.h
//  BigNews
//
//  Created by owen on 15/8/18.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "JSONModel.h"

@interface HotsBean : JSONModel
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * url;

@end
