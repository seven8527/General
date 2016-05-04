//
//  UASearchBar.h
//  UASearchBar
//
//  Created by Umair Aamir on 5/21/14.
//  Copyright (c) 2014 Confiz Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UASearchBarDelegate.h"
#import "UITextField+PlaceholderColor.h"

@interface UASearchBar : UIView <UITextFieldDelegate>

@property (nonatomic, assign) id<UASearchBarDelegate> delegate;

@property (nonatomic, strong) NSString *placeHolder;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UITextField *textField;

// user can set his own search icon
-(void)setSearchIcon:(NSString *)icon;
// show cancel button animated
-(void)setShowsCancelButton:(BOOL)show;
-(void)setShowsCancelButton:(BOOL)show animated:(BOOL)animated;
// chance cancel button title color
-(void)setCancelButtonTitleColor:(UIColor *)color forState:(UIControlState)state;
// change cancel button color
-(void)setCancelButtonTintColor:(UIColor *)color;
-(void)setCancelButtonBackgroundColor:(UIColor *)color;
// change captilization mode
-(void)setAutoCapitalizationMode:(UITextAutocapitalizationType)type;
// can change placeholder color
-(void)setPlaceHolderColor:(UIColor*)color;
// change cancel button title
-(void)setCancelButtonTitle:(NSString *)title forState:(UIControlState)state;

@end
