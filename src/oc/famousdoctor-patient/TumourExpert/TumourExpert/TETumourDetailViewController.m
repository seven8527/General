//
//  TETumourDetailViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETumourDetailViewController.h"
#import "TEDiseaseCell.h"
#import "UIColor+Hex.h"
#import "TEUITools.h"
#import "TEDiseaseDetail.h"
#import "TEExpertModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "TEFoundationCommon.h"
#import "UIImageView+NetLoading.h"
#import "TEHttpTools.h"

#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH kScreen_Width
#define CELL_CONTENT_HEIGHT kScreen_Height
#define CELL_CONTENT_MARGIN 20.0f

@interface TETumourDetailViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIView *expertView;
@property (nonatomic, weak) POHorizontalList *list;
@property (nonatomic, strong) NSMutableArray *experts;
@property (nonatomic, strong) NSString *synopsis; // 简介
@property (nonatomic, strong) NSString *pathogenesis; // 病因
@property (nonatomic, strong) NSString *clinicalFeature; // 临床表现
@property (nonatomic, strong) NSString *cure; // 治疗
@end

@implementation TETumourDetailViewController

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
            [_experts removeAllObjects];
            [self fetchDiseaseDetail];
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
    self.title = self.name;
    _experts = [NSMutableArray array];
}

// UI布局
- (void)layoutUI
{
    // Create a UITableView
    CGFloat tableViewY = [TEFoundationCommon getAdapterHeight];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -tableViewY, kScreen_Width, self.view.bounds.size.height - 200 + tableViewY) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [TEUITools hiddenTableExtraCellLine:self.tableView];
    [self.view addSubview:self.tableView];
    
    
    UIView *expertView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 200,self.view.bounds.size.width , 200)];
    self.expertView = expertView;
    // 推荐专家
    UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    expertLabel.backgroundColor = [UIColor clearColor];
    expertLabel.opaque = NO;
    expertLabel.textColor = [UIColor colorWithHex:0x383838];
    expertLabel.frame = CGRectMake(20.0, 11.0, 280.0, 21.0);
    expertLabel.font = [UIFont boldSystemFontOfSize:17];
    expertLabel.text = [NSString stringWithFormat:@"%@推荐专家",self.name];
    [expertView addSubview:expertLabel];
    
    POHorizontalList *list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 41.0, 320.0, 120.0) title:nil items:_experts];
    self.list = list;
    [list setDelegate:self];
    [expertView addSubview:list];
    [self.view addSubview:expertView];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    TEDiseaseCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TEDiseaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.itemLabel.text = [NSString stringWithFormat:@"%@介绍",self.name];
                cell.itemIntroLabel.htmlText = self.synopsis;
                break;
            case 1:
                cell.itemLabel.text = @"如何引起";
                cell.itemIntroLabel.htmlText = self.pathogenesis;
                break;
            case 2:
                cell.itemLabel.text = @"如何预防";
                cell.itemIntroLabel.htmlText = self.clinicalFeature;
                break;
            case 3:
                cell.itemLabel.text = @"健康建议";
                cell.itemIntroLabel.htmlText = self.cure;
                break;
            
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return [MDHTMLLabel sizeThatFitsHTMLString:self.synopsis withFont:[UIFont boldSystemFontOfSize:13] constraints:CGSizeMake(280, CGFLOAT_MAX) limitedToNumberOfLines:2000] + 51;
            break;

        case 1:
            return [MDHTMLLabel sizeThatFitsHTMLString:self.pathogenesis withFont:[UIFont boldSystemFontOfSize:13] constraints:CGSizeMake(280, CGFLOAT_MAX) limitedToNumberOfLines:2000] + 51;
            break;
        case 2:
            return [MDHTMLLabel sizeThatFitsHTMLString:self.clinicalFeature withFont:[UIFont boldSystemFontOfSize:13] constraints:CGSizeMake(280, CGFLOAT_MAX) limitedToNumberOfLines:2000] + 51;
            break;
        case 3:
            return [MDHTMLLabel sizeThatFitsHTMLString:self.cure withFont:[UIFont boldSystemFontOfSize:13] constraints:CGSizeMake(280, CGFLOAT_MAX) limitedToNumberOfLines:2000] + 51;
            break;
        default:
            break;
    }
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
////    if (section == 0) {
////        return 161;
////    } else
//        if (section == 0) {
//        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//        if (self.synopsis == nil) {
//            self.synopsis = @"";
//        }
//        NSAttributedString *forteAttributedText = [[NSAttributedString alloc] initWithString:self.synopsis attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x383838], NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}];
//        CGRect synopsisRect = [forteAttributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        CGSize synopsisSize = synopsisRect.size;
//        CGFloat synopsisHeight = MAX(synopsisSize.height, 21.0f);
//        return synopsisHeight + 58;
//    }
//    return 44.0;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 0.0)];
//    
////    if (section == 0) {
////        // 推荐专家
////        UILabel *expertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
////        expertLabel.backgroundColor = [UIColor clearColor];
////        expertLabel.opaque = NO;
////        expertLabel.textColor = [UIColor colorWithHex:0x383838];
////        expertLabel.frame = CGRectMake(20.0, 11.0, 280.0, 21.0);
////        expertLabel.font = [UIFont boldSystemFontOfSize:17];
////        expertLabel.text = @"推荐专家";
////        [customView addSubview:expertLabel];
////        
////        POHorizontalList *list = [[POHorizontalList alloc] initWithFrame:CGRectMake(0.0, 41.0, 320.0, 120.0) title:nil items:_experts];
////        [list setDelegate:self];
////        [customView addSubview:list];
////    } else
//        if (section == 0) {
//        // 疾病名称
//        UILabel *diseaseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        diseaseLabel.backgroundColor = [UIColor clearColor];
//        diseaseLabel.opaque = NO;
//        diseaseLabel.textColor = [UIColor colorWithHex:0x383838];
//        diseaseLabel.frame = CGRectMake(20.0, 15.0, 280.0, 21.0);
//        diseaseLabel.font = [UIFont boldSystemFontOfSize:17];
////        diseaseLabel.text = self.title;
//            diseaseLabel.text = [NSString stringWithFormat:@"%@介绍",self.title];
//        [customView addSubview:diseaseLabel];
//        
//        // 疾病简介
//        MDHTMLLabel *synopsisLabel = [[MDHTMLLabel alloc] initWithFrame:CGRectZero];
//        [synopsisLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [synopsisLabel setMinimumScaleFactor:FONT_SIZE];
//        [synopsisLabel setNumberOfLines:0];
//        [synopsisLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];;
//        
//    
//        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//        if (self.synopsis == nil) {
//            self.synopsis = @"";
//        }
//        NSAttributedString *forteAttributedText = [[NSAttributedString alloc] initWithString:self.synopsis attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x383838], NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]}];
//        CGRect synopsisRect = [forteAttributedText boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        CGSize synopsisSize = synopsisRect.size;
//        synopsisLabel.htmlText = self.synopsis;
//        [synopsisLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, 48, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(synopsisSize.height, 21.0f))];
//        [customView addSubview:synopsisLabel];
//
//        // 画线
//        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(20, 58 + MAX(synopsisSize.height, 21.0f), 280, 1)];
//        line.image = [[UIImage imageNamed:@"line_d1d1d1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//        [customView addSubview:line];
//    }
//    
//    return customView;
//}

