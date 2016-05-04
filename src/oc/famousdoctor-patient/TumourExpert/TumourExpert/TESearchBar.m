//
//  TESearchBar.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESearchBar.h"

@implementation TESearchBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:0.0 alpha:1];
        [self changeBarTextfieldWithColor: color bgImageName: kBgTextFieldImageName];
        [self changeBarCancelButtonWithColor:[UIColor greenColor] bgImageName:@"button_go0.png"];
    }
    return self;
}

- (void)changeBarTextfieldWithColor:(UIColor *)color bgImageName:(NSString *)bgImageName
{
    self.tintColor = color;
    
    UITextField *textField;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.1f) {
        for (UIView *subv in self.subviews) {
            for (UIView* view in subv.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                    textField = (UITextField*)view;
                    textField.layer.borderWidth=1;
                    textField.layer.cornerRadius=6;
                    textField.layer.borderColor=color.CGColor;
                    break;
                }
            }
        }
    }else{
        for (UITextField *subv in self.subviews) {
            if ([subv isKindOfClass:[UITextField class]]) {
                textField = (UITextField*)subv;
                break;
            }
        }
    }
    
    // 设置文本框背景
    NSArray *subs = self.subviews;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]  > 6.1f) { // ios 7
        for (int i = 0; i < [subs count]; i++) {
            UIView* subv = (UIView*)[self.subviews objectAtIndex:i];
            for (UIView* subview in subv.subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                {
                    [subview setHidden:YES];
                    [subview removeFromSuperview];
                    break;
                }
            }
        }
    }else{
        for (int i = 0; i < [subs count]; i++) {
            UIView* subv = (UIView*)[self.subviews objectAtIndex:i];
            if ([subv isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subv removeFromSuperview];
                break;
            }
        }
    }
    
    UIImage *searchBarBgImage = [UIImage imageNamed:bgImageName];
    [textField setBackground:searchBarBgImage];
}

- (void)changeBarCancelButtonWithColor:(UIColor *)textColor bgImageName:(NSString *)bgImageName
{
    for (UIView *searchbuttons in self.subviews)
    {
        
        if ([searchbuttons isKindOfClass:[UIButton class]]) // ios7以下
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            cancelButton.enabled = YES;
            [cancelButton setTitleColor:textColor forState:UIControlStateNormal];
            [cancelButton setTitleColor:textColor forState:UIControlStateSelected];
            if (bgImageName)
            {
                [cancelButton setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
                [cancelButton setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateSelected];
            }
            break;
        }
    }
}

@end
