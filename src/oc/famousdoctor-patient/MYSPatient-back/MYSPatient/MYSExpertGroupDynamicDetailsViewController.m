//
//  MYSExpertGroupDynamicDetailsViewController.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-16.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDynamicDetailsViewController.h"
#import "MYSFoundationCommon.h"
#import <DTCoreText/DTCoreText.h>
#import "UIColor+Hex.h"
#import "HttpTool.h"
#import "MYSDoctorHomeDynamicDetailsModel.h"

#define leftMargin 15

@interface MYSExpertGroupDynamicDetailsViewController () <DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, weak) UIView *leftLine; // 标题左侧竖线
@property (nonatomic, weak) UILabel *titleLabel; // 标题
@property (nonatomic, weak) UIView *firstLine;
@property (nonatomic, weak) UILabel *resourceLabel; // 来源
@property (nonatomic, weak) UILabel *timeLabel; // 时间
@property (nonatomic, weak) DTAttributedTextView *contentView;
@property (nonatomic, strong) MYSDoctorHomeDynamicDetailsModel *dynamicDetailsModel;
@property (nonatomic, strong) DTAttributedTextCell *attributedTextCell;
@end

NSString * const AttributedTextCellReuseIdentifier = @"AttributedTextCellReuseIdentifier";

@implementation MYSExpertGroupDynamicDetailsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"动态详情";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_back_"] style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarButton)];
    leftBarButton.tintColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_button_share_"] style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    rightButton.tintColor = [UIColor colorFromHexRGB:K00A693Color];
    self.navigationItem.rightBarButtonItem = rightButton;
    
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(leftMargin, 0, kScreen_Width - leftMargin * 2, kScreen_Height) style:UITableViewStylePlain];
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        mainTableView.delegate = self;
//        mainTableView.dataSource = self;
        [self.view addSubview:mainTableView];
        self.mainTableView = mainTableView;
    //
    //    [self.mainTableView registerClass:[DTAttributedTextCell class] forCellReuseIdentifier:AttributedTextCellReuseIdentifier];
}

- (void)layoutUIWith:(MYSDoctorHomeDynamicDetailsModel *)dynamicDetailsModel
{
    
    UIView *headerView = [[UIView alloc] init];
    self.headerView = headerView;
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 14, 2, 24)];
    self.leftLine = leftLine;
    leftLine.backgroundColor = [UIColor colorFromHexRGB:k00947DColor];
    [headerView addSubview:leftLine];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
    titleLabel.text = dynamicDetailsModel.title;
    CGSize  titleSize = [MYSFoundationCommon sizeWithText:titleLabel.text withFont:titleLabel.font constrainedToSize:CGSizeMake(kScreen_Width - 40, MAXFLOAT)];
    titleLabel.frame = CGRectMake(leftMargin + 10, 14, titleSize.width, titleSize.height);
    self.titleLabel = titleLabel;
    [headerView addSubview:titleLabel];
    
    
    UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 15, kScreen_Width - 30 , 0.5)];
    self.firstLine = firstLine;
    firstLine.backgroundColor = [UIColor colorFromHexRGB:KC2C2C2Color];
    [headerView addSubview:firstLine];
    
    UILabel *resourceLabel = [[UILabel alloc] init];
    resourceLabel.text = dynamicDetailsModel.doctorName;
    CGSize resourceSize = [MYSFoundationCommon sizeWithText:resourceLabel.text withFont:resourceLabel.font];
    self.resourceLabel = resourceLabel;
    resourceLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    resourceLabel.font = [UIFont systemFontOfSize:13];
    resourceLabel.frame = CGRectMake(0, CGRectGetMaxY(firstLine.frame) + 10, resourceSize.width, resourceSize.height);
    [headerView addSubview:resourceLabel];
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(resourceLabel.frame) + 20, CGRectGetMinY(resourceLabel.frame), kScreen_Width - CGRectGetMaxX(resourceLabel.frame) - 20 - 15, resourceSize.height)];
    timeLabel.text =dynamicDetailsModel.addTime;
    self.titleLabel = titleLabel;
    timeLabel.font = [UIFont fontWithName:@"Helvetica Light" size:13];
    timeLabel.textColor = [UIColor colorFromHexRGB:K9E9E9EColor];
    [headerView addSubview:timeLabel];
    
    LOG(@"%f",timeLabel.frame.origin.y + timeLabel.frame.size.height);
    
    headerView.frame = CGRectMake(0, -timeLabel.frame.origin.y - timeLabel.frame.size.height, kScreen_Width,  timeLabel.frame.origin.y + timeLabel.frame.size.height + 7);
    
    DTAttributedTextView *contentView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    contentView.textDelegate = self;
    contentView.shouldDrawImages = YES;
    self.contentView = contentView;
    NSValue *maxImageSize = [NSValue valueWithCGSize:CGSizeMake(kScreen_Width - 40, kScreen_Width - 40)];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:[[dynamicDetailsModel content]  dataUsingEncoding:NSUTF8StringEncoding] options:@{DTDefaultFontSize: @"14", DTMaxImageSize: maxImageSize} documentAttributes:nil];
    self.contentView.attributedString = attributedString;
    contentView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(headerView.frame) + 64, 20, 0, 20);
    
    [self.view addSubview:contentView];
    
    [contentView addSubview:headerView];
 
    
}



