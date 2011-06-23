//
//  DetailImagesController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 18/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DetailImagesController.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>
#import "Manager.h"


#define kAnimationKey @"transitionViewAnimation"

//float DegreesToRadians(float degrees) {return degrees * M_PI / 180;};

CGFloat distance (CGPoint fromPoint,CGPoint toPoint) {
    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    
    return sqrt(x * x + y * y);
};


@interface DetailImagesController() 

- (void) rotateFrom:(UIDeviceOrientation) from to:(UIDeviceOrientation) to;
- (void) toggleBars;

@end


@implementation DetailImagesController


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.navigationItem.title=@"Pictures";
		//self.view.layer.backgroundColor = CGColorCreateGenericGray(0.0f,1.0f);
		//self.view.layer.backgroundColor = CGColorCreateGenericCMYK(0.0f,0.0f,0.0f,0.0f,0.0f);
		CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray();
        const float transComps[2] = {0.0, 1.0};
        CGColorRef theColor = CGColorCreate(graySpace, transComps);
        CFRelease(graySpace);
       
		self.view.layer.backgroundColor = theColor;
		
		
		rootLayer = [CAScrollLayer layer];
		rootLayer.position=CGPointMake(160.0f,240.0f);
		rootLayer.bounds=CGRectMake(0.0f,0.0f,320.0f,480.0f);
		rootLayer.scrollMode =  kCAScrollHorizontally;
		rootLayer.masksToBounds = NO;
		//rootLayer.backgroundColor = CGColorCreateGenericGray(0.0f,1.0f);
		//rootLayer.backgroundColor = CGColorCreateGenericCMYK(0.0f,0.0f,0.0f,0.0f,0.0f);
		rootLayer.backgroundColor = theColor;
		
		[self.view.layer addSublayer:rootLayer];
		self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void) setImages:(NSArray*) theimages {
	NSInteger i=0;
	barvisibles=YES;
	landscape=NO;
	
	i = 0;
	_width=320.0f;
	_height=480.0f;
	
	for (UIImage* image in theimages) {
		CALayer  *temp;
		temp=[CALayer layer];
		temp.position=CGPointMake(((_width/2)+(i*_width)),_height/2);
		temp.bounds=CGRectMake(0.0f,0.0f,_width,_height);
		temp.contentsGravity = kCAGravityResizeAspect;
		
		temp.contents = [image CGImage];
		[rootLayer addSublayer:temp];
		i++;
	}
	minPositionX=0.0f;
	maxPositionX=(i-1)*_width;
	imageCount = i-1;
	currentPosition=CGPointMake(0,_height/2);
	rootLayer.anchorPoint = CGPointMake(0.5,0.5);
	currentTranslateX=0.0f;
	currentTranslateY=0.0f;
	initialDistance = 1.0f;
	
}
	

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
	NSSet *allTouches = [event allTouches];
	UIView * theview = self.view;
    
    switch ([allTouches count]) {
		case 1: {
			UITouch *touch = [touches anyObject];
			
			if (inzoom) {
				//translating
				startTouchPosition = [touch locationInView:theview]; 
			} else {
				//sliding pictures
				startTouchPosition = [touch locationInView:theview]; 
			}
		} break;
		
		case 2: {
			//zooming
			inzoom=YES;
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
            UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
            
            //and calculate our initial distance between them
            initialDistance = distance([touch1 locationInView:theview] , [touch2 locationInView:theview] );	
		} break;
	}
			
	
} 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
	
	if (barvisibles) {
		[self toggleBars];
	}
	
	
	NSSet *allTouches = [event allTouches];
	UIView * theview = self.view;
    
    switch ([allTouches count]) {
		case 1: {
			
				UITouch *touch = touches.anyObject; 
				CGPoint currentTouchPosition = [touch locationInView:theview]; 
				
				
								
				if (inzoom) {
					currentTranslateX = currentTranslateX-(startTouchPosition.x-currentTouchPosition.x);
					currentTranslateY = currentTranslateY-(startTouchPosition.y-currentTouchPosition.y);
					
					
					[rootLayer setValue:[NSNumber numberWithFloat:currentTranslateX] forKeyPath:@"transform.translation.x"];
					[rootLayer setValue:[NSNumber numberWithFloat:currentTranslateY] forKeyPath:@"transform.translation.y"];
				
				} else {
					
					if (currentOrientation==UIDeviceOrientationLandscapeLeft) {
						currentPosition.x = currentPosition.x+(startTouchPosition.y-currentTouchPosition.y);
					} else if (currentOrientation==UIDeviceOrientationLandscapeRight) {
						currentPosition.x = currentPosition.x-(startTouchPosition.y-currentTouchPosition.y);
					} else if (currentOrientation==UIDeviceOrientationPortraitUpsideDown) {
						currentPosition.x = currentPosition.x-(startTouchPosition.x-currentTouchPosition.x);
					} else {
						currentPosition.x = currentPosition.x+(startTouchPosition.x-currentTouchPosition.x);
					}
					
					[rootLayer scrollToPoint:currentPosition];
				}
				
				startTouchPosition.x=currentTouchPosition.x;
				startTouchPosition.y=currentTouchPosition.y;
				
				
				
			
			
		} break;
			
		case 2: {
			inzoom=YES;
			UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
            UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
			
			           
            //Calculate the distance between the two fingers.
			//CGFloat prevDistance = distance([touch1 previousLocationInView:theview] , [touch2 previousLocationInView:theview] );
            CGFloat finalDistance = distance([touch1 locationInView:theview] , [touch2 locationInView:theview] );
            
			if ( fabs(initialDistance - finalDistance)  > 150) {
				initialDistance = finalDistance; 
			}
			
			//CGFloat newZoom = finalDistance / initialDistance;
			
			
			//NSLog([@"INITDIST,FINDIST,ZOOM,NNZOOM : " stringByAppendingFormat:@"%f,%f,%f,%f" ,initialDistance,finalDistance,zoom,newZoom]);

			
			zoom += ((finalDistance / initialDistance)-1);
			
			/*
			if (zoom < newZoom) {
				
			} else {
				zoom -=(newZoom-zoom);
			}*/
		
			
		   
			            
			initialDistance = finalDistance;
			
			if (zoom < 1.0f) {zoom=1.0f;}
			
			[rootLayer setValue:[NSNumber numberWithFloat:zoom] forKeyPath:@"transform.scale.x"];
			[rootLayer setValue:[NSNumber numberWithFloat:zoom] forKeyPath:@"transform.scale.y"];
			
			
			
			
		} break;
	}
	
	
			
} 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
	NSSet *allTouches = [event allTouches];
	
	switch ([allTouches count]) {
		case 1: {
			UITouch *touch = touches.anyObject; 
			int tapc = [touch tapCount];
			
			
			
			if (inzoom) {
				if (tapc==2) {
					inzoom=NO;
					zoom=1.0f;
					currentTranslateX=0.0f;
					currentTranslateY=0.0f;
					[rootLayer setValue:[NSNumber numberWithFloat:0.0f] forKeyPath:@"transform.translation.x"];
					[rootLayer setValue:[NSNumber numberWithFloat:0.0f] forKeyPath:@"transform.translation.y"];
					[rootLayer setValue:[NSNumber numberWithFloat:zoom] forKeyPath:@"transform.scale.x"];
					[rootLayer setValue:[NSNumber numberWithFloat:zoom] forKeyPath:@"transform.scale.y"];
					
				}
			} else {
				
				if (tapc==1 && !barvisibles) {
					[self toggleBars];
				}
				
				
				CGPoint currentTouchPosition = [touch locationInView:[self view]]; 
				
				currentPosition.x = currentPosition.x-(startTouchPosition.x-currentTouchPosition.x);
				int tmp = round((currentPosition.x)/_width);
				currentPosition.x = tmp*_width;
				if (currentPosition.x < minPositionX) {
					currentPosition.x= minPositionX;
				}
				if (currentPosition.x > maxPositionX) {
					currentPosition.x=maxPositionX;
				}
				
				
				[rootLayer scrollToPoint:currentPosition];
			}
			
		} break;
			
		case 2: {
			if (zoom < 1.0f) {
				zoom=1.0f;
				currentTranslateX=0.0f;
				currentTranslateY=0.0f;
				inzoom=NO;
				//rescale to 1
				[rootLayer setValue:[NSNumber numberWithFloat:0.0f] forKeyPath:@"transform.translation.x"];
				[rootLayer setValue:[NSNumber numberWithFloat:0.0f] forKeyPath:@"transform.translation.y"];
				[rootLayer setValue:[NSNumber numberWithFloat:1.0f] forKeyPath:@"transform.scale.x"];
				[rootLayer setValue:[NSNumber numberWithFloat:1.0f] forKeyPath:@"transform.scale.y"];
	

			}
		} break;
	}
} 


