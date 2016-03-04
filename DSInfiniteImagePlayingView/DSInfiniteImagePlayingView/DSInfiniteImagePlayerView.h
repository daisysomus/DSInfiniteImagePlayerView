//
//  DSInfiniteImagePlayerView.h
//  DSInfiniteImagePlayerView
//
//  Created by liaojinhua on 16/2/29.
//  Copyright © 2016年 Liao jinhua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DSPageControlPosition) {
    DSPageControlPositionTopLeft,
    DSPageControlPositionTopCenter,
    DSPageControlPositionTopRight,
    DSPageControlPositionBottonLeft,
    DSPageControlPositionBottonCenter,  // Default
    DSPageControlPositionBottonRight
};

@class DSInfiniteImagePlayerView;

@protocol DSInfiniteImagePlayerViewDelegate <NSObject>

@required;
- (NSUInteger)numberOfImages:(nonnull DSInfiniteImagePlayerView *)playerView;

- (void)playerView:(nonnull DSInfiniteImagePlayerView *)playerView
 imageForImageView:(nonnull UIImageView *)imageView
           atIndex:(NSInteger)index;

@end

@interface DSInfiniteImagePlayerView : UIView

@property (nullable, weak) id<DSInfiniteImagePlayerViewDelegate> delegate;

@property (nonatomic, assign) BOOL autoPlaying; // default is YES

@property (nonatomic, assign) DSPageControlPosition pageControlPosition;

@property (nonatomic, assign) NSTimeInterval playingInterval; // default is 5 seconds

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;

@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

- (void)reloadData;

@end
