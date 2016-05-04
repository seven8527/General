//
//  TEHealthInfoViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHealthInfoViewController.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"
#import "TEHealthInfoDetailModel.h"
#import "TEFoundationCommon.h"
#import "TEHttpTools.h"

@interface TEHealthInfoViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DTAttributedTextView *attributedTextView;
@property (nonatomic, strong) TEHealthInfoDetailModel *healthInfoModel;
@end

@implementation TEHealthInfoViewController

- (void) viewDidLoad
{
    [self configUI];
    
    [self layoutUI];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    reach.reachableBlock = ^(Reachability *reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchHealthInfo];
        });
    };
    
    [reach startNotifier];
}

#pragma mark - UI


// UI设置
- (void)configUI
{
    self.title = @"健康资讯";
    self.view.backgroundColor = [UIColor whiteColor];
}

// UI布局
- (void)layoutUI
{
    // 内容
    self.attributedTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.view.bounds.size.height - [TEFoundationCommon getNavBarAdapterHeight])];
    self.attributedTextView.showsVerticalScrollIndicator = YES;
    self.attributedTextView.backgroundColor = [UIColor whiteColor];
    _attributedTextView.textDelegate = self;
    [self.view addSubview:self.attributedTextView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.titleLabel.textColor = [UIColor colorWithHex:0x383838];
    self.titleLabel.numberOfLines = 0;
    [self.attributedTextView addSubview:self.titleLabel];
}

#pragma mark - API methods

// 获取资讯信息
- (void)fetchHealthInfo
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在加载";
    
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"health_article_details"];
    NSDictionary *parameters = @{@"maid": self.healthInfoId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        
        self.healthInfoModel = [[TEHealthInfoDetailModel alloc] initWithDictionary:responseObject error:nil];
        self.titleLabel.text = self.healthInfoModel.healthInfoTitle;
        
        CGSize boundingSize = CGSizeMake(kScreen_Width - 40, CGFLOAT_MAX);
        CGSize titleSize = [self.titleLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
        self.titleLabel.frame = CGRectMake(0, - titleSize.height - 20, titleSize.width, titleSize.height);
        self.attributedTextView.contentInset = UIEdgeInsetsMake(titleSize.height + [TEFoundationCommon getAdapterHeight] + 30, 20, 0, 20);
        
        NSString *str = [self.healthInfoModel.healthInfoContent stringByReplacingOccurrencesOfString:@"<p><br/></p>" withString:@""];
        NSString *str2 = [str stringByReplacingOccurrencesOfString:@"<p><strong><br/></strong></p>" withString:@""];
        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        
        NSValue *maxImageSize = [NSValue valueWithCGSize:CGSizeMake(kScreen_Width - 40, kScreen_Width - 40)];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:@{DTDefaultFontSize: @"14", DTMaxImageSize: maxImageSize} documentAttributes:nil];
        self.attributedTextView.attributedString = attributedString;
        
        [hud hide:YES];

    } failure:^(NSError *error) {
        [hud hide:YES];
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@", responseObject);
//        
//        self.healthInfoModel = [[TEHealthInfoDetailModel alloc] initWithDictionary:responseObject error:nil];
//        self.titleLabel.text = self.healthInfoModel.healthInfoTitle;
//        
//        CGSize boundingSize = CGSizeMake(kScreen_Width - 40, CGFLOAT_MAX);
//        CGSize titleSize = [self.titleLabel.text boundingRectWithSize:boundingSize font:[UIFont boldSystemFontOfSize:17]];
//        self.titleLabel.frame = CGRectMake(0, - titleSize.height - 20, titleSize.width, titleSize.height);
//        self.attributedTextView.contentInset = UIEdgeInsetsMake(titleSize.height + [TEFoundationCommon getAdapterHeight] + 30, 20, 0, 20);
//        
//        NSString *str = [self.healthInfoModel.healthInfoContent stringByReplacingOccurrencesOfString:@"<p><br/></p>" withString:@""];
//        NSString *str2 = [str stringByReplacingOccurrencesOfString:@"<p><strong><br/></strong></p>" withString:@""];
//        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSValue *maxImageSize = [NSValue valueWithCGSize:CGSizeMake(kScreen_Width - 40, kScreen_Width - 40)];
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:@{DTDefaultFontSize: @"14", DTMaxImageSize: maxImageSize} documentAttributes:nil];
//        self.attributedTextView.attributedString = attributedString;
//        
//        [hud hide:YES];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [hud hide:YES];
//    }];
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
    for (DTTextAttachment *oneAttachment in [self.attributedTextView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
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
        [self.attributedTextView relayoutText];
    }
}

@end
