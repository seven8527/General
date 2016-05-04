//
//  MYSExpertGroupDetailsDescriptionViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"

//@protocol MYSExpertGroupDetailsDescriptionViewControllerDelegate <NSObject>
//
//- (void)expertGroupDetailsDescriptionViewSavedWithContentStr:(NSString *)contentStr withMark:(int)mark;
//
//@end

@interface MYSExpertGroupDetailsDescriptionViewController : MYSBaseViewController
@property (nonatomic, copy) NSString *tipText;
@property (nonatomic, assign) int mark; // 标记 1 症状及体征 2 就医情况 3 何种帮助
@property (nonatomic, copy) NSString *contentStr; // 内容
@property (nonatomic, weak) id <MYSExpertGroupDetailsDescriptionViewControllerDelegate> delegate;
@end
