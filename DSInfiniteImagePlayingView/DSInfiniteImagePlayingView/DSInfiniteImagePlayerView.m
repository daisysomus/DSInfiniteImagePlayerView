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
@property (nonatomic, assign) NSInteger displayingIndex;

@property (nonatomic, strong) NSArray *displayingImages;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DSInfiniteImagePlayerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initView];
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

- (void)setPlayingImages:(NSArray *)images
{
    if (!images || images.count == 0) {
        return;
    }
    
    self.displayingImages = images;
    
    [self configView];
    [self createSubViews];
    [self updateSubViews];
    
    if (self.autoPlaying) {
        [self startTimer];
    }
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
- (void)initView
{
    self.playingInterval = 5;
}
- (void)configView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    
    self.displayingIndex = 0;
    self.isAutoPlaying = YES;
    
    if (self.displayingImages.count == 1) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    } else {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    }
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = self.displayingImages.count;
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    [self.pageControl sizeToFit];
    [self addSubview:self.pageControl];
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
    self.middleView.image = self.displayingImages[self.displayingIndex];
    self.leftView.image = self.displayingImages[[self prevNIndex:1]];
    self.rightView.image = self.displayingImages[[self nextNIndex:1]];
    
    [self updateSubViewsFrame];
    self.movingView = self.middleView;
}

- (UIImageView *)createImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.scrollView addSubview:imageView];
    return imageView;
}

- (NSInteger)nextNIndex:(NSInteger)offset
{
    NSInteger index = self.displayingIndex + offset;
    return index % self.displayingImages.count;
}

- (NSInteger)prevNIndex:(NSInteger)offset
{
    NSInteger index = self.displayingIndex - offset;
    return (index + self.displayingImages.count) % self.displayingImages.count;
}
- (void)moveRightToLeft
{
    if ([self isMoveToLeft]) {
        return;
    }
    UIImageView *temp = self.rightView;
    self.rightView = self.middleView;
    self.middleView = self.leftView;
    
    self.leftView = [self createImageView];
    self.leftView.frame = temp.frame;
    NSInteger index = [self prevNIndex:2];
    if (self.movingView == self.middleView) {
        index = [self prevNIndex:1];
    }
    self.leftView.image = self.displayingImages[index];
    [temp removeFromSuperview];
    
    [self updateSubViewsFrame];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.frame.size.width, 0);
}

- (void)moveLeftToRight
{
    if ([self isMoveToRight]) {
        return;
    }
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
    self.rightView.image = self.displayingImages[index];
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

- (BOOL)isMoveToRight
{
    if (self.rightView.image == self.displayingImages[[self nextNIndex:2]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isMoveToLeft
{
    if (self.leftView.image == self.displayingImages[[self prevNIndex:2]]) {
        return YES;
    }
    return NO;
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

- (void)timerOut:(NSTimer *)timer
{
    [self moveLeftToRight];
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    }];
}


@end
