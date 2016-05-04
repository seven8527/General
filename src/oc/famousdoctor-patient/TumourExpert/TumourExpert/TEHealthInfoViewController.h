//
//  TEHealthInfoViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseViewController.h"

@interface TEHealthInfoViewController : TEBaseViewController <DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property (nonatomic, strong) NSString *healthInfoId; // 资讯id
@end