#pragma mark  POHorizontalListDelegate

- (void) didSelectItem:(ListItem *)item {
    self.hidesBottomBarWhenPushed = YES;
    UIViewController <TEExpertDetailViewControllerProtocol> *viewController = [[JSObjection defaultInjector] getObject:@protocol(TEExpertDetailViewControllerProtocol)];
    viewController.expertId = item.selectedId;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - API methods

// 获取疾病详情
- (void)fetchDiseaseDetail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"discub"];
    NSDictionary *parameters = @{@"cids": self.diseaseId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        TEDiseaseDetail *diseaseDetail = [[TEDiseaseDetail alloc] initWithDictionary:responseObject error:nil];
        TEDiseaseModel *diseaseModel = diseaseDetail.disease;
        self.synopsis = diseaseModel.synopsis;
        self.pathogenesis = diseaseModel.pathogenesis;
        self.clinicalFeature = diseaseModel.clinicalFeature;
        self.cure = diseaseModel.cure;
        
        for (TEExpertModel *expert in diseaseDetail.experts) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView accordingToNetLoadImagewithUrlstr:expert.expertIcon and:@"logo.png"];
            ListItem *item = [[ListItem alloc] initWithFrame:CGRectZero imageView:imageView text:expert.expertName selectedId:expert.expertId];
            [_experts addObject:item];
        }
        self.list.items = _experts;
        
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
//        TEDiseaseDetail *diseaseDetail = [[TEDiseaseDetail alloc] initWithDictionary:responseObject error:nil];
//        TEDiseaseModel *diseaseModel = diseaseDetail.disease;
//        self.synopsis = diseaseModel.synopsis;
//        self.pathogenesis = diseaseModel.pathogenesis;
//        self.clinicalFeature = diseaseModel.clinicalFeature;
//        self.cure = diseaseModel.cure;
//        
//        for (TEExpertModel *expert in diseaseDetail.experts) {
//            UIImageView *imageView = [[UIImageView alloc] init];
//             [imageView accordingToNetLoadImagewithUrlstr:expert.expertIcon and:@"logo.png"];
//            ListItem *item = [[ListItem alloc] initWithFrame:CGRectZero imageView:imageView text:expert.expertName selectedId:expert.expertId];
//            [_experts addObject:item];
//        }
//        self.list.items = _experts;
//        
//        [self.tableView reloadData];
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hide:YES];
//    }];
}

@end
