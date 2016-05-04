//
//  BNListOfNewsTableViewCell.h
//  BigNews
//
//  Created by Owen on 15-8-15.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNListOfNewsTableViewCell : UITableViewCell
@property (nonatomic ,strong) UILabel     *title;
//@property (nonatomic, strong) UILabel     *url;
@property (nonatomic, strong) UILabel     *content;
@property (nonatomic, strong) UILabel     *time;
@property (nonatomic, strong) UIImageView *img;
@end
