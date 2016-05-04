//
//  TEConsultMultipleChoiceCell.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TEConsultMultipleChoiceCell : UITableViewCell
{
    UIImageView *  _mSelectedIndicator; //show the selected mark
    BOOL           _mSelected;        //differ from property selected
    UILabel * _accessLable;
}

@property (nonatomic, assign) BOOL mSelected;
@property (nonatomic, assign) BOOL showSelectedIndicator;
@property (nonatomic, strong) id contentModel;
@property (nonatomic, assign) BOOL showAccessLable;
- (void)changeMSelectedState;

@end
