//
//  ListSectionsViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ListSectionsViewController.h"
#import "SimpleCell.h"
#import "CraigsListAppDelegate.h"
#import "DataManager.h"
#import "Manager.h"


@implementation ListSectionsViewController

@synthesize sections;

- (id)initWithStyle:(UITableViewStyle)style title:(NSString*)atitle {
	if (self = [super initWithStyle:style]) {
		self.title=atitle;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 40.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionHeaderHeight = 0;
		subvc=nil;
	}
	return self;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	return [sections count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Section *s = [sections objectAtIndex:indexPath.row];
	
	if (s.hasSubsections) {
		if (subvc==nil) {
			subvc = [[ListSectionsViewController alloc] initWithStyle:self.tableView.style title:s.name];
		}
		subvc.navigationItem.title =  s.name;
		subvc.sections = s.subsections;
		
		[subvc.tableView reloadData];
		 
		[[Manager getHomeNav] pushViewController:subvc animated:YES];
	} else {
		[[Manager queryParams] setCategory:s.urlpart];
		[[Manager queryParams] setCategoryLong:s.name];

		[[Manager getHome] setSectionTitle:s.name];
		[[Manager getHome] setViewMode:s.viewMode];
		[[Manager getHomeNav] popToRootViewControllerAnimated:YES];
	}
	return;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"MyIdentifier2";
    
  	SimpleCell *cell = (SimpleCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[SimpleCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	Section *tmp = [sections objectAtIndex: indexPath.row];
	
	if (tmp.hasSubsections) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    // Set up the cell.
    [cell setTheText:tmp.name];
	return cell;
}

- (void)dealloc {
	[super dealloc];
}


@end

