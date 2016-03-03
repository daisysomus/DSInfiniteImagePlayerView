//
//  ViewController.m
//  DSInfiniteImagePlayingView
//
//  Created by liaojinhua on 16/2/29.
//  Copyright © 2016年 Liao jinhua. All rights reserved.
//

#import "ViewController.h"
#import "DSInfiniteImagePlayingView.h"

const NSInteger ImageCount = 8;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet DSInfiniteImagePlayingView *infiniteScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:ImageCount];
    for (NSInteger index = 0; index < ImageCount; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%ld.jpg", index % 3 + 1]];
        [imagesArray addObject:image];
    }
    [self.infiniteScrollView setPlayingImages:imagesArray];
    self.infiniteScrollView.pageIndicatorTintColor = [UIColor greenColor];
    self.infiniteScrollView.currentPageIndicatorTintColor = [UIColor yellowColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
