//
//  TETextConsultDetailViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-29.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETextConsultDetailViewController.h"
#import "TEUITools.h"
#import "TEConsultCell.h"
#import "TEConsultReplyCell.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEConsultReply.h"
#import "TEConsultReplyModel.h"
#import "MDHTMLLabel.h"
#import "TECloseRemindModel.h"
#import "TEHttpTools.h"

// 咨询状态
typedef NS_ENUM(NSInteger, TEConsultState) {
    TEConsultStateNotAudit         = 0,  // 未审核
    TEConsultStateAuditing         = 1,  // 审核中
    TEConsultStateAuditApproved    = 2,  // 审核通过
};


@interface TETextConsultDetailViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) NSMutableArray *replies;
@property (nonatomic, strong) NSString *dataId; // 资料id

@property (nonatomic, strong) UILabel *promptLabel; // 提示语
@property (nonatomic, strong) UILabel *dataLabel; // 咨询资料
@property (nonatomic, strong) UILabel *stateLabel; // 资料状态
@property (nonatomic, assign) BOOL isAnswer; // 专家是否回答了第一个问题
@end

@implementation TETextConsultDetailViewController

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.replies = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_replies removeAllObjects];
            [self fetchTextConsultDetail];
        });
    };
    
    reach.unreachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Failmark.png"]];
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.labelText = @"似乎已断开与互联网的连接";
            [HUD hide:YES afterDelay:2];
        });
    };
    
    [reach startNotifier];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configUI];
    
    [self layoutUI];
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
    self.title = @"网络咨询详情";
}

// UI布局
- (void)layoutUI
{
    // Create a rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"补充资料" style:UIBarButtonItemStyleBordered target:self action:@selector(supplementData:)];
    
    // Create a UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
    
    CGSize boundingSize = CGSizeMake(300, CGFLOAT_MAX);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 71)];
    
    // 咨询资料
    UILabel *promptDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 21)];
    promptDataLabel.text = @"咨询资料：";
    promptDataLabel.font = [UIFont boldSystemFontOfSize:17];
    promptDataLabel.textColor = [UIColor colorWithHex:0x383838];
    promptDataLabel.backgroundColor = [UIColor clearColor];
    CGSize promptDataSize = [promptDataLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptDataLabel.frame = CGRectMake(20, 20, promptDataSize.width, 21);
    [view addSubview:promptDataLabel];
    
    _dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptDataSize.width, 20, 200, 21)];
    _dataLabel.font = [UIFont boldSystemFontOfSize:17];
    _dataLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    _dataLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:_dataLabel];
    
    // 资料状态
    UILabel *promptStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 21)];
    promptStateLabel.text = @"审核状态：";
    promptStateLabel.font = [UIFont boldSystemFontOfSize:17];
    promptStateLabel.textColor = [UIColor colorWithHex:0x383838];
    promptStateLabel.backgroundColor = [UIColor clearColor];
    CGSize promptStateSize = [promptStateLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
    promptStateLabel.frame = CGRectMake(20, 50, promptStateSize.width, 21);
    [view addSubview:promptStateLabel];
    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + promptStateSize.width, 50, 200, 21)];
    _stateLabel.font = [UIFont boldSystemFontOfSize:17];
    _stateLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
    _stateLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:_stateLabel];
    
    self.tableView.tableHeaderView = view;
}

