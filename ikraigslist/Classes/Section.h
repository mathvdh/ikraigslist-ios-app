//
//  Section.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 04/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Section : NSObject {
	NSString* name;
	NSString* urlpart;
	NSArray* subsections;
	BOOL hasSubsections;
	int viewMode;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *urlpart;
@property BOOL hasSubsections;
@property (nonatomic,retain) NSArray *subsections;
@property int viewMode;

-(id) initWithName: (NSString *) thename andUrl:(NSString*) theurl;
-(id) initParentWithName: (NSString *) thename;
-(id) initParentWithName: (NSString *) thename andUrl:(NSString*)theurl;
-(id) initParentWithName: (NSString *) thename andUrl:(NSString*) theurl andSubsections:(NSArray*)sub;

@end
