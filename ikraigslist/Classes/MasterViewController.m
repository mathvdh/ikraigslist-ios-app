//
//  MasterViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "PreferencesViewController.h"
#import "HomeViewController.h"
#import "BookmarksViewController.h"
#import "Manager.h"


@implementation MasterViewController

@synthesize controllers;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		fullscreen = CGRectMake(0, 0, 320, 480);
		normal = CGRectMake(0, 20, 320, 460);
		
		controllers = [[NSMutableArray alloc] init];
		
		[controllers addObject:[Manager getHomeNav]];
	
		[controllers addObject:[Manager getQueriesNav]];
		
		[controllers addObject:[Manager getBookmarksNav]];
		
		[controllers addObject:[Manager getPrefNav]];
		
		[controllers addObject:[Manager getHelp]];
		
		 
		self.viewControllers = controllers; 
		self.customizableViewControllers = controllers; 
		self.delegate = self; 

		
		[controllers release];

    }
    return self;
}

- (void) setFullScreen {
	self.view.frame=fullscreen;
}

- (void) setNormal {
	self.view.frame=normal;
}

- (void) showHome {
	self.selectedIndex = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