- (void)layoutFooterView
{
    if ([self.replies count] < 4) {
    
        // 表尾
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 112)];
        
        // 继续追问专家
        UIButton *askButton = [UIButton buttonWithType:UIButtonTypeCustom];
        askButton.frame = CGRectMake(21, 20, 277, 51);
        askButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [askButton setTitle:@"继续追问专家" forState:UIControlStateNormal];
        [askButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        [askButton setBackgroundImage:[UIImage imageNamed:@"button0.png"] forState:UIControlStateDisabled];
        
        for (TEConsultReply *reply in self.replies) {
            if (reply.question && [reply.question length] > 0 ) {
                if (reply.answer == nil || [reply.answer length] == 0) {
                    [askButton setEnabled:NO];
                    break;
                }
            }
        }
        [askButton addTarget:self action:@selector(askExpert:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:askButton];
        
        // 提示语
        CGSize boundingSize = CGSizeMake(300, CGFLOAT_MAX);
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.text = [NSString stringWithFormat:@"您还有%d次追问专家的机会", 4 - [self.replies count]];
        _promptLabel.font = [UIFont boldSystemFontOfSize:14];
        _promptLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
        CGSize promptSize = [_promptLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:15]];
        _promptLabel.frame = CGRectMake((kScreen_Width - promptSize.width) / 2, 81, promptSize.width, 21);
        [self.footerView addSubview:_promptLabel];
        
        self.tableView.tableFooterView = self.footerView;
    } else {
        self.tableView.tableFooterView = nil;
        [self closeRemind];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return [self.replies count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    TEConsultReplyCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TEConsultReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    TEConsultReply *reply = (TEConsultReply *)[self.replies objectAtIndex:indexPath.section];
    cell.promptLabel.text = reply.prompt;
    cell.userLabel.text = @"我";
    cell.questionLabel.htmlText = reply.question;
    cell.doctorLabel.text = self.expertName;
    cell.answerLabel.htmlText = reply.answer;
    if (reply.answer == nil || [reply.answer length] <= 0) {
        cell.answerLabel.textColor = [UIColor colorWithHex:0x9e9e9e];
        cell.answerLabel.htmlText = @"专家还未回复您的问题";
        cell.answerLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return [TEConsultReplyCell rowHeightWitObject:[self.replies objectAtIndex:indexPath.section]];
}

#pragma mark - API methods

// 获取网络咨询详情
- (void)fetchTextConsultDetail
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"seereply"];
    NSDictionary *parameters = @{@"type": self.consultType, @"pqid": self.consultId};
    
    
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEConsultReplyModel *replyModel = [[TEConsultReplyModel alloc] initWithDictionary:responseObject error:nil];
        _dataLabel.text =  replyModel.dataName;
        self.dataId = replyModel.dataId;
        if (replyModel.consultState == TEConsultStateNotAudit) {
            _stateLabel.text = @"未审核";
        } else if (replyModel.consultState == TEConsultStateAuditing) {
            _stateLabel.text = @"正在审核";
        } else if (replyModel.consultState == TEConsultStateAuditApproved) {
            _stateLabel.text = @"审核通过";
        }
        
        if ([replyModel.question length] > 0) {
            TEConsultReply *reply = [[TEConsultReply alloc] init];
            reply.prompt = @"问题一";
            reply.question = replyModel.question;
            reply.answer = replyModel.answer;
            [_replies addObject:reply];
            
            if (![reply.answer isEqualToString:@""] && [reply.answer length] > 0) {
                _isAnswer = YES;
            } else {
                _isAnswer = NO;
            }
        }
        
        if ([replyModel.firstQuestion length] > 0) {
            TEConsultReply *reply = [[TEConsultReply alloc] init];
            reply.prompt = @"追问一";
            reply.question = replyModel.firstQuestion;
            reply.answer = replyModel.firstAnswer;
            [_replies addObject:reply];
        }
        
        if ([replyModel.secondQuestion length] > 0) {
            TEConsultReply *reply = [[TEConsultReply alloc] init];
            reply.prompt = @"追问二";
            reply.question = replyModel.secondQuestion;
            reply.answer = replyModel.secondAnswer;
            [_replies addObject:reply];
        }
        
        if ([replyModel.thirdQuestion length] > 0) {
            TEConsultReply *reply = [[TEConsultReply alloc] init];
            reply.prompt = @"追问三";
            reply.question = replyModel.thirdQuestion;
            reply.answer = replyModel.thirdAnswer;
            [_replies addObject:reply];
        }
        
        [self layoutFooterView];
        
        [self.tableView reloadData];
        
        [hud hide:YES];

    } failure:^(NSError *error) {
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEConsultReplyModel *replyModel = [[TEConsultReplyModel alloc] initWithDictionary:responseObject error:nil];
//        _dataLabel.text =  replyModel.dataName;
//        self.dataId = replyModel.dataId;
//        if (replyModel.consultState == TEConsultStateNotAudit) {
//            _stateLabel.text = @"未审核";
//        } else if (replyModel.consultState == TEConsultStateAuditing) {
//            _stateLabel.text = @"正在审核";
//        } else if (replyModel.consultState == TEConsultStateAuditApproved) {
//            _stateLabel.text = @"审核通过";
//        }
//
//        if ([replyModel.question length] > 0) {
//            TEConsultReply *reply = [[TEConsultReply alloc] init];
//            reply.prompt = @"问题一";
//            reply.question = replyModel.question;
//            reply.answer = replyModel.answer;
//            [_replies addObject:reply];
//            
//            if (![reply.answer isEqualToString:@""] && [reply.answer length] > 0) {
//                _isAnswer = YES;
//            } else {
//                _isAnswer = NO;
//            }
//        }
//        
//        if ([replyModel.firstQuestion length] > 0) {
//            TEConsultReply *reply = [[TEConsultReply alloc] init];
//            reply.prompt = @"追问一";
//            reply.question = replyModel.firstQuestion;
//            reply.answer = replyModel.firstAnswer;
//            [_replies addObject:reply];
//        }
//        
//        if ([replyModel.secondQuestion length] > 0) {
//            TEConsultReply *reply = [[TEConsultReply alloc] init];
//            reply.prompt = @"追问二";
//            reply.question = replyModel.secondQuestion;
//            reply.answer = replyModel.secondAnswer;
//            [_replies addObject:reply];
//        }
//        
//        if ([replyModel.thirdQuestion length] > 0) {
//            TEConsultReply *reply = [[TEConsultReply alloc] init];
//            reply.prompt = @"追问三";
//            reply.question = replyModel.thirdQuestion;
//            reply.answer = replyModel.thirdAnswer;
//            [_replies addObject:reply];
//        }
//        
//        [self layoutFooterView];
//
//        [self.tableView reloadData];
//        
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
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
        
        [self.tableView reloadData];
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
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
}

#pragma mark - Bussiness methods

- (void)askExpert:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEConsultQuestionViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEConsultQuestionViewControllerProtocol)];
    viewController.consultId = self.consultId;
    
    
    if ([self.replies count] == 1) {
        viewController.title = @"追问一";
        viewController.nextQuestion = @"first_question";
    } else if ([self.replies count] == 2) {
        viewController.title = @"追问二";
        viewController.nextQuestion = @"second_question";
    } else if ([self.replies count] == 3) {
        viewController.title = @"追问三";
        viewController.nextQuestion = @"third_question";
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)supplementData:(id)sender
{
    if (_isAnswer) {
        self.hidesBottomBarWhenPushed = YES;
        UIViewController <TESupplementDataViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TESupplementDataViewControllerProtocol)];
        viewController.patientDataId = self.dataId;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"专家未回复您的问题，您不能补充资料" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
