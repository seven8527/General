//
//  MYSExpertGroupChoosePayTypeView.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-27.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYSExpertGroupChoosePayTypeView;
@protocol MYSExpertGroupChoosePayTypeViewDelegate <NSObject>

@optional
- (void)actionSheet:(MYSExpertGroupChoosePayTypeView *)actionSheet payType:(NSString *)payType;
@end
@interface MYSExpertGroupChoosePayTypeView : UIView
+ (MYSExpertGroupChoosePayTypeView *)actionSheetWithCancelButtonTitle:(NSString *)commitTitle withImageArray:(NSArray *)imageArray andTitleArray:(NSArray *)titleArray;

@property (nonatomic,assign) id<MYSExpertGroupChoosePayTypeViewDelegate> delegate;

- (void)showInView:(UIView *)view;

- (void)showInWindow;

- (void)showInViewFromLeft:(UIView *)view;

- (void)showInWindowFromLeft;

- (void)dismiss;

@end
