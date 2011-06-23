//
//  BookmarksViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BookmarksViewController.h"
#import "SimpleCellWithDate.h"
#import "BookMark.h"
#import "DataManager.h"
#import "Manager.h"

static UIImage *tabImage = nil;

@implementation BookmarksViewController

@synthesize bookmarks=_bookmarks;

- (id)initWithStyle:(UITableViewStyle)style  {
	if (self = [super initWithStyle:style]) {
		_bookmarks=nil;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 40.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.sectionHeaderHeight = 0;
		tabImage = [[UIImage imageNamed:@"toolbar_bookmarks.png"] retain];
		[self.tabBarItem initWithTitle:@"Saved ads" image:tabImage tag:0];
		self.navigationItem.title=@"Saved ads";
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
    NSUInteger count = [_bookmarks count];
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[Manager getDetail2] laadFromBookmark:[_bookmarks objectAtIndex:indexPath.row]];
	[[self navigationController] pushViewController:[Manager getDetail2] animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *MyIdentifier = @"MyIdentifier";
    
  	SimpleCellWithDate *cell = (SimpleCellWithDate *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[SimpleCellWithDate alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	
	BookMark *b = [_bookmarks objectAtIndex:indexPath.row];
	
	[cell setTheText:[b name] andDate:[[[b savedItem] baseItem] date]];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

-(void)tableView:(UITableView *)tableView  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	[DataManager deleteBookmark:[_bookmarks objectAtIndex:[indexPath row]]];
	[_bookmarks removeObjectAtIndex:[indexPath row]]; 
	[self.tableView reloadData]; 
} 


- (void)reload {
	if (_bookmarks != nil) {
		[_bookmarks removeAllObjects];
		[_bookmarks release];
	}
	self.bookmarks = [DataManager getBookmarks];
	[self.tableView reloadData];

}



@end
