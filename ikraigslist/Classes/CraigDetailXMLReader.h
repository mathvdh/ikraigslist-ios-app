//
//  CraigDetailXMLReader.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 17/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <libxml/HTMLparser.h>
#import "CraigDetailedItem.h"

@interface CraigDetailXMLReader : NSObject {
	htmlDocPtr _doc;
	CraigDetailedItem *_item;
	
}

- (void) parseFromObject:(CraigDetailedItem *) item;
@end
