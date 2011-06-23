//
//  PreferencesViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PreferencesViewController.h"
#import "Manager.h"
#import "PreferencesView.h"
#import "DataManager.h"

static UIImage *tabImage = nil;

@implementation PreferencesViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		tabImage = [[UIImage imageNamed:@"toolbar_prefs.png"] retain];
		[self.tabBarItem initWithTitle:@"Preferences" image:tabImage tag:0]; 
		self.navigationItem.title=@"Preferences";
		[self restoreFromParams];

	}
    return self;
}

- (void) restoreFromParams {
	NSString *locUrl,*locName;
	locUrl = [[Manager appParams] locationUrl];
	locName = [[Manager appParams] locationName]; 
	
	if( [locName length]>0 && [locUrl length]>0 ) {
		[(PreferencesView*)self.view setLocationUrl:locUrl];
		[(PreferencesView*)self.view setLocationName:locName];
	} else {
		[(PreferencesView*)self.view setLocationUrl:@"touch to choose"];
		[(PreferencesView*)self.view setLocationName:@"Choose location"];		
	}
	
	[(PreferencesView*)self.view setItemsCount:[[Manager appParams] numberItems]];
}


- (IBAction) chooseLocation: (id) sender 
{  
	[[Manager getPrefNav] pushViewController:[Manager getListRegions] animated:YES];
}

- (IBAction) eraseBookmarks: (id) sender 
{ 
	[DataManager dropBookmarks];
}

- (IBAction) eraseSavedSearchs: (id) sender 
{ 
	[DataManager dropSavedQueries];
}

- (IBAction) reInitAllParams: (id) sender 
{ 
	[DataManager dropAllParams];
}

- (IBAction) chooseItemsCount: (id) sender 
{ 
	[[Manager appParams] setNumberItems: (([sender selectedSegmentIndex]+1)*25)];	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (void)dealloc {
    [super dealloc];
}


@end
