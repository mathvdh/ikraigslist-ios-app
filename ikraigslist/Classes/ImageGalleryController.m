//
//  ImageGalleryController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 22/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImageGalleryController.h"
#import <QuartzCore/QuartzCore.h>
#import "Manager.h"
#import "TapDetectingImageView.h"




float DegreesToRadians(float degrees) {return degrees * M_PI / 180;};


@interface ImageGalleryController() 
- (void) rotateFrom:(UIDeviceOrientation) from to:(UIDeviceOrientation) to;
- (void) rotateFromInzoom:(UIDeviceOrientation) from to:(UIDeviceOrientation) to;
@end


@implementation ImageGalleryController


- (void) didRotate:(NSNotification *)notification
{	
	if (inzoom) {
		[self rotateFromInzoom:currentOrientation to:[[UIDevice currentDevice] orientation]];
	} else {
		[self rotateFrom:currentOrientation to:[[UIDevice currentDevice] orientation]];
	}
}

-(float) getAngle:(UIInterfaceOrientation) ori {
	switch (ori) {
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationFaceDown:
		case UIDeviceOrientationUnknown:
			return DegreesToRadians(0.0f);
		case UIDeviceOrientationLandscapeLeft:
			return DegreesToRadians(90.0f);
		case UIDeviceOrientationPortraitUpsideDown:
			return DegreesToRadians(180.0f);
		case UIDeviceOrientationLandscapeRight:
			return DegreesToRadians(270.0f);
	}
	
	return DegreesToRadians(0.0f);
}

- (void) rotateFrom:(UIDeviceOrientation) from to:(UIDeviceOrientation) to {
	
	float toAngle = [self getAngle:to];
	float fromAngle = [self getAngle:from];
	/*
	 NSLog(@"BOUNDS %f,%f,%f,%f",imageScrollView.bounds.origin.x,imageScrollView.bounds.origin.y,imageScrollView.bounds.size.width,imageScrollView.bounds.size.height);
	 NSLog(@"FRAME %f,%f,%f,%f",imageScrollView.frame.origin.x,imageScrollView.frame.origin.y,imageScrollView.frame.size.width,imageScrollView.frame.size.height);
	 NSLog(@"CENTER %f,%f",imageScrollView.center.x,imageScrollView.center.y);
	 */
	
	if (to == UIDeviceOrientationLandscapeLeft || to == UIDeviceOrientationLandscapeRight) {
		landscape=YES;
		kScrollObjWidth=480.0f;
		kScrollObjHeight=320.0f;
		
	} else {
		landscape=NO;
		kScrollObjWidth=320.0f;
		kScrollObjHeight=480.0f;
	}
	
	[UIView beginAnimations:nil context:NULL];
	CGAffineTransform t = imageScrollView.transform;
	imageScrollView.transform = CGAffineTransformRotate(t,(toAngle-fromAngle));
	
	imageScrollView.bounds=CGRectMake(0.0f,0.0f,kScrollObjWidth,kScrollObjHeight);
	imageScrollView.frame=CGRectMake(0.0f,0.0f,320.0f,480.0f);
	[UIView commitAnimations];
	
	/*
	 NSLog(@"BOUNDS %f,%f,%f,%f",imageScrollView.bounds.origin.x,imageScrollView.bounds.origin.y,imageScrollView.bounds.size.width,imageScrollView.bounds.size.height);
	 NSLog(@"FRAME %f,%f,%f,%f",imageScrollView.frame.origin.x,imageScrollView.frame.origin.y,imageScrollView.frame.size.width,imageScrollView.frame.size.height);
	 NSLog(@"CENTER %f,%f",imageScrollView.center.x,imageScrollView.center.y);
	 */
	
	
	currentOrientation=to;
	
	[self relayout];
	
}


- (void) rotateFromInzoom:(UIDeviceOrientation) from to:(UIDeviceOrientation) to {
	rotateFrom = from;
	rotateTo = to;
	shouldRotate=YES;
	[imageScrollView setZoomScale:1.0f animated:YES];

}

- (void) relayout {
	
	CGFloat curXLoc = 0;
	int max;
	int start;
	
	for (UIView* tmpview in imageScrollView.subviews) {
		if ([tmpview isKindOfClass:[UIImageView class]]) {
			
			CGRect rect = tmpview.frame;
			rect.size.height = kScrollObjHeight;
			rect.size.width = kScrollObjWidth;
			rect.origin = CGPointMake(curXLoc, 0);
			
			tmpview.frame = rect;
			
			curXLoc += (kScrollObjWidth);
		}
	}
	
	if (numImages <= 1) {
		start=0;
		max=1;
	} else {
		if (curImage==0) {
			max=2;
			start=0;
		} else if (curImage == (numImages-1)) {
			max=2;
			start=1;
		} else {
			max=3;
			start=1;
		}
		
	}
	
	
	CGPoint p = [imageScrollView contentOffset];
	p.x= start * kScrollObjWidth;
	
	[imageScrollView setContentSize:CGSizeMake((max * kScrollObjWidth), kScrollObjHeight)];
	[imageScrollView setContentOffset:p animated:NO];
		
}


