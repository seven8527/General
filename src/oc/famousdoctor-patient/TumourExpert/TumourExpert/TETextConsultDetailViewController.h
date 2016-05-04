//
//  TETextConsultDetailViewController.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TETextConsultDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *consultId; // 咨询Id
@property (nonatomic, strong) NSString *expertName; // 专家姓名
@end
