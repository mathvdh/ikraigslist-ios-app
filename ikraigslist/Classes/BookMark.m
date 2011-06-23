//
//  BookMark.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BookMark.h"
#import "CraigDetailedItem.h"
#import "DataManager.h";


@implementation BookMark

@synthesize savedItem = _savedItem;
@synthesize picturesString = _picturesString;
@synthesize picturesLoaded = _picturesLoaded;
@synthesize name = _name;
@synthesize bookId = _bookId;

-(id) initWithItem:(CraigDetailedItem*) theitem {
	if (self = [super init]) {
		self.savedItem = theitem;
		_picturesLoaded=NO;
		_bookId=0;
		_picturesString=nil;
		_name=nil;
	}
	return self;
	
}

-(void) loadPictures {
	//NSLog(@"++++%@",_picturesString);
	if (_picturesString != nil && _picturesString.length >0) {
		NSArray *filenames =  [_picturesString componentsSeparatedByString:@"||"];
		for (NSString* filename in filenames) {
			[_savedItem.images addObject:[DataManager loadImage:filename]];
		}
		_picturesLoaded=YES;
	} else {
		_picturesLoaded=YES;
	}
}

-(void) dealloc {
	if (_picturesString) {
		[_picturesString release];
	}
	
	if(_name) {
		[_name release];
	}
	if(_savedItem) {
		[_savedItem release];
	}
	
	
	[super dealloc];
}

@end
