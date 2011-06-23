//
//  DetailImagesController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 18/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DetailImagesController : UIViewController {
	float minPositionX;
	float maxPositionX;
	float _width;
	float _height;
	CGPoint startTouchPosition;
	float currentTranslateX;
	float currentTranslateY;
	
	CGFloat initialDistance;
	CGFloat zoom;
	
	CAScrollLayer *rootLayer;
	CGPoint currentPosition;
	BOOL barvisibles;
	int imageCount;
	BOOL landscape;
	UIDeviceOrientation currentOrientation;
	
	BOOL inzoom;
}

-(void) setImages:(NSArray*) theimages;

@end

