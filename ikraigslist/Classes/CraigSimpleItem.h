//
//  CraigItem.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CraigSimpleItem : NSObject {

@private    
	NSString *_title;       
	NSString *_location;    
	NSString *_directlink;
	NSString *_date;
	BOOL _hasPics;
}

@property (nonatomic, retain) NSString *title;       
@property (nonatomic, retain) NSString *location;    
@property (nonatomic, retain) NSString *directlink;	
@property (nonatomic, retain) NSString *date;

@property BOOL hasPics;


@end
