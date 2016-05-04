//
//  MYSCollectionViewCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSOrderModel.h"

//@protocol MYSCollectionViewCellDelegate <NSObject>
//
//- (void)collectionViewCellCheckOrderButtonClickWithModel:(id)model;
//
//@end

@interface MYSCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) MYSOrderModel *orderModel;
@end
