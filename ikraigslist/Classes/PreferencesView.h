//
//  PreferencesView.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PreferencesView : UIView {
	IBOutlet UILabel *locationTextLabel;
	IBOutlet UILabel *locationAdressLabel;
	IBOutlet UISegmentedControl *itemCountCtrl;

}

- (void) setLocationName:(NSString*) name;
- (void) setLocationUrl:(NSString*) url;
- (void) setItemsCount:(NSInteger) count;

@end
