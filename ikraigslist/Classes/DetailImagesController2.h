//
//  DetailImagesController2.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailImagesController2 : UIViewController<UIScrollViewDelegate> {
	 UIScrollView *imageScrollView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
