//
//  MYSExpertGroupRecordCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupRecordCell.h"
#import "UIColor+Hex.h"


@interface MYSExpertGroupRecordCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *timePicView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *firstLine;
@property (nonatomic, weak) UIView *secondLine;
@property (nonatomic, weak) UIImageView *tipImageView;
@end

@implementation MYSExpertGroupRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
        
    }
    return self;
}


- (void)setupViews
{
    UIView *firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.firstLine = firstLine;
    [self.contentView addSubview:firstLine];
    
    UIImageView *tipImageView = [[UIImageView alloc] init];
    tipImageView.image = [UIImage imageNamed:@"doctor_point_"];
    self.tipImageView = tipImageView;
    [self.contentView addSubview:tipImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 0;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UIImageView *timePicView = [[UIImageView alloc] init];
    timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
    self.timePicView = timePicView;
    [self.contentView addSubview:timePicView];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    timeLabel.font = [UIFont fontWithName:@"Helvetica Light" size:13];
    self.timeLabel = timeLabel;
    [self.contentView addSubview:timeLabel];
    
    UIView *secondLine = [[UIView alloc] init];
    secondLine.backgroundColor = [UIColor colorFromHexRGB:KEDEDEDColor];
    self.secondLine = secondLine;
    [self.contentView addSubview:secondLine];
    
}

- (void)setRecordFrame:(MYSExpertGroupRecordFrame *)recordFrame
{
    
    _recordFrame = recordFrame;
    
    MYSExpertGroupRecordModel *recordModel = recordFrame.recordModel;
    
    self.firstLine.frame = recordFrame.firstLineF;
    
    self.tipImageView.frame = recordFrame.tipImageViewF;
    NSString *title;
    if (recordModel.title.length > 30) {
        title = [NSString stringWithFormat:@"%@.....",[recordModel.title substringToIndex:30]];
    } else {
        title = recordModel.title;
    }

    self.titleLabel.text = title;
    self.titleLabel.frame = recordFrame.titleLabelF;
    
    
    self.timePicView.frame = recordFrame.timePicF;
    
    self.timeLabel.frame = recordFrame.timeLabelF;
    self.timeLabel.text = recordModel.time;
    
    self.secondLine.frame = recordFrame.secondLineF;
    
}

@end
