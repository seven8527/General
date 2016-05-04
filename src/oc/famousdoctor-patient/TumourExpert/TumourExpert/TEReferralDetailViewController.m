//
//  TEReferralDetailViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEReferralDetailViewController.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEReferralDetailModel.h"
#import "TECloseRemindModel.h"
#import "TEHttpTools.h"

// 咨询状态
typedef NS_ENUM(NSInteger, TEConsultState) {
    TEConsultStateNotAudit         = 0,  // 未审核
    TEConsultStateAuditing         = 1,  // 审核中
    TEConsultStateAuditApproved    = 2,  // 审核通过
};

@interface TEReferralDetailViewController ()
@property (nonatomic, strong) UILabel *dataLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *flowLabel;
@property (nonatomic, strong) UILabel *expertLabel;
@property (nonatomic, strong) UILabel *patientLabel;
@property (nonatomic, strong) UILabel *referralTimeLabel;
@property (nonatomic, strong) UILabel *orderTimeLabel;

@property (nonatomic, strong) UILabel *promptExpertLabel;
@property (nonatomic, strong) UILabel *promptPatientLabel;
@property (nonatomic, strong) UILabel *promptReferralTimeLabel;
@property (nonatomic, strong) UILabel *promptOrderTimeLabel;
@end

@implementation TEReferralDetailViewController

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
            [self fetchReferralDetail];
        });
    };
    
    [reach startNotifier];
}


#pragma mark - UI

// UI设置
- (void)configUI
{
    // 设置标题
    self.title = @"线下咨询详情";
}

// UI布局
- (void)layoutUI
{
    CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
    
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
    
    // 线下咨询流程
    UILabel *promptFlowLabel = [[UILabel alloc] init];
    promptFlowLabel.text = @"线下咨询流程：";
    promptFlowLabel.font = [UIFont boldSystemFontOfSize:17];
    promptFlowLabel.textColor = [UIColor colorWithHex:0x383838];
    CGSize promptFlowSize = [promptFlowLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptFlowLabel.frame = CGRectMake(20, 80, promptFlowSize.width, 21);
    [self.view addSubview:promptFlowLabel];
    
    _flowLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _flowLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _flowLabel.numberOfLines = 0;
    _flowLabel.font = [UIFont boldSystemFontOfSize:17];
    _flowLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_flowLabel];

    // 专家
    _promptExpertLabel = [[UILabel alloc] init];
    _promptExpertLabel.text = @"专       家：";
    _promptExpertLabel.font = [UIFont boldSystemFontOfSize:17];
    _promptExpertLabel.textColor = [UIColor colorWithHex:0x383838];
    [self.view addSubview:_promptExpertLabel];
    
    _expertLabel = [[UILabel alloc] init];
    _expertLabel.font = [UIFont boldSystemFontOfSize:17];
    _expertLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_expertLabel];
    
    // 患者姓名
    _promptPatientLabel = [[UILabel alloc] init];
    _promptPatientLabel.text = @"患者姓名：";
    _promptPatientLabel.font = [UIFont boldSystemFontOfSize:17];
    _promptPatientLabel.textColor = [UIColor colorWithHex:0x383838];
    [self.view addSubview:_promptPatientLabel];
    
    _patientLabel = [[UILabel alloc] init];
    _patientLabel.font = [UIFont boldSystemFontOfSize:17];
    _patientLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_patientLabel];
    
    // 转诊时间
    _promptReferralTimeLabel = [[UILabel alloc] init];
    _promptReferralTimeLabel.text = @"转诊时间：";
    _promptReferralTimeLabel.font = [UIFont boldSystemFontOfSize:17];
    _promptReferralTimeLabel.textColor = [UIColor colorWithHex:0x383838];
    [self.view addSubview:_promptReferralTimeLabel];
    
    _referralTimeLabel = [[UILabel alloc] init];
    _referralTimeLabel.font = [UIFont boldSystemFontOfSize:17];
    _referralTimeLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_referralTimeLabel];
    
    // 订单时间
    _promptOrderTimeLabel = [[UILabel alloc] init];
    _promptOrderTimeLabel.text = @"订单时间：";
    _promptOrderTimeLabel.font = [UIFont boldSystemFontOfSize:17];
    _promptOrderTimeLabel.textColor = [UIColor colorWithHex:0x383838];
    [self.view addSubview:_promptOrderTimeLabel];
    
    _orderTimeLabel = [[UILabel alloc] init];
    _orderTimeLabel.font = [UIFont boldSystemFontOfSize:17];
    _orderTimeLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    [self.view addSubview:_orderTimeLabel];

}


#pragma mark - API methods

