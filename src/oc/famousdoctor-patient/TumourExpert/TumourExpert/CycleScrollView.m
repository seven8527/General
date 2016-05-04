//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"
#import "UIColor+Hex.h"


@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentSelectIndex;

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        self.pageControl.numberOfPages = self.totalPageCount;
        [self configContentViews];
        if (_totalPageCount > 1) {
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        } else {
            [self.animationTimer pauseTimer];
        }
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0x00947d];;
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl = pageControl;
        
        pageControl.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 60) * 0.5, self.frame.size.height - 25, 60, 20);
        [self addSubview:self.pageControl];
        
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
    if (self.totalPageCount > 1) {
        self.scrollView.scrollEnabled = YES;
    } else {
        self.scrollView.scrollEnabled = NO;
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if (self.totalPageCount > 2) {
        if(currentPageIndex == -1) {
            return self.totalPageCount - 1;
        } else if (currentPageIndex == self.totalPageCount) {
            return 0;
        } else {
            return currentPageIndex;
        }
    } else if (self.totalPageCount == 2){
        if(currentPageIndex == -1) {
            return (self.totalPageCount * 2 - 1);
        } else if (currentPageIndex == self.totalPageCount * 2) {
            return 0;
        } else {
            return currentPageIndex;
        }
    } else {
        if(currentPageIndex == -1) {
            return (self.totalPageCount * 4 - 1);
        } else if (currentPageIndex == self.totalPageCount * 4) {
            return 0;
        } else {
            return currentPageIndex;
        }
    }
    return 0;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.totalPageCount > 1) {
        [self.animationTimer pauseTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.totalPageCount > 1) {
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        if (self.totalPageCount > 2) {
            self.pageControl.currentPage = self.currentPageIndex;
        } else if (self.totalPageCount == 2 ) {
            self.pageControl.currentPage = self.currentPageIndex % 2;
        } else {
            self.pageControl.currentPage = 0;
        }
        
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        if (self.totalPageCount > 2) {
            self.pageControl.currentPage = self.currentPageIndex;
        } else if (self.totalPageCount == 2 ) {
            self.pageControl.currentPage = self.currentPageIndex % 2;
        } else {
            self.pageControl.currentPage = 0;
        }
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(kScreen_Width + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
    
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.currentSelectIndex = self.currentPageIndex;
        self.TapActionBlock(self.currentPageIndex);
    }
}

- (void)resumeTimer
{
    if (self.totalPageCount > 1) {
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}


- (void)pauseTimer
{
    [self.animationTimer pauseTimer];
    CGPoint newOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
