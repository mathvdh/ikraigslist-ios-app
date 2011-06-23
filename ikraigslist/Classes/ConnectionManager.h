//
//  ConnectionManager.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 25/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConnectionManager : NSObject {

}


- (NSString *) getStringFromString : (NSString *) theString;
- (NSString *) getStringFromUrl : (NSURL *) theUrl;

- (UIImage *) getImageFromString : (NSString *) theString;
- (UIImage *) getImageFromUrl : (NSURL *) theUrl;


@end
