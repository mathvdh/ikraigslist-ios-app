//
//  SectionsParser.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 04/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Section.h"
#import <sqlite3.h>
#include <libxml/HTMLparser.h>


@interface SectionsParser : NSObject {
	htmlDocPtr _docSections;
	NSMutableArray *sections;
	NSMutableArray *sectionsNames;
	NSMutableArray *sectionsFiles;
	NSMutableArray *sectionsUrls;
	int sectionsViewModes[6];
	sqlite3_stmt *section_insert_statement;
	sqlite3_stmt *sections_get_statement;
	sqlite3_stmt *section2_get_statement;
	sqlite3 *database;

}

@property (nonatomic,retain) NSMutableArray *sections;

-(void) initDB;
-(void) saveSectionsToDb;
-(int) insertSectionDB:(Section*) sec parentID:(int)pid;
-(NSMutableArray*) loadSectionsFromDb;
-(NSMutableArray*) loadSectionsFromDb:(int) pid;
-(void) parseSections :(NSString*) name andUrl:(NSString*)zeurl andMode:(int)zemode;

@end
