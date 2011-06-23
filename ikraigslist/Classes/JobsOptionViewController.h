//
//  JobsOptionViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 25/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JobsOptionViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate> {
	NSArray *_jobsOptions;
}

@property (nonatomic,retain) NSArray * jobsOptions;

- (void) reload;

@end
