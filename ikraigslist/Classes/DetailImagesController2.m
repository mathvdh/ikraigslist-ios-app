//
//  DetailImagesController2.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailImagesController2.h"
#import <QuartzCore/QuartzCore.h>
#import "Manager.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

@implementation DetailImagesController2

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.navigationItem.title=@"Pictures";
		
		
		imageScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
		[imageScrollView setBackgroundColor:[UIColor blackColor]];
		[imageScrollView setDelegate:self];
		[imageScrollView setBouncesZoom:YES];
		[imageScrollView setPagingEnabled:NO];
		[imageScrollView setScrollEnabled:YES];
		//imageScrollView.directionalLockEnabled=YES;
		imageScrollView.minimumZoomScale=1.0f;
		imageScrollView.maximumZoomScale=3.0f;
		
		
		
		[[self view] addSubview:imageScrollView];
		
		self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void) setImages:(NSArray*) theimages {
	int i=0;
	float _width=320.0f;
	float _height=480.0f;
	
	for (UIView* vi in imageScrollView.subviews) {
		[vi removeFromSuperview];
		//[vi release];
	}
	
	for (UIImage* image in theimages) {
		UIImageView *tmpview = [[UIImageView alloc] initWithImage:image];
		tmpview.center=CGPointMake(((_width/2)+(i*_width)),_height/2);
		//tmpview.center=CGPointMake((i*_width),0.0f);
		tmpview.bounds=CGRectMake(0.0f,0.0f,_width,_height);
		//temp.contentsGravity = kCAGravityResizeAspect;
		
		i++;
		[imageScrollView addSubview:tmpview];

	}
	
	imageScrollView.contentSize = CGSizeMake(i*_width,_height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	float xpos = scrollView.contentOffset.x;
	int aa  =  round( xpos / 320.0f);
	
    return [imageScrollView.subviews objectAtIndex:aa];
}

/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
  /*  [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];*/
}

- (void)viewWillAppear:(BOOL)animated {
	[[Manager getMain] setFullScreen];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	[[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[[Manager getMain] setNormal];
	[[[self navigationController] navigationBar] setBarStyle:UIBarStyleDefault];
	[[self navigationController] setNavigationBarHidden: NO animated: YES];
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[imageScrollView release];
    [super dealloc];
}





@end
