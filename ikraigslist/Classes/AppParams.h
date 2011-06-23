//
//  AppParams.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 21/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppParams : NSObject {
	NSInteger numberItems;
	NSString *locationName;
	NSString *locationUrl;
	NSInteger currentController;
}

@property (nonatomic,retain) NSString *locationName;
@property (nonatomic,retain) NSString *locationUrl;
@property NSInteger currentController;
@property NSInteger numberItems;

-(void) saveDB;
@end
