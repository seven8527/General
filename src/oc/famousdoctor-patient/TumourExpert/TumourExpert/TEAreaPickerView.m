//
//  TEAreaPickerView.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAreaPickerView.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2
#define AreaViewWidth [UIScreen mainScreen].bounds.size.width

@interface TEAreaPickerView ()

@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) NSDictionary *areaDic;
@property (strong, nonatomic) NSArray *province;
@property (strong, nonatomic) NSArray *city;
@property (strong, nonatomic) NSArray *district;
@property (strong, nonatomic) NSString *selectedProvince; // 第一列选中的参数 为了给第二列传参
@property (strong, nonatomic) NSArray *region;

@end
@implementation TEAreaPickerView
- (id)initWithWithStyle:(TEAreaPickerStyle)pickerStyle andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"region" ofType:@"plist"];
        
        // 行政区数据源
        NSArray *region = [[NSArray alloc] initWithContentsOfFile:plistPath];
        self.region = region;
        
        NSMutableArray *tempProvinceArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempCityArray = [[NSMutableArray alloc] init];
        NSMutableArray *tempDistrictArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *regionDict in region) {
            [tempProvinceArray addObject:[regionDict objectForKey:@"name"]];
        }
        self.province = tempProvinceArray;
        for (NSDictionary *regionDict in [region[0] objectForKey:@"cityList"]) {
            [tempCityArray addObject:[regionDict objectForKey:@"name"]];
        }
        self.city = tempCityArray;
        [tempDistrictArray addObjectsFromArray:[[[region[0] objectForKey:@"cityList"] objectAtIndex:0] objectForKey:@"areaList"]];
        self.district = tempDistrictArray;
        
        self.picker = [[UIPickerView alloc] initWithFrame: frame];
        self.picker.backgroundColor = [UIColor whiteColor];
        self.pickerStyle = pickerStyle;
        self.picker.dataSource = self;
        self.picker.delegate = self;
        self.picker.showsSelectionIndicator = YES;
        [self.picker selectRow: 0 inComponent: 0 animated: YES];
        
        [self addSubview: self.picker];
        
        self.selectedProvince = [self.province objectAtIndex: 0];
    }
    return self;
}


