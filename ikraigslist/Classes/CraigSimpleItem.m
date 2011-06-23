//
//  CraigItem.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CraigSimpleItem.h"


@implementation CraigSimpleItem

@synthesize title = _title;
@synthesize location = _location;
@synthesize directlink = _directlink;
@synthesize hasPics = _hasPics;
@synthesize date = _date;

-(id) init {
	if (self = [super init]) {
		self.hasPics = FALSE;
		_date=@"";
		_title=nil;
		_location=nil;
		_directlink=nil;
	}
	return self;
}

- (void)dealloc {
	if (_title) {
		[_title release];
	}
	if (_location) {
		[_location release];
	}
	if (_directlink) {
		[_directlink release];
	}
	if (_date) {
		[_date release];
	}
	[super dealloc];
}



@end
