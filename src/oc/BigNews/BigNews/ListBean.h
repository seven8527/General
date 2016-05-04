//
//  ListBean.h
//  BigNews
//
//  Created by Owen on 15-8-15.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "JSONModel.h"

@interface ListBean : JSONModel
@property (nonatomic ,strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *img;
//"img": "http://s.cimg.163.com/photo/0001/2015-08-15/B12MR3G400AP0001.jpg.670x270.jpg",
//"title": "核生化应急救援队于天津爆炸核心区救出一幸存者",
//"time": "新华网 2015-08-15 14:43",
//"content": "北京卫戍区防化团15日下午在天津港8·12爆炸核心区爆炸点50米处，救出一名50多岁的男子，目前该男子已被送到天津市的解放军254医院救治。新华社记者刚刚从天津公安消防总队确认，目前共有13位天津消防总队官兵牺牲，11位失联。继１４日１８时...",
//"url": "/15/0815/14/R1WLADEK2UCJB39N.html"
@end
