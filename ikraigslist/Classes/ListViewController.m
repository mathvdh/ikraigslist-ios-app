//
//  ListViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"
#import "CraigsListAppDelegate.h"
#import "ListViewItemCell.h"
#import "AppDelegateMethods.h"
#import "DetailViewController.h"
#import "Manager.h"

@implementation ListViewController


- (id)initWithStyle:(UITableViewStyle)style  {
	if (self = [super initWithStyle:style]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionHeaderHeight = 0;
	}
	return self;
}


-(void) setTitle:(NSString*) title {
	self.navigationItem.title = title;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    NSUInteger count = [[Manager getHome] countOfList];
    if ([Manager isDataSourceAvailable] == NO) {
        return 1;
    }
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	CraigSimpleItem* lvi = [(ListViewItemCell*)[tableView cellForRowAtIndexPath:indexPath] item];
	
	CraigDetailedItem *cditem = [[CraigDetailedItem alloc] initWithBase:lvi];
	
	[[Manager getDetail] setItem:cditem];
	[[Manager getDetail] reload];
	
	[[Manager getHomeNav] pushViewController:[Manager getDetail] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"MyIdentifier";
    
  	ListViewItemCell *cell = (ListViewItemCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[ListViewItemCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
    
    // Set up the cell.
	HomeViewController* ct = (HomeViewController *)[Manager getHome];
    
    // If the RSS feed isn't accessible (which could happen if the network isn't available), show an informative
    // message in the first row of the table.
	if ([Manager isDataSourceAvailable] == NO) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DefaultTableViewCell"] autorelease];
        cell.textLabel.text = NSLocalizedString(@"Craigslist Host Not Available", @"RSS Host Not Available message");
		cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:0.5];
		cell.accessoryType = UITableViewCellAccessoryNone;
		return cell;
	}
	
	CraigSimpleItem *citem = [ct objectInListAtIndex:indexPath.row];
    [cell setItem:citem];
	return cell;
}


- (void)dealloc {
	[super dealloc];
}


- (void)loadView {
	[super loadView];

}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end

