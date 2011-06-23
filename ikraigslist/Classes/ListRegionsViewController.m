//
//  ListRegionsViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 31/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ListRegionsViewController.h"
#import "DataManager.h"
#import "SimpleCell.h"
#import "Manager.h"


@implementation ListRegionsViewController

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
		self.navigationItem.title=@"Regions";
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 40.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionHeaderHeight = 0;
	}
	
	llvc = [[ListLocationsViewController alloc] initWithStyle:style];
	
	return self;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	return [DataManager getRegionsCount];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//we save the selected location into the queryparmas object
	Region * r= [DataManager getRegion:indexPath.row];
	[llvc setCurrentRegion:r];
	
	[[Manager getPrefNav] pushViewController:llvc animated:YES];
	
	return;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"MyIdentifier4";
    
  	SimpleCell *cell = (SimpleCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[SimpleCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	Region *r = [DataManager getRegion:indexPath.row];
    
    // Set up the cell.
    [cell setTheText:r.name];
	return cell;
}

- (void)dealloc {
	[super dealloc];
}



@end

