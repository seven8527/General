//
//  TESupplementDataViewController.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESupplementDataViewController.h"
#import "TEAppDelegate.h"
#import "UIColor+Hex.h"
#import <MBProgressHUD.h>
#import "UIImageView+AFNetworking.h"
#import "TEResultUploadImageModel.h"
#import "TEResultDeleteImageModel.h"
#import "NSString+URLEncoded.h"
#import "TEUITools.h"
#import "UIImageView+NetLoading.h"
#import <AFNetworking/AFNetworking.h>
#import "TEHttpTools.h"

#define  PIC_WIDTH 70
#define  PIC_HEIGHT 70
#define  INSETS 8
#define deleImageWH 25 // 删除按钮的宽高
#define kAdeleImage @"close.png" // 删除按钮图片

@interface TESupplementDataViewController ()
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) NSMutableArray *addedPicArray;

@property (nonatomic , weak) UIImageView *iv;
@property (nonatomic , weak) UIView *backView;
@property (nonatomic, strong) UIImagePickerController *imagePicker; //相机或相册
@end

@implementation TESupplementDataViewController


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
            [_addedPicArray removeAllObjects];
            [self fetchSupplementData];
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
    self.title = @"补充资料";
}

// UI布局
- (void)layoutUI
{
    // 病历项目
    self.itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 21)];
    self.itemLabel.font = [UIFont boldSystemFontOfSize:17];
    self.itemLabel.textColor = [UIColor colorWithHex:0x383838];
    self.itemLabel.text = @"补充资料";
    [self.view addSubview:self.itemLabel];
    
    // 病历
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 46, kScreen_Width, kScreen_Height - 104)];
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.view addSubview:self.imageScrollView];
    
    
    _addedPicArray = [[NSMutableArray alloc] init];
}

#pragma mark - UIAcitonSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self showPickerCameraView];
        } else if (buttonIndex == 1) {
            [self showImagePicker];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = nil;
        if (picker.allowsEditing == YES) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        
        //[self plusImage:image];
        [self uploadPhoto:image];
    }
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Bussiness methods

// 增加图像
- (void)showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传图片"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"相册", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

// Fill every view pixel with no black borders, resize and crop if needed
- (UIImage *)image:(UIImage *)image fillSize:(CGSize)viewsize
{
	CGSize size = image.size;
    
	CGFloat scalex = viewsize.width / size.width;
	CGFloat scaley = viewsize.height / size.height;
	CGFloat scale = MAX(scalex, scaley);
    
	UIGraphicsBeginImageContext(viewsize);
    
	CGFloat width = size.width * scale;
	CGFloat height = size.height * scale;
    
	float dwidth = ((viewsize.width - width) / 2.0f);
	float dheight = ((viewsize.height - height) / 2.0f);
    
	CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
	[image drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

//相册
- (void)showImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        if (self.imagePicker == nil) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            self.imagePicker = imagePicker;
        }
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else {
        NSString *msg = @"没有相册";
        [self showAlertView:msg];
    }
}

//相机
- (void)showPickerCameraView
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (self.imagePicker == nil) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            self.imagePicker = imagePicker;
        }
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else {
        NSString *msg = @"没有相机";
        [self showAlertView:msg];
    }
}

- (void)showAlertView:(NSString *)hintsString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:hintsString
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
    [alert show];
}

