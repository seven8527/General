//
//  TESearchBar.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBgTextFieldImageName @"input_rectangle.png"

@interface TESearchBar : UISearchBar <UISearchBarDelegate>
- (void)changeBarTextfieldWithColor:(UIColor *)color bgImageName:(NSString *)bgImageName;
- (void)changeBarCancelButtonWithColor:(UIColor *)textColor bgImageName:(NSString *)bgImageName;
@end
