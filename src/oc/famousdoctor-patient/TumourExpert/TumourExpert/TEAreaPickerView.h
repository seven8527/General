//
//  TEAreaPickerView.h
//  TumourExpert
//
//  Created by 闫文波 on 14-9-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TEAreaPickerWithStateAndCity,
    TEAreaPickerWithStateAndCityAndDistrict
} TEAreaPickerStyle;


@interface TEAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (copy, nonatomic) NSString *selectedState; // 省
@property (copy, nonatomic) NSString *selectedCity; // 市
@property (copy, nonatomic) NSString *selectedDistrict; // 区
@property (nonatomic, assign) TEAreaPickerStyle pickerStyle;

- (id)initWithWithStyle:(TEAreaPickerStyle)pickerStyle andFrame:(CGRect)frame;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;
@end
