//
//  BookMark.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CraigDetailedItem.h"

@interface BookMark : NSObject {
	CraigDetailedItem *_savedItem;
	NSString *_name;
	NSUInteger _bookId;
	NSString *_picturesString;
	BOOL _picturesLoaded;
}

@property (nonatomic,retain) CraigDetailedItem *savedItem;
@property (nonatomic,retain) NSString *name;
@property NSUInteger bookId;
@property (nonatomic,retain) NSString *picturesString;
@property BOOL picturesLoaded;

-(id) initWithItem:(CraigDetailedItem*) theitem;
-(void) loadPictures;

@end

