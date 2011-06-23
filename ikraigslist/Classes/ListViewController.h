//
//  ListViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate> {
}
-(void) setTitle:(NSString*) title;
@end
