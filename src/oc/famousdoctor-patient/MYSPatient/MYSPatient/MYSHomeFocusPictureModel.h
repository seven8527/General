//
//  MYSHomeFocusPictureModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface MYSHomeFocusPictureModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *picUrl; // 图片URL
@property (nonatomic, strong) NSString<Optional> *contentUrl; // 内容URL
@end
