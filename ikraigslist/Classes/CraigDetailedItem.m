//
//  CraigDetailedItem.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 22/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CraigDetailedItem.h"
#import "CraigDetailXMLReader.h"
#import "ConnectionManager.h"

@interface CraigDetailedItem()
- (void) parse;

@end



@implementation CraigDetailedItem

@synthesize images = _images;
@synthesize imagesUrls = _imagesUrls;
@synthesize imagesCount = _imagesCount;
@synthesize htmlContent = _htmlContent;
@synthesize bodyContent = _bodyContent;
@synthesize emailLink = _emailLink;
@synthesize mapLink = _mapLink;
@synthesize baseItem = _baseItem;
@synthesize loaded = _loaded;


-(id) initWithBase:(CraigSimpleItem*) thebase {
	if (self = [super init]) {
		self.baseItem = thebase;
		_images = [[NSMutableArray alloc] init];
		_imagesUrls = [[NSMutableArray alloc] init];
		_loaded=NO;
		_htmlContent=nil;
		_emailLink=nil;
		_mapLink=nil;
	}
	return self;
}

-(id) init {
	if (self = [super init]) {
		_images = [[NSMutableArray alloc] init];
		_imagesUrls = [[NSMutableArray alloc] init];
		_loaded=NO;
		_htmlContent=nil;
		_emailLink=nil;
		_mapLink=nil;
		_baseItem=nil;
	}
	return self;
}

- (void) addImage:(NSString *) imageurl {
	//here we got the image
	ConnectionManager * cm = [[ConnectionManager alloc] init];
	UIImage *temp = [cm getImageFromString:imageurl];
	[cm release];
	
	if (temp != nil) {
		[_images addObject:temp];
		[_imagesUrls addObject:imageurl];
		_imagesCount++;
	}
}

- (void) parse {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CraigDetailXMLReader *reader = [[[CraigDetailXMLReader alloc] init] autorelease];
	[reader parseFromObject:self];
	[pool drain];
	
	_loaded=YES;
}

- (void) loadMe {
	if (!_loaded) {
		
		if (_htmlContent) {
			[_htmlContent release];
		}
		
		ConnectionManager * cm = [[ConnectionManager alloc] init];
		
		if (_htmlContent) {
			[_htmlContent release];
			
		}
		_htmlContent = nil;
		_htmlContent = [cm getStringFromString: _baseItem.directlink];
		
		[cm release];
		if (_htmlContent == nil) {
			return;
		}
		
		[NSThread detachNewThreadSelector:@selector(parse) toTarget:self withObject:nil];
	}
}

- (void) dealloc {
	if (_baseItem) {
		[_baseItem release];
	}
	if (_emailLink) {
		[_emailLink release];
	}
	if (_mapLink) {
		[_mapLink release];
	}
	if (_images) {
		[_images release];
	}
	if (_imagesUrls) {
		[_imagesUrls release];
	}
	if (_htmlContent) {
		[_htmlContent release];
	}
	if (_bodyContent) {
		[_bodyContent release];
	}
	[super dealloc];
}

@end
