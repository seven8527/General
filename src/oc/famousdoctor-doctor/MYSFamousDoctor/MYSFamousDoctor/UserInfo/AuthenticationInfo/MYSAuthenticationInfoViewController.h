//
//  MYSAuthenticationInfoViewController.h
//  MYSFamousDoctor
//
//  认证资料
//
//  Created by lyc on 15/4/10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSAuthenticationInfoViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    
    // 头像Cell
    IBOutlet UITableViewCell *headCell;
    // 姓名，座机号，手机号Cell
    IBOutlet UITableViewCell *topCell;
    // 姓名，座机号，手机号Cell
    IBOutlet UITableViewCell *middleCell;
    // 相关证件Cell
    IBOutlet UITableViewCell *bottomCell;
    
    // 头像
    IBOutlet UIImageView *headImageView;
    // 姓名
    IBOutlet UILabel *docName;
    // 座机
    IBOutlet UILabel *docTelephone;
    // 手机号
    IBOutlet UILabel *docCellphone;
    // 职称
    IBOutlet UILabel *docZhicheng;
    // 擅长
    IBOutlet UILabel *docShanchang;
    // 所在医院
    IBOutlet UILabel *docYiyuan;
    // 坐在科室
    IBOutlet UILabel *docKeshi;
    
    NSMutableArray *mData;
    
    NSString *authentication_occupation;
    NSString *mShanchang;
}

@end
