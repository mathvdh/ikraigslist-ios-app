//
//  ListSectionItemCell.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SimpleCell : UITableViewCell {
	 UILabel *label;
}

@property (nonatomic,retain) UILabel* label;

- (void) setTheText:(NSString*) text;

@end
