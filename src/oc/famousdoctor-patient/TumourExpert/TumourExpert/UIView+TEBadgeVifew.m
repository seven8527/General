//
//  UIView+TEBadgeVifew.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "UIView+TEBadgeVifew.h"

#import <objc/runtime.h>

@implementation TECircleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect)));
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.829 green:0.194 blue:0.257 alpha:1.000].CGColor);
    
    CGContextFillPath(context);
}

@end


static NSString const * TEBadgeViewKey = @"TEBadgeViewKey";
static NSString const * TEBadgeViewFrameKey = @"TEBadgeViewFrameKey";

static NSString const * TECircleBadgeViewKey = @"TECircleBadgeViewKey";

@implementation UIView (TEBadgeView)

- (void)setBadgeViewFrame:(CGRect)badgeViewFrame {
    objc_setAssociatedObject(self, &TEBadgeViewFrameKey, NSStringFromCGRect(badgeViewFrame), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)badgeViewFrame {
    return CGRectFromString(objc_getAssociatedObject(self, &TEBadgeViewFrameKey));
}

- (LKBadgeView *)badgeView {
    LKBadgeView *badgeView = objc_getAssociatedObject(self, &TEBadgeViewKey);
    if (badgeView)
        return badgeView;
    
    badgeView = [[LKBadgeView alloc] initWithFrame:self.badgeViewFrame];
    [self addSubview:badgeView];
    
    self.badgeView = badgeView;
    
    return badgeView;
}

- (void)setBadgeView:(LKBadgeView *)badgeView {
    objc_setAssociatedObject(self, &TEBadgeViewKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TECircleView *)setupCircleBadge {
    self.opaque = NO;
    self.clipsToBounds = NO;
    TECircleView *circleView = objc_getAssociatedObject(self, &TECircleBadgeViewKey);
    if (circleView)
        return circleView;
    
    if (!circleView) {
        circleView = [[TECircleView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, 8, 8)];
        [self addSubview:circleView];
        objc_setAssociatedObject(self, &TECircleBadgeViewKey, circleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return circleView;
}

@end
