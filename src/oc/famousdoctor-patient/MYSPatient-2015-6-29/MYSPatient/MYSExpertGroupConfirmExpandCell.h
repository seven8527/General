//
//  MYSExpertGroupConfirmExpandCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-31.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSExpertGroupConfirmExpandCellDelegate <NSObject>

- (void)expertGroupConfirmExpandCellDidClickStatusWithIndex:(NSInteger)index andStatusOpen:(BOOL)isOpen;

@end

@interface MYSExpertGroupConfirmExpandCell : UITableViewCell
@property (nonatomic, weak) UILabel *titleTipLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *tipStr;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, assign) CGFloat expandHeight;
@property (nonatomic, weak) id <MYSExpertGroupConfirmExpandCellDelegate> delegate;
@property (nonatomic, assign) BOOL isOpen;
@end
