//
//  DSInfiniteImagePlayingView.m
//  DSInfiniteImagePlayingView
//
//  Created by liaojinhua on 16/2/29.
//  Copyright © 2016年 Liao jinhua. All rights reserved.
//

#import "DSInfiniteImagePlayingView.h"

@interface DSInfiniteImagePlayingView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *middleView;
@property (nonatomic, strong) UIImageView *rightView;

@property (nonatomic, strong) UIImageView *movingView;
@property (nonatomic, assign) NSInteger displayingIndex;

@property (nonatomic, strong) NSArray *displayingImages;

@end

@implementation DSInfiniteImagePlayingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.bounds, self.scrollView.frame)) {
        self.scrollView.frame = self.bounds;
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
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger xPosition = scrollView.contentOffset.x;
    NSInteger width = self.frame.size.width;
    NSInteger originaOffset = self.movingView.frame.origin.x;
    
    NSInteger gap = originaOffset - xPosition;
    NSLog(@"scollview content offset : %ld gap: %ld", (long)xPosition, (long)gap);
    if (gap == 0) {
        return;
    }
    if (gap > width || gap < -width) {
        if (gap > 0) {
            self.displayingIndex = [self prevNIndex:1];
        } else {
            self.displayingIndex = [self nextNIndex:1];
        }
        [self updateSubViews];
        
    } else if (gap > width/2) {
        [self moveRightToLeft];
    } else if (gap < -width/2) {
        [self moveLeftToRight];
    }
}

#pragma mark - private method
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
    if (self.leftView.image == self.displayingImages[[self prevNIndex:2]]) {
        return;
    }
    NSLog(@"move to left");
    UIImageView *temp = self.rightView;
    self.rightView = self.middleView;
    self.middleView = self.leftView;
    self.leftView = temp;
    
    self.leftView.image = self.displayingImages[[self prevNIndex:2]];
    
    [self updateSubViewsFrame];
    self.movingView = self.rightView;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.frame.size.width, 0);
}

- (void)moveLeftToRight
{
    if (self.rightView.image == self.displayingImages[[self nextNIndex:2]]) {
        return;
    }
    NSLog(@"move to right");
    UIImageView *temp = self.leftView;
    self.leftView = self.middleView;
    self.middleView = self.rightView;
    self.rightView = temp;
    
    self.rightView.image = self.displayingImages[[self nextNIndex:2]];
    
    [self updateSubViewsFrame];
    self.movingView = self.leftView;
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


@end
