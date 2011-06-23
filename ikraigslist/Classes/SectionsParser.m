//
//  SectionsParser.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 04/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SectionsParser.h"
#import "Section.h"
#import "DataManager.h"

#import <sqlite3.h>

#include <libxml/parser.h>
#include <libxml/tree.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>


@implementation SectionsParser

@synthesize sections;

-(id) init {
	if (self = [super init]) {
		sections = [[NSMutableArray alloc] init];
		/*
		sectionsNames = [[NSMutableArray alloc] init];
		sectionsFiles = [[NSMutableArray alloc] init];
		sectionsUrls = [[NSMutableArray alloc] init];
		//sectionsViewModes = int[6];
		
		[sectionsNames addObject:@"community"];
		[sectionsNames addObject:@"housing"];
		[sectionsNames addObject:@"for sale"];
		[sectionsNames addObject:@"services"];
		[sectionsNames addObject:@"jobs"];
		[sectionsNames addObject:@"gigs"];
		
		[sectionsFiles addObject:@"community"];
		[sectionsFiles addObject:@"housing"];
		[sectionsFiles addObject:@"forsale"];
		[sectionsFiles addObject:@"services"];
		[sectionsFiles addObject:@"jobs"];
		[sectionsFiles addObject:@"gigs"];
		
		[sectionsUrls addObject:@"ccc"];
		[sectionsUrls addObject:@"hhh"];
		[sectionsUrls addObject:@"sss"];
		[sectionsUrls addObject:@"bbb"];
		[sectionsUrls addObject:@"jjj"];
		[sectionsUrls addObject:@"ggg"];
		
		sectionsViewModes[0]=4;
		sectionsViewModes[1]=2;
		sectionsViewModes[2]=1;
		sectionsViewModes[3]=4;
		sectionsViewModes[4]=3;
		sectionsViewModes[5]=4;

		
		
			 
		 //pour chaque region contenue dans ces fichiers textes
		 NSString *tmp,*tmpname,*tmpurl;
		 int tmpmode;
		 for (int x=0; x<[sectionsFiles count];x++) {
			 tmp = [sectionsFiles objectAtIndex:x];
			 tmpname = [sectionsNames objectAtIndex:x];
			 tmpurl = [sectionsUrls objectAtIndex:x];
			 tmpmode = sectionsViewModes[x];
			 NSString *filePath = [[NSBundle mainBundle] pathForResource:tmp ofType:@"txt"];
			 if (filePath) {
				 NSString *myText = [NSString stringWithContentsOfFile:filePath];
				 if (myText) {
					 _docSections= htmlParseDoc([myText UTF8String],[@"UTF-8" UTF8String]);
					 
					 if (_docSections == NULL) {
						 NSLog(@"error: could not parse file\n");
						 return nil;
					 }
					 
					 
					 [self parseSections:tmpname andUrl:tmpurl andMode:tmpmode];
				 }
			 }
		 }
		 */
		 
		[self initDB];
		
		//[self saveSectionsToDb];
		
		self.sections = [self loadSectionsFromDb];
	}	
	return self;
}

