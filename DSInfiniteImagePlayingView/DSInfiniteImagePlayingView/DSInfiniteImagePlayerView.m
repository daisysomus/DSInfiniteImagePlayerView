//
//  DSInfiniteImagePlayerView,m
//  DSInfiniteImagePlayingView
//
//  Created by liaojinhua on 16/2/29.
//  Copyright © 2016年 Liao jinhua. All rights reserved.
//

#import "DSInfiniteImagePlayerView.h"

@interface DSInfiniteImagePlayerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *middleView;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong) UIImageView *movingView;

@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) NSInteger displayingIndex;

@property (nonatomic, assign) BOOL isMoveToRight;
@property (nonatomic, assign) BOOL isMoveToLeft;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DSInfiniteImagePlayerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self configView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.bounds, self.scrollView.frame)) {
        self.scrollView.frame = self.bounds;
        self.pageControl.frame = CGRectMake((self.frame.size.width - self.pageControl.frame.size.width)/2, self.frame.size.height - self.pageControl.frame.size.height, self.pageControl.frame.size.width, self.pageControl.frame.size.height);
        [self updateSubViewsFrame];
        self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
}

- (void)reloadData
{
    if (!self.delegate) {
        return;
    }
    
    [self stopTimer];
    self.imageCount = [self.delegate numberOfImages:self];
    self.pageControl.numberOfPages = self.imageCount;
    
    if (self.imageCount == 0) {
        return;
    }
    
    if (self.imageCount == 1) {
        self.scrollView.scrollEnabled = NO;
        self.pageControl.hidden = YES;
    } else {
        self.scrollView.scrollEnabled = YES;
        self.pageControl.hidden = NO;
    }
    
    [self updateSubViews];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    [self startTimer];
}

- (void)setIsAutoPlaying:(BOOL)autoPlaying
{
    _autoPlaying = autoPlaying;
    if (autoPlaying) {
        if (!self.timer) {
            [self startTimer];
        }
    } else {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    if (self.pageControl) {
        self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    }
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    if (self.pageControl) {
        self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger xPosition = scrollView.contentOffset.x;
    NSInteger width = self.frame.size.width;
    NSInteger originaOffset = self.movingView.frame.origin.x;
    
    NSInteger gap = originaOffset - xPosition;
    
    if (gap == 0) {
        return;
    }
    if (gap >= width || gap <= -width) {
        if (gap > 0) {
            self.displayingIndex = [self prevNIndex:1];
        } else {
            self.displayingIndex = [self nextNIndex:1];
        }
        self.pageControl.currentPage = self.displayingIndex;
        [self updateSubViews];
    } else if (gap > width/2 || (gap < 0 && gap > -width/2 && [self isMoveToRight])) {
        [self moveRightToLeft];
    } else if (gap < -width/2 || (gap > 0 && gap < width/2 && [self isMoveToLeft])) {
        [self moveLeftToRight];
    }
}

#pragma mark - private method
- (void)configView
{
    self.playingInterval = 5;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    
    self.displayingIndex = 0;
    self.isAutoPlaying = YES;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    self.pageControl.numberOfPages = 1;
    [self.pageControl sizeToFit];
    [self addSubview:self.pageControl];
    
    [self createSubViews];
}

- (void)createSubViews
{
    if (!self.leftView) {
        self.leftView = [self createImageView];
    }
    
    if (!self.middleView) {
        self.middleView = [self createImageView];
    }
    
    if (!self.rightView) {
        self.rightView = [self createImageView];
    }
}

- (void)updateSubViews
{
    if (!self.delegate) {
        return;
    }
    [self.delegate playerView:self imageForImageView:self.middleView atIndex:self.displayingIndex];
    [self.delegate playerView:self imageForImageView:self.leftView atIndex:[self prevNIndex:1]];
    [self.delegate playerView:self imageForImageView:self.rightView atIndex:[self nextNIndex:1]];
    
    [self updateSubViewsFrame];
    self.movingView = self.middleView;
    
    self.isMoveToRight = NO;
    self.isMoveToLeft = NO;
}

- (UIImageView *)createImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.scrollView addSubview:imageView];
    return imageView;
}

- (NSInteger)nextNIndex:(NSInteger)offset
{
    if (self.imageCount == 0) {
        return 0;
    }
    NSInteger index = self.displayingIndex + offset;
    return index % self.imageCount;
}

- (NSInteger)prevNIndex:(NSInteger)offset
{
    if (self.imageCount == 0) {
        return 0;
    }
    NSInteger index = self.displayingIndex - offset;
    return (index + self.imageCount) % self.imageCount;
}
- (void)moveRightToLeft
{
    if (self.isMoveToLeft) {
        return;
    }
    self.isMoveToLeft = YES;
    self.isMoveToRight = NO;
    UIImageView *temp = self.rightView;
    self.rightView = self.middleView;
    self.middleView = self.leftView;
    
    self.leftView = [self createImageView];
    self.leftView.frame = temp.frame;
    NSInteger index = [self prevNIndex:2];
    if (self.movingView == self.middleView) {
        index = [self prevNIndex:1];
    }
    [self.delegate playerView:self imageForImageView:self.leftView atIndex:index];
    [temp removeFromSuperview];
    
    [self updateSubViewsFrame];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.frame.size.width, 0);
}

- (void)moveLeftToRight
{
    if (self.isMoveToRight) {
        return;
    }
    self.isMoveToRight = YES;
    self.isMoveToLeft = NO;
    UIImageView *temp = self.leftView;
    self.leftView = self.middleView;
    self.middleView = self.rightView;
    
    // if UIImageView is not in the screen, it won't change its image immediately
    // if you set the image property a new object
    // so we need create a new UIImageView object
    // remove old view form superview
    self.rightView = [self createImageView];
    self.rightView.frame = temp.frame;
    NSInteger index = [self nextNIndex:2];
    if (self.movingView == self.middleView) {
        index = [self nextNIndex:1];
    }
    [self.delegate playerView:self imageForImageView:self.rightView atIndex:index];
    [temp removeFromSuperview];
    
    [self updateSubViewsFrame];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - self.frame.size.width, 0);
}

- (void)updateSubViewsFrame
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.leftView.frame = CGRectMake(0, 0, width, height);
    self.middleView.frame = CGRectMake(width, 0, width, height);
    self.rightView.frame = CGRectMake(width * 2, 0, width, height);
}

- (void)startTimer
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.playingInterval
                                                  target:self
                                                selector:@selector(timerOut:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerOut:(NSTimer *)timer
{
    [self moveLeftToRight];
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }];
}


@end