- (void) relayout {
	minPositionX=0.0f;
	maxPositionX=(imageCount)*_width;
	rootLayer.bounds=CGRectMake(0.0f,0.0f,_width,_height);
	
	int i = 0;
	for (CALayer* temp in rootLayer.sublayers) {
		temp.position=CGPointMake(((_width/2)+(i*_width)),_height/2);
		temp.bounds=CGRectMake(0.0f,0.0f,_width,_height);
		i++;
	}
	
	[rootLayer scrollToPoint:currentPosition];

}

- (void) didRotate:(NSNotification *)notification
{	
	[self rotateFrom:currentOrientation to:[[UIDevice currentDevice] orientation]];
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
	
	//NSLog(@"BOUNDS %f,%f,%f,%f",rootLayer.bounds.origin.x,rootLayer.bounds.origin.y,rootLayer.bounds.size.width,rootLayer.bounds.size.height);
	
	if (to == UIDeviceOrientationLandscapeLeft || to == UIDeviceOrientationLandscapeRight) {
		landscape=YES;
		_width=480.0f;
		_height=320.0f;
		int tmp = round((currentPosition.x)/320.0f);
		currentPosition.x = tmp*_width;
	} else {
		landscape=NO;
		_width=320.0f;
		_height=480.0f;
		int tmp = round((currentPosition.x)/480.0f);
		currentPosition.x = tmp*_width;
	}
	
	[rootLayer setValue:[NSNumber numberWithFloat:toAngle] forKeyPath:@"transform.rotation.z"];
	
	currentOrientation=to;
	currentPosition.y = _height/2;
	[self relayout];	
}


