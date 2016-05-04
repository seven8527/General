//
//  TEExpertArticleViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEBaseViewController.h"

@interface TEExpertArticleViewController : TEBaseViewController <TEExpertArticleViewControllerProtocol, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property (nonatomic, strong) NSString *articleId; // 文章id
@end
