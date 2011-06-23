//
//  CraigSectionXMLReader.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CraigSimpleItem.h"


@interface CraigSectionXMLReader : NSObject {

	
@private        
    CraigSimpleItem *_currentItemObject;
	NSString *_currentItemDate;
}

@property (nonatomic, retain) CraigSimpleItem *currentItemObject;
@property (nonatomic, retain) NSString *currentItemDate;

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;

@end