-(void) initDB {
	NSString *bundleDir = [DataManager getBundleDirectory];
	NSString *dbPath = [bundleDir stringByAppendingPathComponent:@"sectionsdata.sqlite"];
	
	if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
		
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
		sqlite3_close(database);
		return;
	}
	
	const char *sql = "INSERT INTO sections (name,urlpart,parentId,hasSubsections,viewMode) VALUES (?,?,?,?,?)";
	if (sqlite3_prepare_v2(database, sql, -1, &section_insert_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		return;
	}
	
	const char *sql2 = "SELECT id,name,urlpart,viewMode FROM sections WHERE parentId=-1 ORDER BY id";
	if (sqlite3_prepare_v2(database, sql2, -1, &sections_get_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		return;
	}
	
	const char *sql3 = "SELECT id,name,urlpart,viewMode FROM sections WHERE parentId=? ORDER BY id";
	if (sqlite3_prepare_v2(database, sql3, -1, &section2_get_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		return ;
	}
	
	
	
}


- (void) saveSectionsToDb {
	
	int x,y=0;
	
	for (x=0;x<[sections count];x++) {
		Section* rtmp = [sections objectAtIndex:x];
		int rid=[self insertSectionDB:rtmp parentID:-1];
		
		NSArray *subsec = [rtmp subsections];
		for (y=0;y<[subsec count];y++) {
			Section* ltmp = [subsec objectAtIndex:y];
			[self insertSectionDB:ltmp parentID:rid];
		}
	}
}

-(int) insertSectionDB:(Section*) sec parentID:(int)pid {
	int lid=-1;
	
	sqlite3_bind_text(section_insert_statement,1,[[sec name] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(section_insert_statement,2,[[sec urlpart] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(section_insert_statement,3,pid);
	sqlite3_bind_int(section_insert_statement,4,[sec hasSubsections]);
	sqlite3_bind_int(section_insert_statement,5,[sec viewMode]);
	
	
	
	int success = sqlite3_step(section_insert_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(section_insert_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return NO;
	}
	
	lid = sqlite3_last_insert_rowid(database);
	
	return lid;
}

- (NSMutableArray*) loadSectionsFromDb {
	NSMutableArray *sec = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(sections_get_statement) == SQLITE_ROW) {
		
		int sid = sqlite3_column_int(sections_get_statement, 0);
		NSString *sname = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(sections_get_statement, 1)];
		NSString * surl = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(sections_get_statement, 2)];
		int viewm = sqlite3_column_int(sections_get_statement, 3);
		
		Section *s = [[Section alloc] initParentWithName:sname andUrl:surl];
		
		s.subsections = [self loadSectionsFromDb:sid];
		s.viewMode = viewm;
		
		[sec addObject:s];
		[s release];
	}
	
	
	// Reset the statement for future reuse.
	sqlite3_reset(sections_get_statement);	
	
	return sec;
	
}

-(NSMutableArray*) loadSectionsFromDb:(int) pid {
	NSMutableArray* secs = [[NSMutableArray alloc]init];
	
	sqlite3_bind_int(section2_get_statement, 1,pid);
		
	while (sqlite3_step(section2_get_statement) == SQLITE_ROW) {
		//int sid = sqlite3_column_int(section2_get_statement, 0);
		NSString * lname = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(section2_get_statement, 1)];
		NSString * lurl = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(section2_get_statement, 2)];
		int viewm = sqlite3_column_int(sections_get_statement, 3);
		
		Section *a = [[Section alloc] initWithName:lname andUrl:lurl];
		a.viewMode=viewm;
		
		[secs addObject:a];
	}
	
	sqlite3_reset(section2_get_statement);
	
	return secs;
}

//					 [self parseSections:tmpname andUrl:tmpurl andMode:tmpmode];


- (void) parseSections :(NSString*) name andUrl:(NSString*)zeurl andMode:(int)zemode {
	xmlNodeSetPtr nodes = NULL;
	xmlNodePtr root_element = NULL;
	xmlXPathContextPtr xpathCtx = NULL; 
    xmlXPathObjectPtr xpathObj = NULL; 
	xmlNodePtr cur = NULL;
	int size=0,i=0;
	
	Section *r = [[Section alloc] initParentWithName:name];
	r.viewMode =zemode;
	
	Section *rsub = [[Section alloc] initWithName:[name stringByAppendingString:@" (all)"] andUrl:zeurl];
	rsub.viewMode = zemode;
	
	NSMutableArray *subsections= [[NSMutableArray alloc] init];
	
	[subsections addObject:rsub];
	
	root_element = xmlDocGetRootElement(_docSections);
	
	xpathCtx = xmlXPathNewContext(_docSections);
    if(xpathCtx != NULL) {
		
		//parser et trouver chaque <a>
		xpathObj = xmlXPathEvalExpression("//a", xpathCtx);
		
		if (xpathObj == NULL) {
			xmlXPathFreeContext(xpathCtx);
			return;
		}
		
		nodes = xpathObj->nodesetval;
		
		size = (nodes) ? nodes->nodeNr : 0;
		
		if (size > 0) {
			for (i=0;i<size;i++) {
				if(nodes->nodeTab[i]->type == XML_ELEMENT_NODE) {
					cur = nodes->nodeTab[i];
					
					////pour chaque <a> créer une new location
					if( cur->properties->children->content && cur->children->content) {
						NSString * url = [NSString stringWithUTF8String:cur->properties->children->content];
						NSString * name = [NSString stringWithUTF8String:cur->children->content];
						
						
						if ([url characterAtIndex:0]  == '/') {
							url = [url substringFromIndex:1];
						}
						
						int len = [url length];
						if ([url characterAtIndex:len-1]=='/') {
							url = [url substringToIndex:len-1];
						}
						
						Section *tmp=[[Section alloc] initWithName:name andUrl:url];
						tmp.viewMode = zemode;
						
						[subsections addObject:tmp];
					}
						
						
					//NSLog(@"Finished Section : ");
					//NSLog(name);
				}
			}
		}
		
		xmlXPathFreeObject(xpathObj);
		xmlXPathFreeContext(xpathCtx);
	}
	
	
	
	
	r.subsections = subsections;
	
	[sections addObject:r];
	
}





@end
