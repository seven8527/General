//
//  TEHomeFocusPictureModel.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEHomeFocusPictureModel @end

@interface TEHomeFocusPictureModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *focusPicTitle; // 焦点图标题
@property (nonatomic, strong) NSString<Optional> *focusPicUrl; // 焦点图路径
@property (nonatomic, strong) NSString<Optional> *healthInfoID; // 健康资讯ID
@end
