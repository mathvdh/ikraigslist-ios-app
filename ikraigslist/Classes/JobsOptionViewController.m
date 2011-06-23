//
//  JobsOptionViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 25/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JobsOptionViewController.h"
#import "SimpleCell.h"
#import "DataManager.h"
#import "Manager.h"


@implementation JobsOptionViewController

@synthesize jobsOptions=_jobsOptions;

- (id)initWithStyle:(UITableViewStyle)style  {
	if (self = [super initWithStyle:style]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 40.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionHeaderHeight = 0;
		self.navigationItem.title=@"Jobs options";
		
		_jobsOptions = [DataManager getJobsOptionsArray];

		
		[self.tableView reloadData];
		
	}
	return self;
}

- (void) reload {
	[self.tableView reloadData];	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    NSUInteger count = [_jobsOptions count];
    return count;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	[theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:NO];
    UITableViewCell *cell = [theTableView cellForRowAtIndexPath:newIndexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Reflect selection in data model
		[[Manager queryParams] setJopt:true atIndex: newIndexPath.row ];
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[Manager queryParams] setJopt:false atIndex: newIndexPath.row ];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"MyIdentifier2";
    
  	SimpleCell *cell = (SimpleCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[SimpleCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	NSString *opt = [_jobsOptions objectAtIndex:indexPath.row];
	
	[cell setTheText:opt];
	
	if ([[Manager queryParams] getJopt:indexPath.row]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}



- (void)dealloc {
    [super dealloc];
}


@end

