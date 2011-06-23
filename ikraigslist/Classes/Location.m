//
//  Location.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 09/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Location.h"


@implementation Location

@synthesize name;
@synthesize url;
@synthesize hasSublocations;
@synthesize sublocations;

-(id) initWithName: (NSString *) thename andUrl:(NSString*) theurl {
	if (self = [super init]) {
		self.name = thename;
		self.url = theurl;
	}
	hasSublocations=NO;
	return self;	
}

-(id) initParentWithName: (NSString *) thename {
	if (self = [super init]) {
		self.name = thename;
		self.url = @"nil";
		self.sublocations = nil;
	}
	hasSublocations=YES;
	return self;	
	
}

-(id) initParentWithName: (NSString *) thename andUrl:(NSString*) theurl {
	if (self = [super init]) {
		self.name = thename;
		self.url = theurl;
		self.sublocations = nil;
	}
	hasSublocations=YES;
	return self;	
}

-(id) initParentWithName: (NSString *) thename andUrl:(NSString*) theurl andSublocations:(NSArray*)sub {
	if (self = [super init]) {
		self.name = thename;
		self.url = theurl;
		self.sublocations = sub;
	}
	hasSublocations=YES;
	return self;	
}

- (void)dealloc {
    [super dealloc];
}


@end

