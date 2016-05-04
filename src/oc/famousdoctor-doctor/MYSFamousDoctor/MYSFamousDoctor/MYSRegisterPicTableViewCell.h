//
//  MYSRegisterPicTableViewCell.h
//  MYSFamousDoctor
//
//  Created by yanwb on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSRegisterPicTableViewCellDelegate <NSObject>

- (void)registerPicTabelViewCellDidClickPicButtonWithIndex:(NSInteger)index;

@end

@interface MYSRegisterPicTableViewCell : UITableViewCell
@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, weak) UITextView *tipTitleView;
@property (nonatomic, weak) UIButton *picButton;
@property (nonatomic, weak) UIImageView *picImageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id <MYSRegisterPicTableViewCellDelegate> delegate;
@end
