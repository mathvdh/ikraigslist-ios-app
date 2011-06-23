//
//  Region.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 09/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Region : NSObject {
	NSString *name;
	NSArray *locations;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSArray *locations;


-(id) initWithName: (NSString*) thename andLocations:(NSArray*) thelocations;

@end