- (void)reloadScrollImages
{	
	int start,max;
	CGFloat curXLoc = 0;
	
	
	for (UIView* vi in imageScrollView.subviews) {
		if ([vi isKindOfClass:[TapDetectingImageView class]]) {
			[vi removeFromSuperview];
		}
	}
	
	if (numImages <= 1) {
		start=0;
		max=1;
	} else {
		if (curImage==0) {
			imageScrollView.contentOffset=CGPointMake(0.0f,0.0f);
			max=2;
			start=0;
			
		} else if (curImage == (numImages-1)) {
			imageScrollView.contentOffset=CGPointMake(kScrollObjWidth,0.0f);
			max=2;
			start=curImage-1;
		} else {
			imageScrollView.contentOffset=CGPointMake(kScrollObjWidth,0.0f);
			max=3;
			start=curImage-1;
		}
		
	}
	
		
	for (int i=0;i<max;i++) {
		UIImage *image = [theImages objectAtIndex: (start+i) ];
		//UIImageView *tmpview = [[UIImageView alloc] initWithImage:image];
		TapDetectingImageView *tmpview = [[TapDetectingImageView alloc] initWithImage:image];
		CALayer * tmp = tmpview.layer;
		tmp.contentsGravity = kCAGravityResizeAspect;
		
		CGRect rect = tmpview.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		rect.origin = CGPointMake(curXLoc, 0);
		
		tmpview.frame = rect;
		tmpview.tag = i+1;	// tag our images for later use when we place them in serial fashion
		[tmpview setDelegate:self];
		//tmpview.userInteractionEnabled=YES;
		
		curXLoc += (kScrollObjWidth);
		
		[imageScrollView addSubview:tmpview];
		[tmpview release];
		
	}
	
	inzoom=NO;
	[imageScrollView setContentSize:CGSizeMake((max * kScrollObjWidth), [imageScrollView bounds].size.height)];

		
}

-(void) setImages:(NSArray*) theimages {

	theImages = theimages;
	numImages = [theimages count];
	curImage = 0;
	oldax=0.0f;
	
	
	[imageScrollView scrollRectToVisible:CGRectMake(0.0f,0.0f,kScrollObjWidth,kScrollObjHeight) animated:NO];
	[self reloadScrollImages];
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {

	if (scale == 1.0f) {
		int start;

		inzoom=NO;
		imageScrollView.pagingEnabled = YES;

		for (UIView* vi in imageScrollView.subviews) {
			if ([vi isKindOfClass:[UIImageView class]]) {
				[vi setHidden:NO];
			}
		}
		
		if (numImages <= 1 || curImage==0) {
			start=0;
		} else {
			start=1;
		}
		
		CGPoint p = [imageScrollView contentOffset];
		p.x= start * kScrollObjWidth;
		
		[imageScrollView setContentOffset:p animated:YES];
		
		if (shouldRotate) {
			shouldRotate=NO;
			[self rotateFrom:rotateFrom to:rotateTo];
		}
		
	} else {
		inzoom=YES;
		imageScrollView.pagingEnabled = NO;
	}
	
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	barvisibles = NO;
	[[self navigationController] setNavigationBarHidden: YES animated: YES];
	
	if (curImage==0) {
		if (numImages>1) {
			[(UIView*)[[scrollView subviews] objectAtIndex:1] setHidden:YES];
		}
		return [[scrollView subviews] objectAtIndex:0];
	} else if (curImage == (numImages-1)) {
		[(UIView*)[[scrollView subviews] objectAtIndex:0] setHidden:YES];
		return [[scrollView subviews] objectAtIndex:1];
	} else {
		[(UIView*)[[scrollView subviews] objectAtIndex:0] setHidden:YES];
		[(UIView*)[[scrollView subviews] objectAtIndex:2] setHidden:YES];
		return [[scrollView subviews] objectAtIndex:1];
	}
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	barvisibles = NO;
	[[self navigationController] setNavigationBarHidden: YES animated: YES];
	
	if (!inzoom) {
		oldax=scrollView.contentOffset.x;
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (!inzoom) {
		if (numImages > 1) {
			CGPoint a = scrollView.contentOffset;
			if (a.x < oldax) {
				curImage--;
				if( curImage <0) {
					curImage=0;
				}
			} else if (a.x > oldax) {
				curImage++;
				if (curImage >= numImages) {
					curImage=numImages;
				}
			}
			[self reloadScrollImages];

		}
	}
	
}


#pragma mark TapDetectingImageViewDelegate methods

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
	barvisibles=YES;
	[[self navigationController] setNavigationBarHidden: NO animated: YES];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
	[imageScrollView setZoomScale:1.0f animated:YES];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    // two-finger tap zooms out
	// do nothing
}





 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.navigationItem.title=@"Pictures";
		self.hidesBottomBarWhenPushed=YES;
		
		self.view.backgroundColor = [UIColor blackColor];
		imageScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
		[imageScrollView setBackgroundColor:[UIColor blackColor]];
		[imageScrollView setCanCancelContentTouches:NO];
		
		
		
		imageScrollView.scrollEnabled = YES;
	
		imageScrollView.showsVerticalScrollIndicator = NO;
		imageScrollView.showsHorizontalScrollIndicator = NO;
		
		[imageScrollView setDelegate:self];
		[imageScrollView setBouncesZoom:NO];
		
		imageScrollView.minimumZoomScale  = 1;
		imageScrollView.maximumZoomScale = 5;

	
		kScrollObjHeight = 480.0;
		kScrollObjWidth	= 320.0;
		landscape = NO;
		
		
		
		[self.view addSubview:imageScrollView];
	}
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

	currentOrientation= [[UIDevice currentDevice] orientation];
	if (currentOrientation == UIDeviceOrientationLandscapeLeft || currentOrientation == UIDeviceOrientationLandscapeRight) {
		[self rotateFrom:UIInterfaceOrientationPortrait to:currentOrientation];
	}
	
	shouldRotate=NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	
	
	[[Manager getMain] setFullScreen];
	[[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	barvisibles=NO;
	[[self navigationController] setNavigationBarHidden: YES animated: YES];

}

- (void)viewWillDisappear:(BOOL)animated {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	if (currentOrientation != UIInterfaceOrientationPortrait) {
		[self rotateFrom:currentOrientation to:UIInterfaceOrientationPortrait];
	}
	
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
