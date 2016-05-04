//
//  MYSFaceToFaceDetailViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"
#import "MYSNetDetailTableViewCell.h"
#import "MYSNetDetailAllTableViewCell.h"

@interface MYSFaceToFaceDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MYSNetDetailTableViewCellDelegate, MYSNetDetailAllTableViewCellDelegate>
{
    IBOutlet UITableView *mTableView;
    
    // 头部Cell - 有确认时间的
    IBOutlet UITableViewCell *topCell1;
    // 头部Cell - 没有确认时间的
    IBOutlet UITableViewCell *topCell2;
    
    // 中部Cell - 检验单
    IBOutlet UITableViewCell *middleCell;
    
    // 分隔线10px-Cell
    IBOutlet UITableViewCell *marginCell;
    
    // 有确认时间
    IBOutlet UIImageView *topImage;
    IBOutlet UILabel *topUserInfo;
    IBOutlet UILabel *topUserHeight;
    IBOutlet UILabel *topUserweight;
    IBOutlet UILabel *topAddDate;
    IBOutlet UILabel *topType;
    IBOutlet UILabel *topBillNo;
    IBOutlet UILabel *topQueRenTime;
    IBOutlet UILabel *topQiWangTime;
    
    // 无确认时间
    IBOutlet UIImageView *topImage1;
    IBOutlet UILabel *topUserInfo1;
    IBOutlet UILabel *topUserHeight1;
    IBOutlet UILabel *topUserweight1;
    IBOutlet UILabel *topAddDate1;
    IBOutlet UILabel *topType1;
    IBOutlet UILabel *topBillNo1;
    IBOutlet UILabel *topQiWangTime1;
    
    // 检验单Image
    IBOutlet UIImageView *middleJYDImage1;
    IBOutlet UIImageView *middleJYDImage2;
    IBOutlet UIImageView *middleJYDImage3;
    // 检查报告Image
    IBOutlet UIImageView *middleBGImage1;
    IBOutlet UIImageView *middleBGImage2;
    IBOutlet UIImageView *middleBGImage3;
    // 其他资料Image
    IBOutlet UIImageView *middleOtherImage1;
    IBOutlet UIImageView *middleOtherImage2;
    IBOutlet UIImageView *middleOtherImage3;
    
    
    NSMutableArray *mData;
    
    NSString *mBillNo;
    NSInteger mAudit_status;
    
    NSArray *jianYanDanURLArr;
    NSArray *jianChaBaoGaoURLArr;
    NSArray *qiTaZiLiaoURLArr;
}

- (void)sendValue:(NSString *)billno audit_status:(NSInteger)audit_status;

@end