// 获取线下咨询详情
- (void)fetchReferralDetail
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"seereply"];
    NSDictionary *parameters = @{@"type": self.consultType, @"pqid": self.consultId};
    NSLog(@"%@  %@", self.consultType, self.consultId);
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEReferralDetailModel *referralDetail = [[TEReferralDetailModel alloc] initWithDictionary:responseObject error:nil];
        _dataLabel.text = referralDetail.dataName;
        _flowLabel.text = referralDetail.referralFlow;
        _expertLabel.text = referralDetail.expertName;
        _patientLabel.text = referralDetail.patientName;
        _referralTimeLabel.text = referralDetail.referralTime;
        _orderTimeLabel.text = referralDetail.orderTime;
        
        if (referralDetail.consultState == TEConsultStateNotAudit) {
            _stateLabel.text = @"未审核";
        } else if (referralDetail.consultState == TEConsultStateAuditing) {
            _stateLabel.text = @"正在审核";
        } else if (referralDetail.consultState == TEConsultStateAuditApproved) {
            _stateLabel.text = @"审核通过";
        }
        
        if (referralDetail.referralTime && ![referralDetail.referralTime isEqualToString:@""]) {
            [self closeRemind];
        }
        
        CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
        
        CGSize flowSize = [_flowLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _flowLabel.frame = CGRectMake(20, 100, flowSize.width, flowSize.height);
        
        CGSize promptExpertSize = [_promptExpertLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _promptExpertLabel.frame = CGRectMake(20, 110 + flowSize.height, promptExpertSize.width, 21);
        
        CGSize expertSize = [_expertLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _expertLabel.frame = CGRectMake(20 + promptExpertSize.width, 110 + flowSize.height, expertSize.width, 21);
        
        CGSize promptPatientSize = [_promptPatientLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _promptPatientLabel.frame = CGRectMake(20, 140 + flowSize.height, promptPatientSize.width, 21);
        
        CGSize patientSize = [_patientLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _patientLabel.frame = CGRectMake(20 + promptPatientSize.width, 140 + flowSize.height, patientSize.width, 21);
        
        CGSize promptReferralTimeSize = [_promptReferralTimeLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _promptReferralTimeLabel.frame = CGRectMake(20, 170 + flowSize.height, promptReferralTimeSize.width, 21);
        
        CGSize referralTimeSize = [_referralTimeLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _referralTimeLabel.frame = CGRectMake(20 + promptReferralTimeSize.width, 170 + flowSize.height, referralTimeSize.width, 21);
        
        CGSize promptOrderTimeSize = [_promptOrderTimeLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _promptOrderTimeLabel.frame = CGRectMake(20, 200 + flowSize.height, promptOrderTimeSize.width, 21);
        
        CGSize orderTimeSize = [_orderTimeLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        _orderTimeLabel.frame = CGRectMake(20 + promptOrderTimeSize.width, 200 + flowSize.height, orderTimeSize.width, 21);

    } failure:^(NSError *error) {
        
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEReferralDetailModel *referralDetail = [[TEReferralDetailModel alloc] initWithDictionary:responseObject error:nil];
//        _dataLabel.text = referralDetail.dataName;
//        _flowLabel.text = referralDetail.referralFlow;
//        _expertLabel.text = referralDetail.expertName;
//        _patientLabel.text = referralDetail.patientName;
//        _referralTimeLabel.text = referralDetail.referralTime;
//        _orderTimeLabel.text = referralDetail.orderTime;
//        
//        if (referralDetail.consultState == TEConsultStateNotAudit) {
//            _stateLabel.text = @"未审核";
//        } else if (referralDetail.consultState == TEConsultStateAuditing) {
//            _stateLabel.text = @"正在审核";
//        } else if (referralDetail.consultState == TEConsultStateAuditApproved) {
//            _stateLabel.text = @"审核通过";
//        }
//        
//        if (referralDetail.referralTime && ![referralDetail.referralTime isEqualToString:@""]) {
//            [self closeRemind];
//        }
//        
//        CGSize boundingSize = CGSizeMake(280, CGFLOAT_MAX);
//        
//        CGSize flowSize = [_flowLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _flowLabel.frame = CGRectMake(20, 100, flowSize.width, flowSize.height);
//        
//        CGSize promptExpertSize = [_promptExpertLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _promptExpertLabel.frame = CGRectMake(20, 110 + flowSize.height, promptExpertSize.width, 21);
//        
//        CGSize expertSize = [_expertLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _expertLabel.frame = CGRectMake(20 + promptExpertSize.width, 110 + flowSize.height, expertSize.width, 21);
//
//        CGSize promptPatientSize = [_promptPatientLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _promptPatientLabel.frame = CGRectMake(20, 140 + flowSize.height, promptPatientSize.width, 21);
//        
//        CGSize patientSize = [_patientLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _patientLabel.frame = CGRectMake(20 + promptPatientSize.width, 140 + flowSize.height, patientSize.width, 21);
//        
//        CGSize promptReferralTimeSize = [_promptReferralTimeLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _promptReferralTimeLabel.frame = CGRectMake(20, 170 + flowSize.height, promptReferralTimeSize.width, 21);
//        
//        CGSize referralTimeSize = [_referralTimeLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _referralTimeLabel.frame = CGRectMake(20 + promptReferralTimeSize.width, 170 + flowSize.height, referralTimeSize.width, 21);
//        
//        CGSize promptOrderTimeSize = [_promptOrderTimeLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _promptOrderTimeLabel.frame = CGRectMake(20, 200 + flowSize.height, promptOrderTimeSize.width, 21);
//        
//        CGSize orderTimeSize = [_orderTimeLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        _orderTimeLabel.frame = CGRectMake(20 + promptOrderTimeSize.width, 200 + flowSize.height, orderTimeSize.width, 21);
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
