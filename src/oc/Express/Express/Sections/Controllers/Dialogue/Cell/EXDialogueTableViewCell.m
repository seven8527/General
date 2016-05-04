//
//  EXDialogueTableViewCell.m
//  Express
//
//  Created by owen on 15/11/10.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXDialogueTableViewCell.h"
#define GROUP2_SIZE     23.0
#define GROUP3_SIZE     21.0
#define GROUP4_SIZE     19.0
#define BASE_GROUP_BG_SIZE     50.0


@implementation EXDialogueTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgLogo = [UIImageView newAutoLayoutView];
        _imgLogo.contentMode =UIViewContentModeScaleAspectFit;
//        _imgLogo.layer.borderWidth = 1.0f;
//        _imgLogo.layer.borderColor = [UIColor blueColor].CGColor;
        _imgLogo.layer.cornerRadius = 25.0f;
        _imgLogo.clipsToBounds = YES;
        [self addSubview:_imgLogo];
        
        
        _name       = [UILabel newAutoLayoutView];
        _name.font  = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_name];
        
        _content    = [UILabel newAutoLayoutView];
        _content.font  = [UIFont systemFontOfSize:13];
        [self addSubview:_content];

        _time    = [UILabel newAutoLayoutView];
        _time.font  = [UIFont systemFontOfSize:13];
        _time.textAlignment = NSTextAlignmentRight;
        [self addSubview:_time];

       
        
        
        //处理组logo 两个成员
        _group2_imgLogo = [UIImageView newAutoLayoutView];
        _group2_imgLogo.contentMode =UIViewContentModeScaleAspectFit;
//        _group2_imgLogo.layer.borderWidth = 1.0f;
//        _group2_imgLogo.layer.borderColor = [UIColor blueColor].CGColor;
        _group2_imgLogo.backgroundColor = [UIColor grayColor];
        _group2_imgLogo.layer.cornerRadius = 25.0f;
        _group2_imgLogo.clipsToBounds = YES;
        [self addSubview:_group2_imgLogo];
        
        _imgCell1 = [UIImageView newAutoLayoutView];
        _imgCell1.contentMode =UIViewContentModeScaleAspectFit;
        _imgCell1.layer.borderWidth = 1.0f;
        _imgCell1.layer.borderColor = [UIColor whiteColor].CGColor;
        _imgCell1.layer.cornerRadius = 12.5f;
        _imgCell1.clipsToBounds = YES;
        [_group2_imgLogo addSubview:_imgCell1];
        
        _imgCell2 = [UIImageView newAutoLayoutView];
        _imgCell2.contentMode =UIViewContentModeScaleAspectFit;
        _imgCell2.layer.borderWidth = 1.0f;
        _imgCell2.layer.borderColor = [UIColor whiteColor].CGColor;
        _imgCell2.layer.cornerRadius = 12.5f;
        _imgCell2.clipsToBounds = YES;
        [_group2_imgLogo addSubview:_imgCell2];
     
        
        [self init_Group3_UI];
        [self init_Group4_UI];
        [self init_Group5_UI];
        
        
        _count    = [UILabel newAutoLayoutView];
        _count.font  = [UIFont boldSystemFontOfSize:10];
        _count.backgroundColor = [UIColor redColor];
        _count.textColor  = [UIColor whiteColor];
        _count.layer.cornerRadius = 9.0f;
        _count.textAlignment = NSTextAlignmentCenter;
        _count.clipsToBounds = YES;
        [self addSubview:_count];
        [self updateViewConstraints];
        
    }
    return self;
}


