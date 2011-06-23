//
//  AppParams.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 21/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AppParams.h"
#import "DataManager.h"


@implementation AppParams

@synthesize locationUrl;
@synthesize locationName;
@synthesize numberItems;
@synthesize currentController;

-(id) init {
	if (self = [super init]) {
		NSString *tmp,*tmp2,*tmp3,*tmp4;
		
		tmp = [DataManager getValueForKey:@"default_location_name"];
		tmp2 = [DataManager getValueForKey:@"default_location_url"];
		
		self.locationName=tmp;
		self.locationUrl=tmp2;
		
		tmp3 = [DataManager getValueForKey:@"default_number_items"];
		if (tmp3!=nil) {
			self.numberItems = [tmp3 intValue];
		} else {
			self.numberItems=0;
		}
		
		if (self.numberItems <25) {
			self.numberItems=25;
		}
		
		tmp4 = [DataManager getValueForKey:@"default_current_controller"];
		if (tmp4!=nil) {
			self.currentController = [tmp4 intValue];
		}
		
		[tmp release];
		[tmp2 release];
		[tmp3 release];
		[tmp4 release];
		

	}
	return self;
}

-(void) saveDB {
	if (locationUrl!=nil) {
		[DataManager setValue:locationUrl forKey:@"default_location_url"];
	}
	if (locationName != nil) {
		[DataManager setValue:locationName forKey:@"default_location_name"];
	}
	if (numberItems != 0) {
		[DataManager setValue:[NSString stringWithFormat:@"%d",numberItems] forKey:@"default_number_items"];
	}
	
	[DataManager setValue:[NSString stringWithFormat:@"%d",currentController] forKey:@"default_current_controller"];	

}

-(void) dealloc {
	if (locationName) {
		[locationName release];
	}
	if (locationUrl) {
		[locationUrl release];
	}
	[super dealloc];
}



@end
