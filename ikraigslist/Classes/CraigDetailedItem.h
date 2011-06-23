//
//  CraigDetailedItem.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 22/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CraigSimpleItem.h"


@interface CraigDetailedItem : NSObject {
	CraigSimpleItem *_baseItem;
	NSString *_emailLink;
	NSString *_mapLink;
	NSMutableArray  *_images;
	NSMutableArray *_imagesUrls;
	NSString *_htmlContent;
	NSString *_bodyContent;
	
	int _imagesCount;
	BOOL _loaded;
}

@property (nonatomic,retain) CraigSimpleItem *baseItem;
@property (nonatomic,retain) NSString *emailLink;
@property (nonatomic,retain) NSString *mapLink;
@property (nonatomic,retain) NSMutableArray *images;
@property (nonatomic,retain) NSMutableArray *imagesUrls;
@property (nonatomic,retain) NSString *htmlContent;
@property (nonatomic,retain) NSString *bodyContent;
@property int imagesCount;
@property BOOL loaded;


- (void) addImage:(NSString *) imageurl;
-(id) initWithBase:(CraigSimpleItem*) thebase;
- (void) loadMe;
@end
