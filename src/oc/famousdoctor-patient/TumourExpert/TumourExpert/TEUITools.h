//
//  TEUITools.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TEUITools : NSObject

/**
 *  自定义状态栏
 */
+ (void)customStatusBar;

/**
 *  自定义导航栏
 */
+ (void)customNavigationBar;


/**
 *  隐藏表格多余的分割线
 *
 *  @param tableView 要隐藏的表格
 */
+ (void)hiddenTableExtraCellLine:(UITableView *)tableView;



+ (BOOL)enableLoadPic;
@end
