//
//  ImageGalleryController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 22/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDetectingImageView.h"

@interface ImageGalleryController : UIViewController <UIScrollViewDelegate, TapDetectingImageViewDelegate> {
	UIScrollView *imageScrollView;
	NSArray* theImages;
	NSInteger numImages;
	NSInteger curImage;
	CGFloat oldax;
	BOOL inzoom;
	BOOL barvisibles;
	BOOL landscape;
	UIDeviceOrientation currentOrientation;
	CGFloat kScrollObjHeight;
	CGFloat kScrollObjWidth;
	BOOL shouldRotate;
	UIDeviceOrientation rotateFrom;
	UIDeviceOrientation rotateTo;
	
}

- (void) relayout;
-(void) setImages:(NSArray*) theimages;

@end
