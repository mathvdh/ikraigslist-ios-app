//
//  BookmarksViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarksViewController :  UITableViewController<UITableViewDataSource,UITableViewDelegate> {
	NSMutableArray *_bookmarks;
}

@property (nonatomic,retain) NSMutableArray * bookmarks;

- (void)reload;

@end
