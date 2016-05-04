//
//  MYSSettingCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSettingCell.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSStoreManager.h"
#import "AppDelegate.h"

@interface MYSSettingCell ()
@property (nonatomic, weak) UISwitch *rightSwitch;
@property (nonatomic, copy) NSString *isOpen;
@property (nonatomic, assign) NSInteger integer;
@end

@implementation MYSSettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
        UISwitch *rightSwitch = [UISwitch newAutoLayoutView];
        self.rightSwitch = rightSwitch;
        [rightSwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:rightSwitch];
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        
        [self updateViewConstraints];
    }
    
    return self;
}


- (void)updateViewConstraints
{
        // 开关
    [self.rightSwitch autoSetDimension:ALDimensionWidth toSize:44];
    [self.rightSwitch autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [self.rightSwitch autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8];
    [self.rightSwitch autoSetDimension:ALDimensionHeight toSize:30];
    
    
}

- (void)setisOpen:(NSString *)isOpen withIndex:(NSInteger )integer
{
    self.isOpen = isOpen;
    self.integer = integer;
    
    if ([isOpen isEqual:@"1"]) {
        [self.rightSwitch setOn:YES];
    } else {
        [self.rightSwitch setOn:NO];
    }
}


- (void)valueChange:(UISwitch *)rightSwitch
{
    if ([self.isOpen  isEqual:@"1"]) {
        self.isOpen = @"0";
    } else {
        self.isOpen = @"1";
    }
    NSUserDefaults *settingDefaults = [NSUserDefaults standardUserDefaults];
    if (self.integer == 0) {
        [settingDefaults setObject:self.isOpen forKey:@"replay"];
    } else if (self.integer == 1) {
        [settingDefaults setObject:self.isOpen forKey:@"order"];
    } else {
       [settingDefaults setObject:self.isOpen forKey:@"dynamic"];
    }
}

@end