// 上传图片
- (void)uploadPhoto:(UIImage *)image
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在上传";
    
    NSString *URLString = [NSString stringWithFormat:@"%@means/stream2Image?userid=%@&file_type=%@&pmid=%@&image=%@&cookie=%@", kURL_ROOT, ApplicationDelegate.userId, @".jpg",self.patientDataId, @"c8", [ApplicationDelegate.cookie  URLEncodedString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request setHTTPMethod:@"POST"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    
    [request setValue:@"application/octet-stream" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:imageData];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        TEResultUploadImageModel *model = [[TEResultUploadImageModel alloc] initWithDictionary:responseObject error:nil];
        if ([model.state isEqualToString:@"201"]) {
            [self plusImage:image imageUrl:model.img_url];
        }
        
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
}


- (void)plusImage:(UIImage *)image imageUrl:(NSString *)imageUrl
{
    //移动添加按钮
    CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
    [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(_plusButton.center.x, _plusButton.center.y)]];
    [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(((_addedPicArray.count + 1) % 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS), ((_addedPicArray.count + 1) / 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS))]];
    [positionAnim setDelegate:self];
    [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [positionAnim setDuration:0.25f];
    [_plusButton.layer addAnimation:positionAnim forKey:nil];
    [_plusButton setCenter:CGPointMake(((_addedPicArray.count + 1) % 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS), ((_addedPicArray.count + 1) / 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS))];
    
    
    //添加图片
    UIImageView *aImageView = [[UIImageView alloc] initWithImage:image];
    [aImageView setFrame:CGRectMake((_addedPicArray.count % 4) * (PIC_WIDTH + INSETS) + INSETS, (_addedPicArray.count / 4) * (PIC_WIDTH + INSETS) + INSETS, PIC_WIDTH, PIC_HEIGHT)];
    aImageView.userInteractionEnabled = YES;
    aImageView.contentMode = UIViewContentModeScaleAspectFit;
    [aImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTapped:)]];
    [aImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)]];
    objc_setAssociatedObject(aImageView, "imageUrl", imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [_addedPicArray addObject:aImageView];
    [_imageScrollView addSubview:aImageView];
    
    for (UIImageView *img in _addedPicArray) {
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
        [positionAnim setDelegate:self];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.25f];
        [img.layer addAnimation:positionAnim forKey:nil];
        [img setCenter:CGPointMake(img.center.x, img.center.y)];
    }
    
    [self refreshScrollView];
}

- (void)refreshScrollView
{
    CGFloat height = (PIC_WIDTH + 2 * INSETS) + (_addedPicArray.count / 4) * (PIC_WIDTH + INSETS);
    CGSize contentSize = CGSizeMake(kScreen_Width, height);
    [_imageScrollView setContentSize:contentSize];
    [_imageScrollView setContentOffset:CGPointMake(0, height < (kScreen_Height - 104) ? 0 : height - (kScreen_Height - 104)) animated:YES];
}

#pragma mark - API methods