-(void) init_Group3_UI
{
    //处理组logo 三个成员
    _group3_imgLogo = [UIImageView newAutoLayoutView];
    _group3_imgLogo.contentMode =UIViewContentModeScaleAspectFit;
    //        _group3_imgLogo.layer.borderWidth = 1.0f;
    //        _group3_imgLogo.layer.borderColor = [UIColor blueColor].CGColor;
    _group3_imgLogo.backgroundColor = [UIColor grayColor];
    _group3_imgLogo.layer.cornerRadius = BASE_GROUP_BG_SIZE/2;
    _group3_imgLogo.clipsToBounds = YES;
    [self addSubview:_group3_imgLogo];
    
    
    _imgCell3_1 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP2_SIZE/2, 0, GROUP2_SIZE, GROUP2_SIZE)];
    _imgCell3_1.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell3_1.layer.borderWidth = 1.0f;
    _imgCell3_1.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell3_1.layer.cornerRadius = GROUP2_SIZE/2;
    _imgCell3_1.clipsToBounds = YES;
    [_group3_imgLogo addSubview:_imgCell3_1];
    
    
    [self setAnchorPoint:CGPointMake(0.5, BASE_GROUP_BG_SIZE/2/GROUP2_SIZE) forView:_imgCell3_1];
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*2/3);
    _imgCell3_1.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell3_1];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell3_1.transform = transform;//翻转图片
    
    
    _imgCell3_2 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP2_SIZE/2, 0, GROUP2_SIZE, GROUP2_SIZE)];
    _imgCell3_2.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell3_2.layer.borderWidth = 1.0f;
    _imgCell3_2.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell3_2.layer.cornerRadius = GROUP2_SIZE/2;
    _imgCell3_2.clipsToBounds = YES;
    [_group3_imgLogo addSubview:_imgCell3_2];
    
    
    
    [self setAnchorPoint:CGPointMake(0.5,  BASE_GROUP_BG_SIZE/2/GROUP2_SIZE) forView:_imgCell3_2];
    transform= CGAffineTransformMakeRotation(M_PI*4/3);
    _imgCell3_2.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell3_2];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell3_2.transform = transform;//旋转
    
    _imgCell3_3 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP2_SIZE/2, 0, GROUP2_SIZE, GROUP2_SIZE)];
    _imgCell3_3.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell3_3.layer.borderWidth = 1.0f;
    _imgCell3_3.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell3_3.layer.cornerRadius = GROUP2_SIZE/2;
    _imgCell3_3.clipsToBounds = YES;
    [_group3_imgLogo addSubview:_imgCell3_3];
}
-(void) init_Group4_UI
{
    //处理组logo 4个成员
    _group4_imgLogo = [UIImageView newAutoLayoutView];
    _group4_imgLogo.contentMode =UIViewContentModeScaleAspectFit;
    //        _group4_imgLogo.layer.borderWidth = 1.0f;
    //        _group4_imgLogo.layer.borderColor = [UIColor blueColor].CGColor;
    _group4_imgLogo.backgroundColor = [UIColor grayColor];
    _group4_imgLogo.layer.cornerRadius = BASE_GROUP_BG_SIZE/2;
    _group4_imgLogo.clipsToBounds = YES;
    [self addSubview:_group4_imgLogo];
    
    
    _imgCell4_1 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP3_SIZE/2, 0, GROUP3_SIZE, GROUP3_SIZE)];
    _imgCell4_1.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell4_1.layer.borderWidth = 1.0f;
    _imgCell4_1.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell4_1.layer.cornerRadius = GROUP3_SIZE/2;
    _imgCell4_1.clipsToBounds = YES;
    [_group4_imgLogo addSubview:_imgCell4_1];
    
    [self setAnchorPoint:CGPointMake(0.5, BASE_GROUP_BG_SIZE/2/GROUP3_SIZE) forView:_imgCell4_1];
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI/2+M_PI/4); //90+45
    _imgCell4_1.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell4_1];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell4_1.transform = transform;//翻转图片
    
    
    
    _imgCell4_2 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP3_SIZE/2, 0, GROUP3_SIZE, GROUP3_SIZE)];
    _imgCell4_2.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell4_2.layer.borderWidth = 1.0f;
    _imgCell4_2.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell4_2.layer.cornerRadius = GROUP3_SIZE/2;
    _imgCell4_2.clipsToBounds = YES;
    [_group4_imgLogo addSubview:_imgCell4_2];
    
    
    [self setAnchorPoint:CGPointMake(0.5,  BASE_GROUP_BG_SIZE/2/GROUP3_SIZE) forView:_imgCell4_2];
    transform= CGAffineTransformMakeRotation(M_PI+M_PI/4);
    _imgCell4_2.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell4_2];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell4_2.transform = transform;//旋转
    
    
    
    
    _imgCell4_3 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP3_SIZE/2, 0, GROUP3_SIZE, GROUP3_SIZE)];
    _imgCell4_3.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell4_3.layer.borderWidth = 1.0f;
    _imgCell4_3.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell4_3.layer.cornerRadius = GROUP3_SIZE/2;
    _imgCell4_3.clipsToBounds = YES;
    [_group4_imgLogo addSubview:_imgCell4_3];
    
    [self setAnchorPoint:CGPointMake(0.5,  BASE_GROUP_BG_SIZE/2/GROUP3_SIZE) forView:_imgCell4_3];
    transform= CGAffineTransformMakeRotation(M_PI*3/2+M_PI/4);
    _imgCell4_3.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell4_3];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell4_3.transform = transform;//旋转
    
    
    _imgCell4_4 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP3_SIZE/2, 0, GROUP3_SIZE, GROUP3_SIZE)];
    _imgCell4_4.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell4_4.layer.borderWidth = 1.0f;
    _imgCell4_4.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell4_4.layer.cornerRadius = GROUP3_SIZE/2;
    _imgCell4_4.clipsToBounds = YES;
    [_group4_imgLogo addSubview:_imgCell4_4];
    
    [self setAnchorPoint:CGPointMake(0.5,  BASE_GROUP_BG_SIZE/2/GROUP3_SIZE) forView:_imgCell4_4];
    transform= CGAffineTransformMakeRotation(M_PI/4);
    _imgCell4_4.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell4_4];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell4_4.transform = transform;//旋转
}
-(void) init_Group5_UI
{
    _group5_imgLogo = [UIImageView newAutoLayoutView];
    _group5_imgLogo.contentMode =UIViewContentModeScaleAspectFit;
    //        _group5_imgLogo.layer.borderWidth = 1.0f;
    //        _group5_imgLogo.layer.borderColor = [UIColor blueColor].CGColor;
    _group5_imgLogo.backgroundColor = [UIColor grayColor];
    _group5_imgLogo.layer.cornerRadius = BASE_GROUP_BG_SIZE/2;
    _group5_imgLogo.clipsToBounds = YES;
    [self addSubview:_group5_imgLogo];
    
    
    _imgCell5_1 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP4_SIZE/2, 0, GROUP4_SIZE, GROUP4_SIZE)];
    _imgCell5_1.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell5_1.layer.borderWidth = 1.0f;
    _imgCell5_1.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell5_1.layer.cornerRadius = GROUP4_SIZE/2;
    _imgCell5_1.clipsToBounds = YES;
    [_group5_imgLogo addSubview:_imgCell5_1];
    
    [self setAnchorPoint:CGPointMake(0.5, BASE_GROUP_BG_SIZE/2/GROUP4_SIZE) forView:_imgCell5_1];
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI*2/5); //45
    _imgCell5_1.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell5_1];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell5_1.transform = transform;//翻转图片
    
    
    
    _imgCell5_2 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP4_SIZE/2, 0, GROUP4_SIZE, GROUP4_SIZE)];
    _imgCell5_2.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell5_2.layer.borderWidth = 1.0f;
    _imgCell5_2.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell5_2.layer.cornerRadius = GROUP4_SIZE/2;
    _imgCell5_2.clipsToBounds = YES;
    [_group5_imgLogo addSubview:_imgCell5_2];
    
    
    [self setAnchorPoint:CGPointMake(0.5,  BASE_GROUP_BG_SIZE/2/GROUP4_SIZE) forView:_imgCell5_2];
    transform= CGAffineTransformMakeRotation(M_PI*2*2/5);//45+90
    _imgCell5_2.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell5_2];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell5_2.transform = transform;//旋转
    
    
    
    
    _imgCell5_3 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP4_SIZE/2, 0, GROUP4_SIZE, GROUP4_SIZE)];
    _imgCell5_3.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell5_3.layer.borderWidth = 1.0f;
    _imgCell5_3.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell5_3.layer.cornerRadius = GROUP4_SIZE/2;
    _imgCell5_3.clipsToBounds = YES;
    [_group5_imgLogo addSubview:_imgCell5_3];
    
    [self setAnchorPoint:CGPointMake(0.5,  BASE_GROUP_BG_SIZE/2/GROUP4_SIZE) forView:_imgCell5_3];
    transform= CGAffineTransformMakeRotation(M_PI*2*3/5);
    _imgCell5_3.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell5_3];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell5_3.transform = transform;//旋转
    
    
    _imgCell5_4 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP4_SIZE/2, 0, GROUP4_SIZE, GROUP4_SIZE)];
    _imgCell5_4.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell5_4.layer.borderWidth = 1.0f;
    _imgCell5_4.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell5_4.layer.cornerRadius = GROUP4_SIZE/2;
    _imgCell5_4.clipsToBounds = YES;
    [_group5_imgLogo addSubview:_imgCell5_4];
    [self setAnchorPoint:CGPointMake(0.5,  BASE_GROUP_BG_SIZE/2/GROUP4_SIZE) forView:_imgCell5_4];
    transform= CGAffineTransformMakeRotation(M_PI*2*4/5);
    _imgCell5_4.transform = transform;//旋转
    
    [self  setDefaultAnchorPointforView:_imgCell5_4];
    transform= CGAffineTransformMakeRotation(M_PI*2);
    _imgCell5_4.transform = transform;//旋转
    
    
    _imgCell5_5 = [[UIImageView alloc]initWithFrame:CGRectMake(BASE_GROUP_BG_SIZE/2-GROUP4_SIZE/2, 0, GROUP4_SIZE, GROUP4_SIZE)];
    _imgCell5_5.contentMode =UIViewContentModeScaleAspectFit;
    _imgCell5_5.layer.borderWidth = 1.0f;
    _imgCell5_5.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgCell5_5.layer.cornerRadius = GROUP4_SIZE/2;
    _imgCell5_5.clipsToBounds = YES;
    [_group5_imgLogo addSubview:_imgCell5_5];

    
    
}
-(void)updateViewConstraints
{
    
    /**
     *  autoSetDimension // 设置 view大小
     *  ALDimensionHeight 设置高度 toSize 值
     *  ALDimensionWidth    设置宽度 toSize 值
     */
    [self.imgLogo autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [self.imgLogo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.imgLogo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
    
    //设置titl位置
    [self.name autoSetDimensionsToSize:CGSizeMake(150, 17)];
    [self.name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imgLogo withOffset:10];
    [self.name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
//    [self.name autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    
    //设置content位置
    [self.content autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH-150, 15)];
    [self.content autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.name withOffset:10];
    [self.content autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imgLogo withOffset:10];
    

    //设置time位置
    [self.time autoSetDimensionsToSize:CGSizeMake(130, 17)];
    [self.time autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.time autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
//    [self.time autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    

    //设置count位置
    [self.count autoSetDimensionsToSize:CGSizeMake(18, 18)];
    [self.count autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.imgLogo withOffset:-10];
    [self.count autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.imgLogo withOffset:5];
    
    
    /**
     *  两个成员时
     */
    [self.group2_imgLogo autoSetDimensionsToSize:CGSizeMake(BASE_GROUP_BG_SIZE, BASE_GROUP_BG_SIZE)];
    [self.group2_imgLogo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.group2_imgLogo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
    //第一张图片位置
    [self.imgCell1 autoSetDimensionsToSize:CGSizeMake(BASE_GROUP_BG_SIZE/2, BASE_GROUP_BG_SIZE/2)];
    [self.imgCell1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.group2_imgLogo];
    [self.imgCell1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.group2_imgLogo withOffset:BASE_GROUP_BG_SIZE/2/2];
    
    //第二张图片位置
    [self.imgCell2 autoSetDimensionsToSize:CGSizeMake(BASE_GROUP_BG_SIZE/2, BASE_GROUP_BG_SIZE/2)];
    [self.imgCell2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.group2_imgLogo ];
    [self.imgCell2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.group2_imgLogo withOffset:BASE_GROUP_BG_SIZE/2/2];
    
    /**
     *  三个成员时
     */
    [self.group3_imgLogo autoSetDimensionsToSize:CGSizeMake(BASE_GROUP_BG_SIZE, BASE_GROUP_BG_SIZE)];
    [self.group3_imgLogo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.group3_imgLogo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
   
    /**
     *  四个成员时
     */
    [self.group4_imgLogo autoSetDimensionsToSize:CGSizeMake(BASE_GROUP_BG_SIZE, BASE_GROUP_BG_SIZE)];
    [self.group4_imgLogo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.group4_imgLogo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
    /**
     *  五个成员时
     */
    [self.group5_imgLogo autoSetDimensionsToSize:CGSizeMake(BASE_GROUP_BG_SIZE, BASE_GROUP_BG_SIZE)];
    [self.group5_imgLogo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.group5_imgLogo autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)setDefaultAnchorPointforView:(UIView *)view
{
    [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}
@end