- (void)viewWillAppear:(BOOL)animated {
	currentOrientation= [[UIDevice currentDevice] orientation];
	if (currentOrientation == UIDeviceOrientationLandscapeLeft || currentOrientation == UIDeviceOrientationLandscapeRight) {
		[self rotateFrom:UIInterfaceOrientationPortrait to:currentOrientation];
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	[[Manager getMain] setFullScreen];
	[[[self navigationController] navigationBar] setBarStyle:UIBarStyleBlackTranslucent];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	inzoom=NO;
	zoom=1.0f;

}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];

	//erasing all images sublayers
	while ([rootLayer.sublayers count]>0) {
		CALayer* temp = (CALayer*)[(NSArray*)rootLayer.sublayers lastObject];
		[temp removeFromSuperlayer];
		temp=nil;
	}
	
	if (currentOrientation != UIInterfaceOrientationPortrait) {
		[self rotateFrom:currentOrientation to:UIInterfaceOrientationPortrait];
	}
	
	[rootLayer scrollToPoint:CGPointMake(0,0)];
	

	
	[[Manager getMain] setNormal];
	[[[self navigationController] navigationBar] setBarStyle:UIBarStyleDefault];
	[[self navigationController] setNavigationBarHidden: NO animated: YES];
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	
	
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) toggleBars {
	if (barvisibles) {
		[[self navigationController] setNavigationBarHidden: YES animated: YES];
	} else {
		[[self navigationController] setNavigationBarHidden: NO animated: YES];
	}
	barvisibles = !barvisibles;
}

- (void)dealloc {
    [super dealloc];
}


@end
