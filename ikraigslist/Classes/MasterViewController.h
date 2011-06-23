//
//  MasterViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MasterViewController : UITabBarController<UITabBarControllerDelegate> {
	NSMutableArray *controllers;
	CGRect normal;
	CGRect fullscreen;
	
}

@property (nonatomic,retain) NSMutableArray *controllers;
- (void) setFullScreen;
- (void) setNormal;
- (void) showHome;



@end
