//
//  ListLocationsViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 20/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ListLocationsViewController.h"
#import "Manager.h"
#import "SimpleCell.h"
#import "DataManager.h"
#import "Region.h"
#import "Location.h"

@implementation ListLocationsViewController


- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.navigationItem.title=@"Locations";
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 40.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionHeaderHeight = 0;
	}
	
	currentRegion = nil;
	inRegion = NO;
	return self;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	if (inRegion) {
		if (currentRegion==nil || [currentRegion locations] == nil) {
			return 0;
		} else {
			return [[currentRegion locations] count];
		}
	} else {
		if (parentLocation == nil || [parentLocation sublocations]==nil) {
			return 0;
		} else {
			return [[parentLocation sublocations] count];
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Location* l;
	if (inRegion && [[currentRegion locations] objectAtIndex:indexPath.row]) {
		l = [(NSArray*)[currentRegion locations] objectAtIndex:indexPath.row];
	} else if ([[parentLocation sublocations] objectAtIndex:indexPath.row]) {
		l = [(NSArray*)[parentLocation sublocations] objectAtIndex:indexPath.row];
	}
	
	if (l && [l class] == [Location class]) {
		if (l.hasSublocations) {
			if (subvc==nil) {
				subvc = [[ListLocationsViewController alloc] initWithStyle:self.tableView.style];
			}
			[subvc setParentLocation:l];
			[[Manager getPrefNav] pushViewController:subvc animated:YES];
		} else {
			[DataManager setValue:l.url forKey:@"default_location_url"];
			[DataManager setValue:l.name forKey:@"default_location_name"];
			
			[[Manager appParams] setLocationUrl:l.url];
			[[Manager appParams] setLocationName:l.name];
			
			[[Manager getPref] restoreFromParams];
			//popup navigation controller
			[[Manager getPrefNav] popToRootViewControllerAnimated:YES];
		}
	}

	return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *MyIdentifier = @"MyIdentifier89";
	SimpleCell *cell = (SimpleCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[SimpleCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	if (inRegion && [[currentRegion locations] objectAtIndex:indexPath.row]) {
		Location * tmp = [[currentRegion locations] objectAtIndex:indexPath.row];
		
		// Set up the cell.
		[cell setTheText:tmp.name];
		if (tmp.hasSublocations) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	} else if ([[parentLocation sublocations] objectAtIndex:indexPath.row]) {
		Location * tmp = [[parentLocation sublocations] objectAtIndex:indexPath.row];
		
		// Set up the cell.
		[cell setTheText:tmp.name];
		if (tmp.hasSublocations) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	return cell;
}

- (void)dealloc {
	[super dealloc];
}

- (void) setCurrentRegion:(Region*) r {
	if (r!=nil) {
		inRegion=YES;
		currentRegion = r;
		self.navigationItem.title = r.name;
		[[self tableView] reloadData];
	}
}

- (void) setParentLocation:(Location*) l {
	if (l!=nil) {
		inRegion=NO;
		parentLocation = l;
		self.navigationItem.title = l.name;
		[[self tableView] reloadData];
	}
}


@end

