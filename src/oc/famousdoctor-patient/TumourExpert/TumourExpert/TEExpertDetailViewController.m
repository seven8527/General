//
//  TEExpertDetailViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-22.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertDetailViewController.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "TEExpertDetail.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TEConvertButton.h"
#import "MDHTMLLabel.h"
#import "TEHomeViewController.h"
#import "TEExpertViewController.h"
#import "TEAppDelegate.h"
#import "TEFoundationCommon.h"
#import "UIImageView+NetLoading.h"
#import "TEHttpTools.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH kScreen_Width
#define CELL_CONTENT_MARGIN 10.0f

@interface TEExpertDetailViewController ()
@property (nonatomic, strong) TEExpertDetailModel *detailModel;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *doctorLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *hospitalLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *forteLabel;
@property (nonatomic, strong) MDHTMLLabel *introduceLabel;

@property (nonatomic, strong) NSString *forte; // 专家擅长
@property (nonatomic, strong) NSString *intro; // 专家简介
@end

@implementation TEExpertDetailViewController

#pragma mark - UIViewController lifecycle

- (id)init
{
    if (self = [super init]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataSource removeAllObjects];
            [self fetchExpertDetail];
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
    self.title = @"专家详情";
}

// UI布局
- (void)layoutUI
{
    CGRect tableViewFrame = self.tableView.frame;

    tableViewFrame.size.height -= 53;
    self.tableView.frame = tableViewFrame;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 80)];
    
    // 医生头像
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 53, 53)];
    [headerView addSubview:_iconImageView];
    
    
    // 医生标签
    _doctorLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 17, 68, 21)];
    _doctorLabel.font = [UIFont boldSystemFontOfSize:17];
    _doctorLabel.textColor = [UIColor colorWithHex:0x383838];
    [headerView addSubview:_doctorLabel];
    
    // 职称标签
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 38, 213, 21)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:13];
    _titleLabel.textColor = [UIColor colorWithHex:0x838383];
    [headerView addSubview:_titleLabel];
    
    // 医院标签
    _hospitalLabel = [[UILabel alloc] initWithFrame:CGRectMake(77, 59, 150, 21)];
    _hospitalLabel.font = [UIFont boldSystemFontOfSize:14];
    _hospitalLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
    [headerView addSubview:_hospitalLabel];
    
    // 科室标签
    _departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 59, 83, 21)];
    _departmentLabel.font = [UIFont boldSystemFontOfSize:14];
    _departmentLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
    [headerView addSubview:_departmentLabel];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    CGFloat verticalY = self.tableView.frame.size.height - [TEFoundationCommon getAdapterHeight];
    
    // 网络咨询按钮
    UIButton *picAskButton = [[UIButton alloc] initWithFrame:CGRectMake(15, verticalY + 11.5, (kScreen_Width - 60 )/3, 30.0)];
    picAskButton.tag = 0;
    [picAskButton setTitle:@"网络咨询" forState:UIControlStateNormal];
    [picAskButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [picAskButton setBackgroundColor:[UIColor colorWithHex:0x006ed7]];
    picAskButton.layer.cornerRadius = 10;
    [picAskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [picAskButton addTarget:self action:@selector(askExpert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:picAskButton];
    
    // 电话咨询按钮
    UIButton *phoneAskButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreen_Width - 60 )/3 + 30, verticalY + 11.5, (kScreen_Width - 60 )/3, 30.0)];
    phoneAskButton.tag = 1;
    [phoneAskButton setTitle:@"电话咨询" forState:UIControlStateNormal];
    [phoneAskButton setBackgroundColor:[UIColor colorWithHex:0x00a876]];
    [phoneAskButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [phoneAskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneAskButton.layer.cornerRadius = 10;
    [phoneAskButton addTarget:self action:@selector(askExpert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneAskButton];
    
    // 线下咨询按钮
    UIButton *offLineAskButton = [[UIButton alloc] initWithFrame:CGRectMake( 2 * (kScreen_Width - 60 )/3 + 45 , verticalY + 11.5 , (kScreen_Width - 60 )/3 , 30.0)];
    offLineAskButton.tag = 2;
    offLineAskButton.layer.cornerRadius = 10;
    offLineAskButton.backgroundColor = [UIColor colorWithHex:0xe6662a];
    [offLineAskButton setTitle:@"面对面咨询" forState:UIControlStateNormal];
    [offLineAskButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [offLineAskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [offLineAskButton addTarget:self action:@selector(askExpert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:offLineAskButton];
    
    // 画线
    UIImage *image = [UIImage imageNamed:@"line_d1d1d1.png"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, verticalY, kScreen_Width, 1)];
    topLine.image = image;
    [self.view addSubview:topLine];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.text = [(TEExpertArticleModel *)[self.dataSource objectAtIndex:indexPath.row] title];
    }
    return cell;
}

#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEExpertArticleViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertArticleViewControllerProtocol)];
    viewController.articleId = [(TEExpertArticleModel *)[self.dataSource objectAtIndex:indexPath.row] articleId];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);

        if (self.forte == nil) {
            self.forte = @"";
        }
        NSAttributedString *forteAttributedText = [[NSAttributedString alloc] initWithString:self.forte attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x6b6b6b], NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}];
        CGRect forteRect = [forteAttributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize forteSize = forteRect.size;
        CGFloat forteHeight = MAX(forteSize.height, 21.0f);
        
        if (self.intro == nil) {
            self.intro = @"";
        }
        NSAttributedString *introduceAttributedText = [[NSAttributedString alloc] initWithString:self.intro attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x6b6b6b], NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}];
        CGRect introduceRect = [introduceAttributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize introduceSize = introduceRect.size;
        CGFloat introduceHeight = MAX(introduceSize.height, 21.0f);

        return forteHeight + introduceHeight + CELL_CONTENT_MARGIN * 3 + 42;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 0.0)];
    
    if (section == 0) {
        customView.backgroundColor = [UIColor colorWithHex:0xfafafa];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);

        // 擅长疾病
        UILabel *promptForteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, 100, 21)];
        promptForteLabel.text = @"擅长";
        promptForteLabel.font = [UIFont boldSystemFontOfSize:15];
        promptForteLabel.textColor = [UIColor colorWithHex:0x383838];
        promptForteLabel.backgroundColor = [UIColor clearColor];
        [customView addSubview:promptForteLabel];

        _forteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_forteLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_forteLabel setMinimumScaleFactor:FONT_SIZE];
        [_forteLabel setNumberOfLines:0];
        [_forteLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [_forteLabel setBackgroundColor:[UIColor clearColor]];


        if (self.forte == nil) {
            self.forte = @"";
        }
        NSAttributedString *forteAttributedText = [[NSAttributedString alloc] initWithString:self.forte attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x6b6b6b], NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}];
        CGRect forteRect = [forteAttributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize forteSize = forteRect.size;
        [_forteLabel setText:self.forte];
        [_forteLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + 21, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(forteSize.height, 21.0f))];
        [customView addSubview:_forteLabel];
        
        // 专家简介
        UILabel *promptIntroduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN * 2 + 21 + MAX(forteSize.height, 21.0f), 100, 21)];
        promptIntroduceLabel.text = @"简介";
        promptIntroduceLabel.font = [UIFont boldSystemFontOfSize:15];
        promptIntroduceLabel.textColor = [UIColor colorWithHex:0x383838];
        promptIntroduceLabel.backgroundColor = [UIColor clearColor];
        [customView addSubview:promptIntroduceLabel];
        
        _introduceLabel = [[MDHTMLLabel alloc] initWithFrame:CGRectZero];
        [_introduceLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_introduceLabel setMinimumScaleFactor:FONT_SIZE];
        [_introduceLabel setNumberOfLines:0];
        [_introduceLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];;
        [_introduceLabel setBackgroundColor:[UIColor clearColor]];
        
        if (self.intro == nil) {
            self.intro = @"";
        }
        NSAttributedString *introduceAttributedText = [[NSAttributedString alloc] initWithString:self.intro attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x6b6b6b], NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}];
        CGRect introduceRect = [introduceAttributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize introduceSize = introduceRect.size;
        _introduceLabel.htmlText = self.intro;
        [_introduceLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN * 2 + 42 + MAX(forteSize.height, 21.0f), CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(introduceSize.height, 21.0f))];
        [customView addSubview:_introduceLabel];

        
    } else if (section == 1) {
        // 专家专栏
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.opaque = NO;
        headerLabel.textColor = [UIColor colorWithHex:0x383838];
        headerLabel.frame = CGRectMake(10.0, 11.0, 100.0, 21.0);
        headerLabel.font = [UIFont boldSystemFontOfSize:15];
        headerLabel.text = @"专家专栏";
        [customView addSubview:headerLabel];
        
        // 更多
        TEConvertButton *moreButton = [[TEConvertButton alloc] initWithFrame:CGRectMake(250.0, 11.0, 60.0, 21.0)];
        UIImage *arrowImage = [UIImage imageNamed:@"icon_more_green.png"];
        [moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [moreButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [moreButton setTitleColor:[UIColor colorWithHex:0x947d] forState:UIControlStateNormal];
        [moreButton setImage:arrowImage forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:moreButton];
    }
    
    return customView;
}

#pragma mark - API methods

// 获取专家详情
- (void)fetchExpertDetail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"doctorlist"];
    NSDictionary *parameters = @{@"doctorid": self.expertId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEExpertDetail *expertDetail = [[TEExpertDetail alloc] initWithDictionary:responseObject error:nil];
        
        _detailModel =  expertDetail.expertDetail;
        _doctorLabel.text = _detailModel.expertName;
        _titleLabel.text = _detailModel.expertTitle;
        _hospitalLabel.text =  _detailModel.hospitalName;
        _departmentLabel.text =  _detailModel.department;
        
        [_iconImageView accordingToNetLoadImagewithUrlstr:_detailModel.expertIcon and:@"logo.png"];
        
        self.intro = _detailModel.expertIntroduce;
        self.forte = _detailModel.expertForte;
        
        self.dataSource = expertDetail.expertArticles;
        [self.tableView reloadData];
        
        [hud hide:YES];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        TEExpertDetail *expertDetail = [[TEExpertDetail alloc] initWithDictionary:responseObject error:nil];
//
//        _detailModel =  expertDetail.expertDetail;
//        _doctorLabel.text = _detailModel.expertName;
//        _titleLabel.text = _detailModel.expertTitle;
//        _hospitalLabel.text =  _detailModel.hospitalName;
//        _departmentLabel.text =  _detailModel.department;
//
//        [_iconImageView accordingToNetLoadImagewithUrlstr:_detailModel.expertIcon and:@"logo.png"];
//        
//        self.intro = _detailModel.expertIntroduce;
//        self.forte = _detailModel.expertForte;
//
//        self.dataSource = expertDetail.expertArticles;
//        [self.tableView reloadData];
//        
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [hud hide:YES];
//    }];
}

#pragma mark - Bussiness methods

// 网络咨询或电话咨询
- (void)askExpert:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    // 判断是否已登录
    if (ApplicationDelegate.isLogin) {
        switch (sender.tag) {
            case 0:
            {
                UIViewController <TETextConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TETextConsultViewControllerProtocol)];
                viewController.title = @"网络咨询";
                viewController.expertId = _detailModel.expertId;
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case 1:
            {
                UIViewController <TEPhoneConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEPhoneConsultViewControllerProtocol)];
                viewController.title = @"电话咨询";
                viewController.expertId = _detailModel.expertId;
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case 2:
            {
                UIViewController <TEOfflineConsultViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEOfflineConsultViewControllerProtocol)];
                viewController.title = @"面对面咨询";
                viewController.expertId = _detailModel.expertId;
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            default:
                break;
        }
        
    } else {
        // 从专家咨询页面进入注册页面
        ApplicationDelegate.registerProtal = TERegisterPortalConsult;
        
        UIViewController <TELoginViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TELoginViewControllerProtocol)];
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

// 显示更多专家文章
- (void)showMore:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEExpertColumnViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertColumnViewControllerProtocol)];
    viewController.expertId = self.expertId;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
