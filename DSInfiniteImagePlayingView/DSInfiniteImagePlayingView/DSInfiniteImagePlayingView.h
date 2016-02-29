//
//  DSInfiniteImagePlayingView.h
//  DSInfiniteImagePlayingView
//
//  Created by liaojinhua on 16/2/29.
//  Copyright © 2016年 Liao jinhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSInfiniteImagePlayingView : UIView

@property (nonatomic, assign) BOOL isAutoPlaying; // default is YESs

- (void)setPlayingImages:(NSArray *)images;

@end
