//
//  PreferencesView.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PreferencesView.h"


@implementation PreferencesView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void) setLocationName:(NSString*) name {
	locationAdressLabel.text= name;
}

- (void) setLocationUrl:(NSString*) url {
	locationTextLabel.text=url;
}

- (void) setItemsCount:(NSInteger) count {
	NSInteger selectIndex=0;
	selectIndex=(count/25)-1;
	itemCountCtrl.selectedSegmentIndex=selectIndex;
}


- (void)dealloc {
    [super dealloc];
}


@end
