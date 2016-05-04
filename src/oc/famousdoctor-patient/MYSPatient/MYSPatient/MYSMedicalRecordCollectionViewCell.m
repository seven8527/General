//
//  MYSMedicalRecordCollectionViewCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMedicalRecordCollectionViewCell.h"
#import "UIColor+Hex.h"
#import <SDWebImage/UIImageView+WebCache.h>


//#define userIconWidth 20
//#define doctorIconWidth 45
//#define subViewMarginToLeft 10
//#define subViewMarginToRight 10
//#define timePicWidth 10

#define picWidth 60


@interface MYSMedicalRecordCollectionViewCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, weak) UIImageView *recordContentView;
@property (nonatomic, weak) UILabel *diseaseNameLabel;
@property (nonatomic, weak) UILabel *hospitalAndDepartmentLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIImageView *timePicView;
@property (nonatomic, weak) UIImageView *hospitalPicView;
@property (nonatomic, weak) UIView *picView;
@property (nonatomic, weak) UIImageView *bottomLine;
@end

@implementation MYSMedicalRecordCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor yellowColor];
        self.didSetupConstraints = NO;
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 2, 10)];
        topLine.backgroundColor = [UIColor colorFromHexRGB:KD1D1D1Color];
        [self.contentView addSubview:topLine];
        
        
        UIImageView *recordContentView = [UIImageView newAutoLayoutView];
        recordContentView.image = [[UIImage imageNamed:@"zoe_bg_white_"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 0.5, -2, 0.5) resizingMode:UIImageResizingModeTile];
        self.recordContentView = recordContentView;
        [self.contentView addSubview:recordContentView];
        
//        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, kScreen_Width, 10)];
//        bottomLine.backgroundColor = [UIColor colorFromHexRGB:KD1D1D1Color];
//        self.bottomLine = bottomLine;
//        [self addSubview:bottomLine];
        
        // 病名
        UILabel *diseaseNameLabel = [UILabel newAutoLayoutView];
        diseaseNameLabel.textColor = [UIColor colorFromHexRGB:K525252Color];
        diseaseNameLabel.font = [UIFont systemFontOfSize:14];
        [recordContentView addSubview:diseaseNameLabel];
        self.diseaseNameLabel = diseaseNameLabel;
        
        
        UIImageView *hospitalPicView = [UIImageView newAutoLayoutView];
        self.hospitalPicView = hospitalPicView;
        [recordContentView addSubview:hospitalPicView];
        
        // 医院和科室
        UILabel *hospitalAndDepartmentLabel = [UILabel newAutoLayoutView];
        hospitalAndDepartmentLabel.font = [UIFont systemFontOfSize:13];
        hospitalAndDepartmentLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        [recordContentView addSubview:hospitalAndDepartmentLabel];
        self.hospitalAndDepartmentLabel = hospitalAndDepartmentLabel;
        
        
        UIView *picView = [UIView newAutoLayoutView];
        self.picView = picView;
        picView.clipsToBounds = YES;
        [recordContentView addSubview:picView];
        
        
        UIImageView *timePicView = [[UIImageView alloc] init];
        self.timePicView = timePicView;
        [recordContentView addSubview:timePicView];
        
        
        // 就诊时间
        UILabel *timeLabel = [UILabel newAutoLayoutView];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
        [recordContentView addSubview:timeLabel];
        self.timeLabel = timeLabel;

    }
    
    [self updateViewConstraints];
    return self;
}

