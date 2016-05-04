//
//  MYSNetConsultationDetailViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"
#import "MYSNetDetailTableViewCell.h"
#import "MYSNetDetailAllTableViewCell.h"
#import "MYSNetDetailDocTableViewCell.h"

@interface MYSNetConsultationDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, MYSNetDetailTableViewCellDelegate, MYSNetDetailAllTableViewCellDelegate>
{
    IBOutlet UITableView *mTableView;
    
    IBOutlet UITableViewCell *topCell;
    IBOutlet UITableViewCell *middleCell;
    IBOutlet UITableViewCell *fenGeCell;
    
    IBOutlet UIImageView *topImage;
    IBOutlet UILabel *topUserInfo;
    IBOutlet UILabel *topUserHeight;
    IBOutlet UILabel *topUserweight;
    IBOutlet UILabel *topUserSickness;
    IBOutlet UILabel *topHospital;
    IBOutlet UILabel *topDateTime;
    
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
    
    NSArray *jianYanDanURLArr;
    NSArray *jianChaBaoGaoURLArr;
    NSArray *qiTaZiLiaoURLArr;
}

- (void)sendValue:(NSString *)billno;

@end
