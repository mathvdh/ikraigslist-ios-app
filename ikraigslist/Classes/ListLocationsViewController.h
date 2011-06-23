//
//  ListLocationsViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 20/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"
#import "Location.h"


@interface ListLocationsViewController : UITableViewController {
	Region * currentRegion;
	BOOL inRegion;
	Location * parentLocation;
	ListLocationsViewController* subvc;
}

- (id)initWithStyle:(UITableViewStyle)style;
-(void) setCurrentRegion:(Region*) r;
-(void) setParentLocation:(Location*) l;

@end