- (NSMutableArray *)picArray
{
    if (_picArray == nil) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.recordContentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [self.recordContentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.recordContentView autoSetDimensionsToSize:CGSizeMake(kScreen_Width - 20,156)];
        
        [self.diseaseNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:14];
        [self.diseaseNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.diseaseNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.diseaseNameLabel autoSetDimensionsToSize:CGSizeMake(kScreen_Width - 20, 14)];
        
        [self.hospitalPicView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.hospitalPicView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.diseaseNameLabel withOffset:10];
        [self.hospitalPicView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        
        [self.picView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [self.picView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.picView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.hospitalPicView withOffset:10];
        [self.picView autoSetDimension:ALDimensionHeight toSize:60];

        
        [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.hospitalPicView withOffset:5];
        [self.hospitalAndDepartmentLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.diseaseNameLabel withOffset:-12];
        [self.hospitalAndDepartmentLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.picView withOffset:10];
//        
//        [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
//        [self.bottomLine autoSetDimensionsToSize:CGSizeMake(self.frame.size.width, 10)];
        
        
        [self.timePicView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:14];
        [self.timePicView autoSetDimensionsToSize:CGSizeMake(11, 11)];
        [self.timePicView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.picView withOffset:10];
        
        [self.timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.timePicView withOffset:5];
        [self.timeLabel autoSetDimensionsToSize:CGSizeMake(kScreen_Width - 100, 12)];
        [self.timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.picView withOffset:10];
        self.didSetupConstraints = YES;
    } 
}

- (void)setModel:(MYSExpertGroupPatientRecordDataModel *)model
{
    _model = model;
    
    self.diseaseNameLabel.text = [model diagnosis];
    
    self.timePicView.image = [UIImage imageNamed:@"doctor_icon_time_"];
    
    self.hospitalPicView.image = [UIImage imageNamed:@"doctor_icon1_"];
    
    self.hospitalAndDepartmentLabel.text = [NSString stringWithFormat:@"%@  %@",[model hospital],[model department]];
    self.timeLabel.text = [model vistingTime];
    [self.picArray removeAllObjects];
//    for (MYSPatientRecordDataModel *recordModel in [model attList]) {
//        [self.picArray addObject:recordModel.filePath];
//    }
    NSMutableString *picStr;
    if(model.jianyandan.length > 0){
        picStr= [NSMutableString stringWithString:model.jianyandan];
        if ([picStr componentsSeparatedByString:@","].count <3) {
            if (model.binglidan.length > 0 ) {
                [picStr appendString:@","];
                [picStr appendString:model.binglidan];
                if ([picStr componentsSeparatedByString:@","].count <3) {
                    if (model.other.length > 0) {
                        [picStr appendString:@","];
                        [picStr appendString:model.other];
                    }
                }
                
            }
        }
    } else {
        if (model.binglidan.length > 0) {
            picStr= [NSMutableString stringWithString:model.binglidan];
            if ([picStr componentsSeparatedByString:@","].count <3) {
                    if ([picStr componentsSeparatedByString:@","].count <3) {
                        if (model.other.length > 0) {
                            [picStr appendString:@","];
                            [picStr appendString:model.other];
                        }
                    }
            }
        } else {
            if (model.other.length > 0) {
                picStr= [NSMutableString stringWithString:model.other];
            }
        }
    }
    
//    [self.picArray addObjectsFromArray:[picStr componentsSeparatedByString:@","]];
    NSArray *tempPicArry = [picStr componentsSeparatedByString:@","];
    
    if ([picStr componentsSeparatedByString:@","].count >=3) {
        [self.picArray addObjectsFromArray:[tempPicArry subarrayWithRange:NSMakeRange(0, 3)]];
    } else {
        [self.picArray addObjectsFromArray:tempPicArry];
    }
    
    for (UIImageView *imageView in self.picView.subviews) {
        [imageView removeFromSuperview];
    }
    
//    if (self.picArray.count > 6) {
//        
//        for (int i = 0; i < 5; i ++) {
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((picWidth + 12) * i, 0, 60, 60)];
//            imageView.backgroundColor = [UIColor orangeColor];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i]] placeholderImage:nil];
//            [self.picView addSubview:imageView];
//        }
//    } else {
        for (int i = 0; i < self.picArray.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((picWidth + 12) * i, 0, 60, 60)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.picArray[i]] placeholderImage:nil];
            [self.picView addSubview:imageView];
        }
//    }

}


@end
