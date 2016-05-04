//
//  DetailBean.h
//  BigNews
//
//  Created by owen on 15/8/17.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "JSONModel.h"

@interface DetailBean : JSONModel
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSString * image;

@end
