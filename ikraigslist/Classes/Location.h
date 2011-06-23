//
//  Location.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 09/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Location : NSObject {
	NSString *name;
	NSString *url;
	BOOL hasSublocations;
	NSArray* sublocations;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *url;
@property BOOL hasSublocations;
@property (nonatomic,retain) NSArray *sublocations;

-(id) initWithName: (NSString *) thename andUrl:(NSString*) theurl;
-(id) initParentWithName: (NSString *) thename;
-(id) initParentWithName: (NSString *) thename andUrl:(NSString*)theurl;
-(id) initParentWithName: (NSString *) thename andUrl:(NSString*) theurl andSublocations:(NSArray*)sub;


@end
