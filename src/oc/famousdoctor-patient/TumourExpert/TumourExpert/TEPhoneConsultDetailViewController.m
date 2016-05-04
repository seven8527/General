//
//  TEPhoneConsultDetailViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPhoneConsultDetailViewController.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEPhoneConsultDetailModel.h"
#import "TECloseRemindModel.h"
#import "TEHttpTools.h"

// 咨询状态
typedef NS_ENUM(NSInteger, TEConsultState) {
    TEConsultStateNotAudit         = 0,  // 未审核
    TEConsultStateAuditing         = 1,  // 审核中
    TEConsultStateAuditApproved    = 2,  // 审核通过
};

@interface TEPhoneConsultDetailViewController ()
@property (nonatomic, strong) UILabel *dataLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *orderIdLabel;
@property (nonatomic, strong) UILabel *expertLabel;
@property (nonatomic, strong) UILabel *patientLabel;
@property (nonatomic, strong) UILabel *referralTimeLabel;
@property (nonatomic, strong) UILabel *orderTimeLabel;
@end

@implementation TEPhoneConsultDetailViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchPhoneConsultDetail];
        });
    };
    
    [reach startNotifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

// UI设置
- (void)configUI
{
    // 设置标题
    self.title = @"电话咨询详情";
}

// UI布局
- (void)layoutUI
{
    CGSize boundingSize = CGSizeMake(300, CGFLOAT_MAX);
    
    // 咨询资料
    UILabel *promptDataLabel = [[UILabel alloc] init];
    promptDataLabel.text = @"咨询资料：";
    promptDataLabel.font = [UIFont boldSystemFontOfSize:17];
    promptDataLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize promptDataSize = [promptDataLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptDataLabel.frame = CGRectMake(20, 20, promptDataSize.width, 21);
    [self.view addSubview:promptDataLabel];
    
    _dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptDataSize.width, 20, 200, 21)];
    _dataLabel.font = [UIFont boldSystemFontOfSize:17];
    _dataLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_dataLabel];
    
    // 资料状态
    UILabel *promptStateLabel = [[UILabel alloc] init];
    promptStateLabel.text = @"审核状态：";
    promptStateLabel.font = [UIFont boldSystemFontOfSize:17];
    promptStateLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize promptStateSize = [promptStateLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptStateLabel.frame = CGRectMake(20, 50, promptStateSize.width, 21);
    [self.view addSubview:promptStateLabel];
    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptStateSize.width, 50, 200, 21)];
    _stateLabel.font = [UIFont boldSystemFontOfSize:17];
    _stateLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_stateLabel];
    
    // 订单号
    UILabel *promptOrderIdLabel = [[UILabel alloc] init];
    promptOrderIdLabel.text = @"订  单  号：";
    promptOrderIdLabel.font = [UIFont boldSystemFontOfSize:17];
    promptOrderIdLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize promptOrderIdSize = [promptOrderIdLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptOrderIdLabel.frame = CGRectMake(20, 80, promptOrderIdSize.width, 21);
    [self.view addSubview:promptOrderIdLabel];
    
    _orderIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptOrderIdSize.width, 80, 200, 21)];
    _orderIdLabel.font = [UIFont boldSystemFontOfSize:17];
    _orderIdLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_orderIdLabel];
    
    // 专家
    UILabel *promptExpertLabel = [[UILabel alloc] init];
    promptExpertLabel.text = @"专       家：";
    promptExpertLabel.font = [UIFont boldSystemFontOfSize:17];
    promptExpertLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize promptExpertSize = [promptExpertLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptExpertLabel.frame = CGRectMake(20, 110, promptExpertSize.width, 21);
    [self.view addSubview:promptExpertLabel];
    
    _expertLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptExpertSize.width, 110, 200, 21)];
    _expertLabel.font = [UIFont boldSystemFontOfSize:17];
    _expertLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_expertLabel];
    
    // 患者姓名
    UILabel *promptPatientLabel = [[UILabel alloc] init];
    promptPatientLabel.text = @"患者姓名：";
    promptPatientLabel.font = [UIFont boldSystemFontOfSize:17];
    promptPatientLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize promptPatientSize = [promptPatientLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptPatientLabel.frame = CGRectMake(20, 140, promptPatientSize.width, 21);
    [self.view addSubview:promptPatientLabel];
    
    _patientLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptPatientSize.width, 140, 200, 21)];
    _patientLabel.font = [UIFont boldSystemFontOfSize:17];
    _patientLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_patientLabel];
    
    // 预约时间
    UILabel *promptReferralLabel = [[UILabel alloc] init];
    promptReferralLabel.text = @"预约时间：";
    promptReferralLabel.font = [UIFont boldSystemFontOfSize:17];
    promptReferralLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize promptReferralSize = [promptReferralLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptReferralLabel.frame = CGRectMake(20, 170, promptReferralSize.width, 21);
    [self.view addSubview:promptReferralLabel];
    
    _referralTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptReferralSize.width, 170, 200, 21)];
    _referralTimeLabel.font = [UIFont boldSystemFontOfSize:17];
    _referralTimeLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_referralTimeLabel];
    
    // 订单时间
    UILabel *promptOrderLabel = [[UILabel alloc] init];
    promptOrderLabel.text = @"订单时间：";
    promptOrderLabel.font = [UIFont boldSystemFontOfSize:17];
    promptOrderLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize promptOrderSize = [promptOrderLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptOrderLabel.frame = CGRectMake(20, 200, promptOrderSize.width, 21);
    [self.view addSubview:promptOrderLabel];
    
    _orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptOrderSize.width, 200, 200, 21)];
    _orderTimeLabel.font = [UIFont boldSystemFontOfSize:17];
    _orderTimeLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_orderTimeLabel];
    
}