// 获取补充资料列表
- (void)fetchSupplementData
{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/supplement"];
    NSDictionary *parameters = @{@"pmid": self.patientDataId};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        NSLog(@"----%@", responseObject);
        
        NSString *supplementData = [responseObject objectForKey:@"c8"];
        if (supplementData && ![supplementData isEqualToString:@""]) {
            NSArray *pairs = [supplementData componentsSeparatedByString:@"|"];
            for (NSString *str in pairs) {
                NSArray *arr = [str componentsSeparatedByString:@","];
                for (NSString *imageUrl in arr) {
                    
                    UIImageView *aImageView = [[UIImageView alloc] init];
                    [aImageView accordingToNetLoadImagewithUrlstr:imageUrl and:@"logo.png"];
                    [aImageView setFrame:CGRectMake((_addedPicArray.count % 4) * (PIC_WIDTH + INSETS) + INSETS, (_addedPicArray.count / 4) * (PIC_WIDTH + INSETS) + INSETS, PIC_WIDTH, PIC_HEIGHT)];
                    aImageView.userInteractionEnabled = YES;
                    aImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [aImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTapped:)]];
                    [aImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)]];
                    objc_setAssociatedObject(aImageView, "imageUrl", imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [_addedPicArray addObject:aImageView];
                    [_imageScrollView addSubview:aImageView];
                    
                    for (UIImageView *img in _addedPicArray) {
                        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
                        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
                        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
                        [positionAnim setDelegate:self];
                        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                        [positionAnim setDuration:0.25f];
                        [img.layer addAnimation:positionAnim forKey:nil];
                        [img setCenter:CGPointMake(img.center.x, img.center.y)];
                    }
                    
                    break;
                }
            }
        }
        for (NSString *aa in _addedPicArray) {
            NSLog(@"jpg---:  %@", aa);
        }
        NSLog(@"--count: %d", [_addedPicArray count]);
        // 增加图片
        self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.plusButton.frame = CGRectMake((_addedPicArray.count % 4) * (PIC_WIDTH + INSETS) + INSETS, (_addedPicArray.count / 4) * (PIC_WIDTH + INSETS) + INSETS, PIC_WIDTH, PIC_HEIGHT);
        //CGRectMake(INSETS, INSETS, PIC_WIDTH, PIC_HEIGHT);
        [self.plusButton setImage:[UIImage imageNamed:@"add_picture_unselected"] forState:UIControlStateNormal];
        [self.plusButton setImage:[UIImage imageNamed:@"add_picture_selected"] forState:UIControlStateSelected];
        [self.plusButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageScrollView addSubview:self.plusButton];
        
        [self refreshScrollView];

    } failure:^(NSError *error) {
        ;
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"----%@", responseObject);
//        
//        NSString *supplementData = [responseObject objectForKey:@"c8"];
//        if (supplementData && ![supplementData isEqualToString:@""]) {
//            NSArray *pairs = [supplementData componentsSeparatedByString:@"|"];
//            for (NSString *str in pairs) {
//                NSArray *arr = [str componentsSeparatedByString:@","];
//                for (NSString *imageUrl in arr) {
//                    
//                    UIImageView *aImageView = [[UIImageView alloc] init];
//                     [aImageView accordingToNetLoadImagewithUrlstr:imageUrl and:@"logo.png"];
//                    [aImageView setFrame:CGRectMake((_addedPicArray.count % 4) * (PIC_WIDTH + INSETS) + INSETS, (_addedPicArray.count / 4) * (PIC_WIDTH + INSETS) + INSETS, PIC_WIDTH, PIC_HEIGHT)];
//                    aImageView.userInteractionEnabled = YES;
//                    aImageView.contentMode = UIViewContentModeScaleAspectFit;
//                    [aImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewTapped:)]];
//                    [aImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)]];
//                    objc_setAssociatedObject(aImageView, "imageUrl", imageUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//                    [_addedPicArray addObject:aImageView];
//                    [_imageScrollView addSubview:aImageView];
//                    
//                    for (UIImageView *img in _addedPicArray) {
//                        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
//                        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
//                        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
//                        [positionAnim setDelegate:self];
//                        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                        [positionAnim setDuration:0.25f];
//                        [img.layer addAnimation:positionAnim forKey:nil];
//                        [img setCenter:CGPointMake(img.center.x, img.center.y)];
//                    }
//                    
//                    break;
//                }
//            }
//        }
//        for (NSString *aa in _addedPicArray) {
//            NSLog(@"jpg---:  %@", aa);
//        }
//        NSLog(@"--count: %d", [_addedPicArray count]);
//        // 增加图片
//        self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.plusButton.frame = CGRectMake((_addedPicArray.count % 4) * (PIC_WIDTH + INSETS) + INSETS, (_addedPicArray.count / 4) * (PIC_WIDTH + INSETS) + INSETS, PIC_WIDTH, PIC_HEIGHT);
//        //CGRectMake(INSETS, INSETS, PIC_WIDTH, PIC_HEIGHT);
//        [self.plusButton setImage:[UIImage imageNamed:@"add_picture_unselected"] forState:UIControlStateNormal];
//        [self.plusButton setImage:[UIImage imageNamed:@"add_picture_selected"] forState:UIControlStateSelected];
//        [self.plusButton addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
//        [self.imageScrollView addSubview:self.plusButton];
//        
//        [self refreshScrollView];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
}

// 删除服务器图片
- (void)deleteImageFromServerWithType:(NSString *)type imageUrl:(NSString *)imageUrl imageView:(UIImageView *)imageView
{
    // 判断是否是缩略图  删除需传原图路径
    if ([imageUrl rangeOfString:@"_150X150"].location != NSNotFound) {
        imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_150X150" withString:@""];
    }
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"means/delimg"];
    NSDictionary *parameters = @{@"pmid": self.patientDataId, @"image":type, @"del_image": imageUrl, @"cookie": ApplicationDelegate.cookie};
    [TEHttpTools post:URLString params:parameters success:^(id responseObject) {
        TEResultDeleteImageModel *model = [[TEResultDeleteImageModel alloc] initWithDictionary:responseObject error:nil];
        NSString *state = model.state;
        NSLog(@"--%@", responseObject);
        if ([state isEqualToString:@"201"]) {
            [self removeImageView:imageView];
        }
    } failure:^(NSError *error) {
    }];
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        TEResultDeleteImageModel *model = [[TEResultDeleteImageModel alloc] initWithDictionary:responseObject error:nil];
//        NSString *state = model.state;
//        NSLog(@"--%@", responseObject);
//        if ([state isEqualToString:@"201"]) {
//            [self removeImageView:imageView];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
}

#pragma mark - Image Scale

- (void)handleImageViewTapped:(UITapGestureRecognizer*)imageTap
{
    UIImageView *imageView =(UIImageView*)imageTap.view;
    if(![imageView.layer animationKeys])
    {
        [self showImage:(UIImageView*)imageTap.view];
    } else {
        [self stop:(UIButton *)imageView];
        
        [imageView.subviews.lastObject removeFromSuperview];
    }
}

CGRect defaultFrame;
id dImageView;

