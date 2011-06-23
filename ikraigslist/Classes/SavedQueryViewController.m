//
//  SavedQueryViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 24/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SavedQueryViewController.h"
#import "SimpleCell.h"
#import "DataManager.h"
#import "Manager.h"
#import "HomeViewController.h"
#import "QueryParams.h"


static UIImage *tabImage = nil;


@implementation SavedQueryViewController

@synthesize queries=_queries;

- (id)initWithStyle:(UITableViewStyle)style  {
	if (self = [super initWithStyle:style]) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 40.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionHeaderHeight = 0;
		tabImage = [[UIImage imageNamed:@"toolbar_queries.png"] retain];
		[self.tabBarItem initWithTitle:@"S'd searchs" image:tabImage tag:0];
		self.navigationItem.title=@"Saved searchs";
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
												   initWithTitle:@"Edit" 
												   style:UIBarButtonItemStylePlain 
												   target:self 
												   action:@selector(enterEditMode)] 
												  autorelease]; 
		[self reload];
		
	}
	return self;
}

- (void) enterEditMode {
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithTitle:@"Done" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(leaveEditMode)] 
											  autorelease]; 
	[self.tableView setEditing:YES animated:YES]; 
	[self.tableView beginUpdates]; 
	
}

-(void)leaveEditMode { 
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithTitle:@"Edit" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(enterEditMode)] 
											  autorelease]; 
	[self.tableView endUpdates]; 
	[self.tableView setEditing:NO animated:YES]; 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    NSUInteger count = [_queries count];
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//load a research with that query
	QueryParams *qp = [_queries objectAtIndex:indexPath.row];
	[Manager setQueryParams:qp];
	[(MasterViewController*)[Manager getMain] showHome];
	[(HomeViewController*)[Manager getHome] restoreFromParams];
	[(HomeViewController*)[Manager getHome] gocraig:nil];
	

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"MyIdentifier";
    
  	SimpleCell *cell = (SimpleCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[SimpleCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	// Load the query
	
	QueryParams *qp = [_queries objectAtIndex:indexPath.row];
	
	[cell setTheText:[qp name]];
	return cell;
}

-(void)tableView:(UITableView *)tableView  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	[DataManager deleteSavedQuery:[_queries objectAtIndex:[indexPath row]]];
	[_queries removeObjectAtIndex:[indexPath row]]; 
	[self.tableView reloadData]; 
} 


- (void)reload {
	if (_queries != nil) {
		[_queries removeAllObjects];
		[_queries release];
	}
	self.queries = [DataManager getSavedQueries];
	[self.tableView reloadData];
	
}

@end
