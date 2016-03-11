# DSInfiniteImagePlayerView
## Features
* Display multiple images
* Infinite scrolll
* Auto playing images with setting interval
* Customize page control position

## How to use

		pod "DSInfiniteImagePlayerView"
		
or

		copy the source file to your project
		
## Demo code
	
		self.infiniteScrollView = [[DSInfiniteImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
		self.infiniteScrollView.delegate = self;
    	self.infiniteScrollView.pageIndicatorTintColor = [UIColor greenColor];
    	self.infiniteScrollView.currentPageIndicatorTintColor = [UIColor yellowColor];
    	self.infiniteScrollView.pageControlPosition = DSPageControlPositionTopRight;
    	[self.infiniteScrollView reloadData];
    
then implement the protocol DSInfiniteImagePlayerViewDelegate
		
		- (NSUInteger)numberOfImages:(DSInfiniteImagePlayerView *)playerView
		{
    		return ImageCount;
		}

		- (void)playerView:(DSInfiniteImagePlayerView *)playerView imageForImageView:(UIImageView *)imageView atIndex:(NSInteger)index
		{
   	 		imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image		%ld.jpg", index % 3 + 1]];
		}
 		
    
you also can use this in storyboard. just set the class of your view to DSInfiniteImagePlayerView, then make an outlet from storyboard and set the properties you want.

> Note: you must set the delegate, or it won't display the images.
