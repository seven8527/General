//
//  UIView+TEBadgeVifew.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LKBadgeView.h>

@interface TECircleView : UIView

@end

@interface UIView (TEBadgeView)

@property (nonatomic, assign) CGRect badgeViewFrame;
@property (nonatomic, strong, readonly) LKBadgeView *badgeView;

- (TECircleView *)setupCircleBadge;

@end
