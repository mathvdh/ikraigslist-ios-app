//
//  SimpleCellWithDate.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SimpleCellWithDate : UITableViewCell {
	 UILabel *labelText;
	 UILabel *labelDate;

}

@property (nonatomic,retain) UILabel* labelText;
@property (nonatomic,retain) UILabel* labelDate;

- (void) setTheText:(NSString*) text andDate:(NSString*) date;

@end
