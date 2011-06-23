//
//  CraigsListAppDelegate.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"
#import "QueryParams.h"



@interface CraigsListAppDelegate : NSObject <UIApplicationDelegate> {
	
	IBOutlet UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;

@end
