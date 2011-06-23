//
//  DataManager.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CraigDetailedItem.h"
#import "QueryParams.h"
#import "BookMark.h"
#import "Region.h"
#import "Location.h"
#import "Section.h"


@interface DataManager : NSObject {

}

+ (NSString*) getValueForKey:(NSString*)thekey;
+ (BOOL) setValue:(NSString*) value forKey:(NSString*)thekey;
+ (void) closeDB;


+ (Region*) getRegion:(NSInteger)index;
+ (NSInteger) getRegionsCount;

+ (NSArray*) getSections;

//+ (NSString*) writeImage:(UIImage*) theImage;
+ (NSString*) writeImageTemp:(UIImage*) theImage;

+ (void) deleteImage: (NSString*) theName;
+ (UIImage*) loadImage:(NSString*) filename;

+ (BOOL) dropAllParams;


+ (NSMutableArray*) getSavedQueries;
+ (BOOL) dropSavedQueries;
+ (BOOL) saveQuery:(QueryParams*) params;
+ (BOOL) deleteSavedQuery: (QueryParams*) query;

+ (NSMutableArray*) getBookmarks;
+ (BOOL) dropBookmarks;
+ (BOOL) saveBookmark:(BookMark*)book;
+ (BOOL) deleteBookmark:(BookMark*)book;

+(NSArray*) getJobsOptionsArray;
+(NSArray*) getJobsUrlOptions;

+(NSString*) getDocumentDirectory;
+(NSString*) getTempDirectory;
+(NSString*) getBundleDirectory;
+(NSString*) getLoadingHtml;

@end
