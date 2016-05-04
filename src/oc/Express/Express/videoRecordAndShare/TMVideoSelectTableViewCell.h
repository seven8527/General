//
//  TMVideoSelectTableViewCell.h
//  Twatch
//
//  Created by WangBo on 15/8/7.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMVideoButton.h"

@interface TMVideoSelectTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *leftVideoImageView;
@property (nonatomic, strong) IBOutlet UIButton *midVideoImageView;
@property (nonatomic, strong) IBOutlet UIButton *rightVideoImageView;


@property (nonatomic, strong) IBOutlet UIButton *leftPlayImageView;
@property (nonatomic, strong) IBOutlet UIButton *midPlayImageView;
@property (nonatomic, strong) IBOutlet UIButton *rightPlayImageView;

@property (nonatomic, strong) IBOutlet TMVideoButton *leftBtn; //点击
@property (nonatomic, strong) IBOutlet TMVideoButton *midBtn;
@property (nonatomic, strong) IBOutlet TMVideoButton *rightBtn;

@property (nonatomic, strong) IBOutlet TMVideoButton *leftCheck; //选择
@property (nonatomic, strong) IBOutlet TMVideoButton *midCheck;
@property (nonatomic, strong) IBOutlet TMVideoButton *rightCheck;


@end
