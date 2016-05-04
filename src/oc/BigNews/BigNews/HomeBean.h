//
//  HomeBean.h
//  BigNews
//
//  Created by owen on 15/8/14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "JSONModel.h"

@interface HomeBean : JSONModel
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * img_url;

@end