#pragma mark - API methods

// 获取电话咨询详情
- (void)fetchPhoneConsultDetail
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"seereply"];
    NSDictionary *parameters = @{@"type": self.consultType, @"pqid": self.consultId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEPhoneConsultDetailModel *phoneDetail = [[TEPhoneConsultDetailModel alloc] initWithDictionary:responseObject error:nil];
        _dataLabel.text = phoneDetail.dataName;
        _orderIdLabel.text = phoneDetail.orderId;
        _expertLabel.text = phoneDetail.expertName;
        _patientLabel.text = phoneDetail.patientName;
        _referralTimeLabel.text = phoneDetail.referralTime;
        _orderTimeLabel.text = phoneDetail.orderTime;
        
        if (phoneDetail.consultState == TEConsultStateNotAudit) {
            _stateLabel.text = @"未审核";
        } else if (phoneDetail.consultState == TEConsultStateAuditing) {
            _stateLabel.text = @"正在审核";
        } else if (phoneDetail.consultState == TEConsultStateAuditApproved) {
            _stateLabel.text = @"审核通过";
        }
        
        if (phoneDetail.referralTime && ![phoneDetail.referralTime isEqualToString:@""]) {
            [self closeRemind];
        }
    } failure:^(NSError *error) {

    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEPhoneConsultDetailModel *phoneDetail = [[TEPhoneConsultDetailModel alloc] initWithDictionary:responseObject error:nil];
//        _dataLabel.text = phoneDetail.dataName;
//        _orderIdLabel.text = phoneDetail.orderId;
//        _expertLabel.text = phoneDetail.expertName;
//        _patientLabel.text = phoneDetail.patientName;
//        _referralTimeLabel.text = phoneDetail.referralTime;
//        _orderTimeLabel.text = phoneDetail.orderTime;
//        
//        if (phoneDetail.consultState == TEConsultStateNotAudit) {
//            _stateLabel.text = @"未审核";
//        } else if (phoneDetail.consultState == TEConsultStateAuditing) {
//            _stateLabel.text = @"正在审核";
//        } else if (phoneDetail.consultState == TEConsultStateAuditApproved) {
//            _stateLabel.text = @"审核通过";
//        }
//        
//        if (phoneDetail.referralTime && ![phoneDetail.referralTime isEqualToString:@""]) {
//            [self closeRemind];
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//    }];
}

// 关闭提醒
- (void)closeRemind
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"close_question"];
    NSDictionary *parameters = @{@"type": self.consultType, @"pqid": self.consultId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TECloseRemindModel *consult = [[TECloseRemindModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = consult.state;
        if ([state isEqualToString:@"201"]) {
            ;
        }
    } failure:^(NSError *error) {
        
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TECloseRemindModel *consult = [[TECloseRemindModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = consult.state;
//        if ([state isEqualToString:@"201"]) {
//            ;
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
}

@end

