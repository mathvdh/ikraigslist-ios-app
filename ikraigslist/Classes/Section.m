//
//  Section.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 04/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Section.h"


@implementation Section

@synthesize name;
@synthesize urlpart;
@synthesize hasSubsections;
@synthesize subsections;
@synthesize viewMode;

-(id) initWithName: (NSString *) thename andUrl:(NSString*) theurl {
	if (self = [super init]) {
		self.name = thename;
		self.urlpart = theurl;
	}
	hasSubsections=NO;
	return self;	
}

-(id) initParentWithName: (NSString *) thename {
	if (self = [super init]) {
		self.name = thename;
		self.urlpart = @"nil";
		self.subsections = nil;
	}
	hasSubsections=YES;
	return self;	
	
}

-(id) initParentWithName: (NSString *) thename andUrl:(NSString*) theurl {
	if (self = [super init]) {
		self.name = thename;
		self.urlpart = theurl;
		self.subsections = nil;
	}
	hasSubsections=YES;
	return self;	
}

-(id) initParentWithName: (NSString *) thename andUrl:(NSString*) theurl andSubsections:(NSArray*)sub {
	if (self = [super init]) {
		self.name = thename;
		self.urlpart = theurl;
		self.subsections = sub;
	}
	hasSubsections=YES;
	return self;	
}

- (void)dealloc {
    [super dealloc];
}

@end
