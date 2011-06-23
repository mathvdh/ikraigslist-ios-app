//
//  ListSectionsViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ListSectionsViewController : UITableViewController {
	ListSectionsViewController *subvc;
	NSArray* sections;
}

@property (nonatomic,retain) NSArray *sections;

- (id)initWithStyle:(UITableViewStyle)style title:(NSString*)atitle;


@end
