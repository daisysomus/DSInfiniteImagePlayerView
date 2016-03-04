//
//  ViewController.m
//  DSInfiniteImagePlayingView
//
//  Created by liaojinhua on 16/2/29.
//  Copyright © 2016年 Liao jinhua. All rights reserved.
//

#import "ViewController.h"
#import "DSInfiniteImagePlayerView.h"

const NSInteger ImageCount = 8;

@interface ViewController () <DSInfiniteImagePlayerViewDelegate>

@property (weak, nonatomic) IBOutlet DSInfiniteImagePlayerView *infiniteScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.infiniteScrollView.delegate = self;
    self.infiniteScrollView.pageIndicatorTintColor = [UIColor greenColor];
    self.infiniteScrollView.currentPageIndicatorTintColor = [UIColor yellowColor];
    self.infiniteScrollView.pageControlPosition = DSPageControlPositionTopRight;
    [self.infiniteScrollView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfImages:(DSInfiniteImagePlayerView *)playerView
{
    return ImageCount;
}

- (void)playerView:(DSInfiniteImagePlayerView *)playerView imageForImageView:(UIImageView *)imageView atIndex:(NSInteger)index
{
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%ld.jpg", index % 3 + 1]];
}

@end
