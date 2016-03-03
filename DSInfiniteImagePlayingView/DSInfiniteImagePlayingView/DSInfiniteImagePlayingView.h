//
//  DSInfiniteImagePlayerView.h
//  DSInfiniteImagePlayerView
//
//  Created by liaojinhua on 16/2/29.
//  Copyright © 2016年 Liao jinhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSInfiniteImagePlayerViewDelegate <NSObject>


@end

@interface DSInfiniteImagePlayerView : UIView

@property (nonatomic, assign) BOOL autoPlaying; // default is YES

@property (nonatomic, assign) NSTimeInterval playingInterval; // default is 5 seconds

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;

@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

- (void)setPlayingImages:(nullable NSArray *)images;

- (void)reloadData;

@end
