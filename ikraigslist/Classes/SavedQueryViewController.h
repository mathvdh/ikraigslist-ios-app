//
//  SavedQueryViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 24/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedQueryViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate> {
	NSMutableArray	*_queries;
	UIToolbar		*toolbar;
}

@property (nonatomic,retain) NSMutableArray * queries;

- (void)reload;


@end