- (void)showImage:(UIImageView *)defaultImageView
{
    
    UIImage * image = defaultImageView.image;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    UIView * backView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.backView = backView;
    [[UIApplication sharedApplication].keyWindow addSubview:backView];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    
    UIScrollView * sv = [[UIScrollView alloc]init];
    [sv addGestureRecognizer:tap];
    sv.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [backView addSubview:sv];
    sv.delegate = self;
    UIImageView * iv = [[UIImageView alloc]init];
    self.iv =iv;
    CGFloat origin_x = abs(sv.frame.size.width - image.size.width)/2.0;
    CGFloat origin_y = abs(sv.frame.size.height - image.size.height)/2.0;
    //            self.iv.frame = CGRectMake(origin_x, origin_y, sv.frame.size.width, sv.frame.size.width*image.size.height/image.size.width);
    iv.frame = CGRectMake(origin_x, origin_y, image.size.width,image.size.height);
    [iv setImage:image];
    
    [sv addSubview:iv];
    
    CGSize maxSize = sv.frame.size;
    CGFloat widthRatio = maxSize.width/image.size.width;
    CGFloat heightRatio = maxSize.height/image.size.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    /*
     
     ** 设置UIScrollView的最大和最小放大级别（注意如果MinimumZoomScale == MaximumZoomScale，
     
     ** 那么UIScrllView就缩放不了了
     
     */
    [sv setMinimumZoomScale:initialZoom * 0.5];
    [sv setMaximumZoomScale:40];
    // 设置UIScrollView初始化缩放级别
    [sv setZoomScale:initialZoom];
    
}

- (void)hideImage:(UITapGestureRecognizer*)tap
{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = defaultFrame;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView.hidden = YES;
        [self.backView removeFromSuperview];
        ((UIImageView*)dImageView).alpha = 1;
        [backgroundView removeFromSuperview];
    }];
}

// 设置UIScrollView中要缩放的视图

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.iv;
    
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.iv.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

// 长按添加删除按钮
- (void)longPressGesture:(UIGestureRecognizer *)gester
{
    if (gester.state == UIGestureRecognizerStateBegan)
    {
        UIButton *btn = (UIButton *)gester.view;
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:kAdeleImage] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
        
        [btn addSubview:dele];
        [self start:btn];
    }
}

// 长按开始抖动
- (void)start:(UIButton *)btn {
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(angle1),  @(angle2), @(angle1)];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [btn.layer addAnimation:anim forKey:@"shake"];
}

// 停止抖动
- (void)stop:(UIButton *)btn{
    [btn.layer removeAnimationForKey:@"shake"];
}

// 删除图片
- (void)deletePic:(UIImageView *)btn
{
    UIImageView *imageView = (UIImageView*)btn.superview;
    NSString *imageUrl =  objc_getAssociatedObject(imageView, "imageUrl");
    
    [self deleteImageFromServerWithType:@"c8" imageUrl:imageUrl imageView:imageView];
}


-(void)removeImageView:(UIImageView *)imageView
{
    NSInteger picIndex = [_addedPicArray indexOfObject:imageView];
    if (picIndex == NSNotFound) {
        return;
    }
    
    //图片隐藏动画
    [UIView animateWithDuration:0.15f animations:^{
        imageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        //remove图片
        [imageView removeFromSuperview];
        [_addedPicArray removeObjectAtIndex:picIndex];
        
        //右侧图片左移动画
        for (int i = picIndex; i < _addedPicArray.count; ++i) {
            UIImageView *img = _addedPicArray[i];
            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(img.center.x, img.center.y)]];
            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake((i  % 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS), (i / 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS))]];
            [positionAnim setDelegate:self];
            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [positionAnim setDuration:0.25f];
            [img.layer addAnimation:positionAnim forKey:nil];
            
            [img setCenter:CGPointMake((i  % 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS), (i / 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS))];
        }
        
        //左移添加按钮
        CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
        [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(_plusButton.center.x, _plusButton.center.y)]];
        [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake((_addedPicArray.count % 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS), (_addedPicArray.count / 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS))]];
        [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [positionAnim setDuration:0.25f];
        [_plusButton.layer addAnimation:positionAnim forKey:nil];
        [_plusButton setCenter:CGPointMake((_addedPicArray.count % 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS), (_addedPicArray.count / 4) * (PIC_WIDTH + INSETS) + (PIC_WIDTH / 2 + INSETS))];
        
        [self refreshScrollView];
        
    }];
}


@end
