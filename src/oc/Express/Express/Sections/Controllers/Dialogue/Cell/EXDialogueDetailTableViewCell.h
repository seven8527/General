//
//  EXDialogueDetailTableViewCell.h
//  Express
//
//  Created by owen on 15/11/16.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MLEmojiLabel.h"
#import "FSVoiceBubble.h"

@interface EXDialogueDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * timeLB;
@property (nonatomic, strong) UILabel * sysMsgLB;

@property (nonatomic, strong) UIImageView   * imageLogo;
@property (nonatomic, strong) UILabel   * labelName;
@property (nonatomic, strong) UIImageView   * imageBg;

@property (nonatomic, strong) MLEmojiLabel *emojiLabel;
@property (nonatomic, strong) FSVoiceBubble *fSVoiceBubble;

@property (nonatomic, strong) UIImageView   * imageContent;

@property (nonatomic, strong) UIView *  sendStateView; //发送中状态view


-(void)updateViewConstraints;
@end
