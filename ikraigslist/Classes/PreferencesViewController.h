//
//  PreferencesViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PreferencesViewController : UIViewController {

}

- (void) restoreFromParams;
- (IBAction) chooseLocation: (id) sender ;
- (IBAction) eraseBookmarks: (id) sender ;
- (IBAction) eraseSavedSearchs: (id) sender;
- (IBAction) reInitAllParams: (id) sender;
- (IBAction) chooseItemsCount: (id) sender;


@end
