//
//  QueryParams.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 10/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QueryParams : NSObject {
	NSString *searchCriteria;
	NSString *category;
	NSString *categoryLong;
	NSInteger minValue;
	NSInteger maxValue;
	bool onlyPics;
	bool cats;
	bool dogs;
	bool onlyTitles;
	NSInteger roomsCount;
	int mode;
	bool jopt[5];
	int _sqid;	
	NSString *_name;
}

@property (nonatomic,retain) NSString *searchCriteria;
@property (nonatomic,retain) NSString *category;
@property (nonatomic,retain) NSString *categoryLong;

@property NSInteger minValue;
@property NSInteger maxValue;

@property bool onlyPics;
@property bool cats;
@property bool dogs;
@property bool onlyTitles;
@property NSInteger roomsCount;
@property int mode;

@property int sqid;
@property (nonatomic,retain) NSString *name;


- (NSString*) getQueryAsString;
-(void) saveDB;

-(id) initEmpty;

- (void) setJopt:(bool) value atIndex:(int)index;
- (bool) getJopt:(int) index;

- (void) setFromSavedQueryString:(NSString*) saved_query_string;
- (NSString*) getAsSavedQueryString;


@end
