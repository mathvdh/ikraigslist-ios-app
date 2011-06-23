//
//  CraigListLAppDelegate.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CraigsListAppDelegate.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import "MasterViewController.h"
#import "QueryParams.h"
#import "Manager.h"
#import "DataManager.h"



@implementation CraigsListAppDelegate

@synthesize window;



- init {
	if (self = [super init]) {
		// Initialization code
		
	}
	return self;
}



- (void)dealloc {
	[window release];

	[super dealloc];
}










- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch. 
	[[Manager getMain] setSelectedIndex: [[Manager appParams] currentController]];
	
	// Configure and show the window
	[window addSubview:[[Manager getMain] view]];
	[window makeKeyAndVisible];
    
	
	return YES;
}





- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"applicationWillTerminate");
   	[[Manager appParams] setCurrentController:[[Manager getMain] selectedIndex]];
	[[Manager getHome] pushQueryParams];
	[[Manager queryParams] saveDB];
	[[Manager appParams] saveDB];
	[DataManager closeDB];
}





@end