#pragma mark--UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == TEAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else {
        return 2;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerStyle == TEAreaPickerWithStateAndCityAndDistrict) {
        if (component == PROVINCE_COMPONENT) {
            return [self.province count];
        } else if (component == CITY_COMPONENT) {
            return [self.city count];
        } else {
            return [self.district count];
        }
    } else {
        if (component == PROVINCE_COMPONENT) {
            return [self.province count];
        } else {
            return [self.city count];
        }
        
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == TEAreaPickerWithStateAndCityAndDistrict) {
        
        if (component == PROVINCE_COMPONENT) {
            return [self.province objectAtIndex: row];
        } else if (component == CITY_COMPONENT) {
            return [self.city objectAtIndex: row];
        } else {
            return [self.district objectAtIndex: row];
        }
    } else {
        if (component == PROVINCE_COMPONENT) {
            return [self.province objectAtIndex: row];
        } else  {
            return [self.city objectAtIndex: row];
        }
        
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (self.pickerStyle == TEAreaPickerWithStateAndCityAndDistrict) {
        
        if (component == PROVINCE_COMPONENT) {
            
            NSMutableArray *tempProvinceArray = [[NSMutableArray alloc] init];
            NSMutableArray *tempCityArray = [[NSMutableArray alloc] init];
            NSMutableArray *tempDistrictArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *regionDict in self.region) {
                [tempProvinceArray addObject:[regionDict objectForKey:@"name"]];
            }
            self.province = tempProvinceArray;
            for (NSDictionary *regionDict in [self.region[row] objectForKey:@"cityList"]) {
                [tempCityArray addObject:[regionDict objectForKey:@"name"]];
            }
            self.city = tempCityArray;
            [tempDistrictArray addObjectsFromArray:[[[self.region[row] objectForKey:@"cityList"] objectAtIndex:0] objectForKey:@"areaList"]];
            self.district = tempDistrictArray;
            self.selectedProvince = [self.province objectAtIndex:row];
            
            [self.picker reloadComponent: CITY_COMPONENT];
            [self.picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
            [self.picker reloadComponent: DISTRICT_COMPONENT];
            [self.picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            
        } else if (component == CITY_COMPONENT) {
            NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[self.province indexOfObject:self.selectedProvince]];
            NSMutableArray *tempDistrictArray = [[NSMutableArray alloc] init];
            [tempDistrictArray addObjectsFromArray:[[[self.region[[provinceIndex integerValue]] objectForKey:@"cityList"] objectAtIndex:row] objectForKey:@"areaList"]];
            self.district = tempDistrictArray;
            self.selectedCity =  [self.city objectAtIndex:row];
            [self.picker reloadComponent: DISTRICT_COMPONENT];
            [self.picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        }
        
        NSInteger provinceIndex = [self.picker selectedRowInComponent: PROVINCE_COMPONENT];
        NSInteger cityIndex = [self.picker selectedRowInComponent: CITY_COMPONENT];
        NSInteger districtIndex = [self.picker selectedRowInComponent: DISTRICT_COMPONENT];
        
        NSString *provinceStr = [self.province objectAtIndex: provinceIndex];
        NSString *cityStr = [self.city objectAtIndex: cityIndex];
        NSString *districtStr = [self.district objectAtIndex:districtIndex];
        
        self.selectedState = provinceStr;
        self.selectedCity = cityStr;
        self.selectedDistrict = districtStr;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:nil userInfo:nil];
    } else {
        
        if (component == PROVINCE_COMPONENT) {
            self.selectedProvince = [self.province objectAtIndex: row];
            
            NSMutableArray *tempProvinceArray = [[NSMutableArray alloc] init];
            NSMutableArray *tempCityArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *regionDict in self.region) {
                [tempProvinceArray addObject:[regionDict objectForKey:@"name"]];
            }
            self.province = tempProvinceArray;
            for (NSDictionary *regionDict in [self.region[row] objectForKey:@"cityList"]) {
                [tempCityArray addObject:[regionDict objectForKey:@"name"]];
            }
            self.city = tempCityArray;
            self.selectedProvince = [self.province objectAtIndex:row];
            self.selectedCity =  [self.city objectAtIndex:0];
            self.selectedDistrict = [self.district objectAtIndex:0];
            
            [self.picker reloadComponent: CITY_COMPONENT];
            [self.picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        }
        else if (component == CITY_COMPONENT) {
            NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[self.province indexOfObject: self.selectedProvince]];
            NSMutableArray *tempDistrictArray = [[NSMutableArray alloc] init];
            [tempDistrictArray addObjectsFromArray:[[[self.region[[provinceIndex integerValue]] objectForKey:@"cityList"] objectAtIndex:row] objectForKey:@"areaList"]];
            self.district = tempDistrictArray;
            self.selectedCity =  [self.city objectAtIndex:row];
            [self.picker reloadComponent: DISTRICT_COMPONENT];
            [self.picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            
        }
        NSInteger provinceIndex = [self.picker selectedRowInComponent: PROVINCE_COMPONENT];
        NSInteger cityIndex = [self.picker selectedRowInComponent: CITY_COMPONENT];
        
        NSString *provinceStr = [self.province objectAtIndex: provinceIndex];
        NSString *cityStr = [self.city objectAtIndex: cityIndex];
        
        if ([provinceStr isEqualToString: cityStr]) {
            cityStr = @"";
        }
        self.selectedState = provinceStr;
        self.selectedCity = cityStr;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeValue" object:nil userInfo:nil];
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.pickerStyle == TEAreaPickerWithStateAndCityAndDistrict) {
        
        if (component==PROVINCE_COMPONENT) {
            return AreaViewWidth * 0.3;
        }
        if (component==CITY_COMPONENT) {
            return AreaViewWidth * 0.3;
        }
        if (component==DISTRICT_COMPONENT) {
            return AreaViewWidth * 0.4;
        }
    } else {
        if (component == PROVINCE_COMPONENT) {
            return AreaViewWidth * 0.4;
        }
        if (component == CITY_COMPONENT) {
            return AreaViewWidth * 0.6;
        }
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    if (self.pickerStyle == TEAreaPickerWithStateAndCityAndDistrict) {
        if (component == PROVINCE_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.province objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        } else if (component == CITY_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.city objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        } else {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.district objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
    } else {
        if (component == PROVINCE_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.province objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        } else  {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [self.city objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
        
    }
    return myView;
}



#pragma mark - animation

- (void)showInView:(UIView *) view
{
    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    [self pickerView:self.picker didSelectRow:0 inComponent:0];
    [self.picker reloadComponent: PROVINCE_COMPONENT];
    [self.picker selectRow:0 inComponent:0 animated:NO];
}

- (void)cancelPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}



@end