- (void)setIntroducesModel:(MYSDoctorHomeIntroducesModel *)introducesModel
{
    _introducesModel = introducesModel;
}

- (void)setDynamicId:(NSString *)dynamicId
{
    _dynamicId = dynamicId;
    
    [self dynamicDetailsWith:dynamicId];
}



- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        // if the attachment has a hyperlinkURL then this is currently ignored
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        // if there is a hyperlink then add a link button on top of this image
        if (attachment.hyperLinkURL)
        {
            // NOTE: this is a hack, you probably want to use your own image view and touch handling
            // also, this treats an image with a hyperlink by itself because we don't have the GUID of the link parts
            imageView.userInteractionEnabled = YES;
            
            DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:imageView.bounds];
            button.URL = attachment.hyperLinkURL;
            button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
            button.GUID = attachment.hyperLinkGUID;
            
            [imageView addSubview:button];
        }
        
        return imageView;
    }
    else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
    {
        DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
        videoView.attachment = attachment;
        
        return videoView;
    }
    else if ([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        // somecolorparameter has a HTML color
        NSString *colorName = [attachment.attributes objectForKey:@"somecolorparameter"];
        UIColor *someColor = DTColorCreateWithHTMLName(colorName);
        
        UIView *someView = [[UIView alloc] initWithFrame:frame];
        someView.backgroundColor = someColor;
        someView.layer.borderWidth = 1;
        someView.layer.borderColor = [UIColor blackColor].CGColor;
        
        someView.accessibilityLabel = colorName;
        someView.isAccessibilityElement = YES;
        
        return someView;
    }
    
    return nil;
}


#pragma mark - DTLazyImageViewDelegate

- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that matchin this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [self.contentView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        [self.contentView relayoutText];
    }
}

#pragma mark api 获取动态详情

- (void)dynamicDetailsWith:(NSString *)dynamicId
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL stringByAppendingString:@"dynamic/detail"];
    NSDictionary *parameters = @{@"did": [self.introducesModel doctorId], @"dcaid": dynamicId};
    [HttpTool get:URLString params:parameters success:^(id responseObject) {
        LOG(@"Success: %@", responseObject);
        MYSDoctorHomeDynamicDetailsModel *dynamicDetailsModel = [[MYSDoctorHomeDynamicDetailsModel alloc] initWithDictionary:responseObject error:nil];
        
        self.dynamicDetailsModel = dynamicDetailsModel;
        [self layoutUIWith:dynamicDetailsModel];
        [self.mainTableView reloadData];
        [hud hide:YES];
    } failure:^(NSError *error) {
        LOG(@"Error: %@", error);
        [hud hide:YES];
    }];
}


// 返回
- (void)clickLeftBarButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
