//
//  TERadioButton.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TERadioButtonDelegate
- (void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId;
@end

@interface TERadioButton : UIView
@property (nonatomic,  strong) NSString *groupId;
@property (nonatomic,  assign) NSUInteger index;
@property (nonatomic, strong) UIButton *button;

- (id)initWithGroupId:(NSString *)groupId index:(NSUInteger)index;
+ (void)addObserverForGroupId:(NSString *)groupId observer:(id)observer;

@end

