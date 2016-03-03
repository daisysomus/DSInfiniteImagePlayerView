//
//  DSInfiniteImagePlayingView.h
//  DSInfiniteImagePlayingView
//
//  Created by liaojinhua on 16/2/29.
//  Copyright © 2016年 Liao jinhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSInfiniteImagePlayingView : UIView

@property (nonatomic, assign) BOOL isAutoPlaying; // default is YES

@property (nonatomic, assign) NSTimeInterval playingInterval; // default is 5 seconds

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;

@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

- (void)setPlayingImages:(nullable NSArray *)images;

@end
