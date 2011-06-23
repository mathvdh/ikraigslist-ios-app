//
//  AppDelegateMethods.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@class CraigSimpleItem, CraigsListAppDelegate;

@interface CraigsListAppDelegate (AppDelegateMethods)

- (void)showItemInfo:(CraigSimpleItem *)dictionary;
- (void)addToItemsList:(CraigSimpleItem *)eq;

@end
