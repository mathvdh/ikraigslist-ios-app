//
//  RegionsParser.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 01/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Region.h"
#import "Location.h"
#import <sqlite3.h>

#include <libxml/HTMLparser.h>

@interface RegionsParser : NSObject {
	htmlDocPtr _docRegions;
	htmlDocPtr _docGeo;
	htmlDocPtr _docLocation;
	htmlDocPtr _docFinal;
	NSMutableArray * regions;
	NSMutableArray * regionsFiles;
	NSMutableArray * regionsNames;
	sqlite3_stmt *region_insert_statement;
	sqlite3_stmt *region_get_statement;
	sqlite3_stmt *location_insert_statement;
	sqlite3 *database;
	char *sqlLocGet;
	


}

@property (nonatomic,retain) NSMutableArray *regions;

- (void) parseRegions :(NSString*) name;
-(Location*) parseGeoAdress : (NSString*) address andName:(NSString*) name;
-(Location*) handleLocation:(NSString*)thename andUrl:(NSString*)theurl;
-(Location*) handleFinalLocation:(NSString*)theurl;

-(void) initDB;
- (void) saveRegionsToDb;
-(void) insertLocationDB:(Location*) loc regionID:(int)rid parentID:(int)pid;
-(NSMutableArray*) loadRegionsFromDb;
-(NSMutableArray*) loadLocationsFromDb:(int) rid parentID:(int)pid;

@end
