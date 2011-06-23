//
//  RegionsParser.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 01/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RegionsParser.h"
#import "Region.h"
#import "Location.h"
#import "ConnectionManager.h"
#import "DataManager.h"

#import <sqlite3.h>

#include <libxml/parser.h>
#include <libxml/tree.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>
/*
#import "CFNetwork/CFNetwork.h"
#import "CFNetwork/CFHost.h"
*/

@implementation RegionsParser


@synthesize regions;

-(id) init {
	if (self = [super init]) {
		regions = [[NSMutableArray alloc] init];
	
		regionsNames = [[NSMutableArray alloc] init];
		regionsFiles = [[NSMutableArray alloc] init];
		/*
		
		[regionsFiles addObject:@"uscities"];
		[regionsFiles addObject:@"unitedstates"];
		[regionsFiles addObject:@"canada"];
		[regionsFiles addObject:@"cacities"];
		[regionsFiles addObject:@"aunz"];
		[regionsFiles addObject:@"asia"];
		[regionsFiles addObject:@"americas"];
		[regionsFiles addObject:@"europe"];
		[regionsFiles addObject:@"africa"];
		[regionsFiles addObject:@"intlcities"]; 
		
		[regionsNames addObject:@"US cities"];
		[regionsNames addObject:@"United States"];
		[regionsNames addObject:@"Canada"];
		[regionsNames addObject:@"CA cities"];
		[regionsNames addObject:@"Au / Nz"];
		[regionsNames addObject:@"Asia"];
		[regionsNames addObject:@"Americas"];
		[regionsNames addObject:@"Europe"];
		[regionsNames addObject:@"Africa"];
		[regionsNames addObject:@"Int'l cities"];
	
		//pour chaque region contenue dans ces fichiers textes
		NSString *tmp,*tmpname;
		for (int x=0; x<[regionsFiles count];x++) {
			tmp = [regionsFiles objectAtIndex:x];
			tmpname = [regionsNames objectAtIndex:x];
			NSString *filePath = [[NSBundle mainBundle] pathForResource:tmp ofType:@"txt"];
			if (filePath) {
				NSString *myText = [NSString stringWithContentsOfFile:filePath];
				if (myText) {
					_docRegions= htmlParseDoc([myText UTF8String],[@"UTF-8" UTF8String]);
					
					if (_docRegions == NULL) {
						NSLog(@"error: could not parse file\n");
						return nil;
					}
					
					
					[self parseRegions:tmpname];
				}
			}
		}
		
	
	/*	
	CFStringRef url = CFSTR("http://geo.craigslist.org/iso/be");
	CFHostRef host = CFHostCreateWithName(kCFAllocatorDefault,url);
		CFStreamError error;
	NSArray* add;
	Boolean hb;

	if (host && CFHostStartInfoResolution(host,kCFHostAddresses && kCFHostNames,&error)) {	
		add = (NSArray*)CFHostGetAddressing (host,&hb);	
	} else {
		NSLog(@"%s: CFHostStartInfoResolution() for host \"%@\" failed with error %i", __FUNCTION__, url, error.error);	
	}
		
		if (error.error != 0) {
			if (error.domain == kCFStreamErrorDomainPOSIX) {
				NSLog(@"POSIX error domain, CFSTream.h says error code is to be interpreted using sys/errno.h.");
			} else if (error.domain == kCFStreamErrorDomainMacOSStatus) {
				OSStatus macError = (OSStatus)error.error;
				NSLog(@"OS error: %d, CFStream.h says error code is to be interpreted using MacTypes.h.", macError);
			} else if (error.domain == kCFStreamErrorDomainHTTP) {
				NSLog(@"HTTP error domain, CFHTTPSteam.h says error code is the HTTP error code.");
			} else if (error.domain == kCFStreamErrorDomainMach) {
				NSLog(@"Mach error domain, CFNetServices.h says error code is to be interpreted using mach/error.h.");
			} else if (error.domain == kCFStreamErrorDomainNetDB) {
				NSLog(@"NetDB error domain, CFHTTPHost.h says error code is to be finterpreted using netdb.h.");
			} else if (error.domain == kCFStreamErrorDomainCustom) {
				NSLog(@"Custom error domain");
			} else if (error.domain == kCFStreamErrorDomainSystemConfiguration) {
				NSLog(@"System Configuration error domain, CFHost.h says error code is to be interpreted using SystemConfiguration/SystemConfiguration.h.");
			}
			NSLog(@"error %d domain %d", error.error, error.domain);
		}
	*/


		
		
	[self initDB];
	
		
	self.regions = [self loadRegionsFromDb];
	}	
	return self;
}


-(void) initDB {
	NSString *bundleDir = [DataManager getBundleDirectory];
	NSString *dbPath = [bundleDir stringByAppendingPathComponent:@"regionsdata.sqlite"];
	
	if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
		
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
		sqlite3_close(database);
		return;
	}
	
	const char *sql = "INSERT INTO regions (name) VALUES (?)";
	if (sqlite3_prepare_v2(database, sql, -1, &region_insert_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		return;
	}
	
	const char *sql2 = "SELECT id,name FROM regions ORDER BY id";
	if (sqlite3_prepare_v2(database, sql2, -1, &region_get_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		return;
	}
	
	const char *sql3 = "INSERT INTO locations (name,url,regionId,parentId,hasSublocations) VALUES (?,?,?,?,?)";
	if (sqlite3_prepare_v2(database, sql3, -1, &location_insert_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		return;
	}
	
	sqlLocGet = "SELECT id,name,url,hasSublocations FROM locations WHERE regionId=? AND parentId=? ORDER BY id";
	
	

}

- (void) saveRegionsToDb {
		
	int x,y=0;
	
	for (x=0;x<[regions count];x++) {
		Region* rtmp = [regions objectAtIndex:x];
		int rid=-1;
		
		sqlite3_bind_text(region_insert_statement,1,[[rtmp name] UTF8String], -1, SQLITE_TRANSIENT);
			
		int success = sqlite3_step(region_insert_statement);
		// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
		sqlite3_reset(region_insert_statement);
		if (success != SQLITE_DONE) {
			NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
			return;
		} 
		
		//get insert id
		rid = sqlite3_last_insert_rowid(database);
		//get locations
		NSArray *locations = [rtmp locations];
		for (y=0;y<[locations count];y++) {
			Location* ltmp = (Location*)[locations objectAtIndex:y];
			[self insertLocationDB:ltmp regionID:rid parentID:-1];
		}
	}
}

-(void) insertLocationDB:(Location*) loc regionID:(int)rid parentID:(int)pid {
	int z=0;
	int lid=-1;
	
	sqlite3_bind_text(location_insert_statement,1,[[loc name] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(location_insert_statement,2,[[loc url] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(location_insert_statement,3,rid);
	sqlite3_bind_int(location_insert_statement,4,pid);
	sqlite3_bind_int(location_insert_statement,5,[loc hasSublocations]);
	
	
	int success = sqlite3_step(location_insert_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(location_insert_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return;
	}
	
	lid = sqlite3_last_insert_rowid(database);
	
	if ([loc hasSublocations]) {
		NSArray *subloc= [loc sublocations];
		
		
		for (z=0;z<[subloc count];z++) {
			Location* stmp = [subloc objectAtIndex:z];
			
			[self insertLocationDB:stmp regionID:rid parentID:lid];			
			
		}
	}	
}

- (NSMutableArray*) loadRegionsFromDb {
	NSMutableArray *reg = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(region_get_statement) == SQLITE_ROW) {
		int rid = sqlite3_column_int(region_get_statement, 0);
		//NSLog([NSString stringWithUTF8String:(char *)sqlite3_column_text(region_get_statement, 1)]);
		NSString *rname = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(region_get_statement, 1)];
		Region *r = [[Region alloc] initWithName:rname];
		
		r.locations = [self loadLocationsFromDb:rid parentID:-1];
		
		[reg addObject:r];
		[r release];
	}
	
	
	// Reset the statement for future reuse.
	sqlite3_reset(region_get_statement);	
	
	return reg;
	
}
		
-(NSMutableArray*) loadLocationsFromDb:(int) rid parentID:(int)pid {
	NSMutableArray* locations = [[NSMutableArray alloc]init];
	
	sqlite3_stmt *location_get_statement;
	
	if (sqlite3_prepare_v2(database, sqlLocGet, -1, &location_get_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		return locations;
	}
			
	sqlite3_bind_int(location_get_statement, 1,rid);
	sqlite3_bind_int(location_get_statement, 2,pid);
			
	while (sqlite3_step(location_get_statement) == SQLITE_ROW) {
		int lid = sqlite3_column_int(location_get_statement, 0);
		NSString * lname = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(location_get_statement, 1)];
		NSString * lurl = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(location_get_statement, 2)];
		BOOL lhassub = sqlite3_column_int(location_get_statement, 3);
		
		Location *a; 
		if (lhassub) {
			a = [[Location alloc] initParentWithName:lname andUrl:lurl];
			a.sublocations = [self loadLocationsFromDb:rid parentID:lid];
		} else {
			a = [[Location alloc] initWithName:lname andUrl:lurl];
		}
		[locations addObject:a];
	}
			
	sqlite3_finalize(location_get_statement);
			
	return locations;
}
		
		

- (void) parseRegions :(NSString*) name {
	xmlNodeSetPtr nodes = NULL;
	xmlNodePtr root_element = NULL;
	xmlXPathContextPtr xpathCtx = NULL; 
    xmlXPathObjectPtr xpathObj = NULL; 
	xmlNodePtr cur = NULL;
	int size=0,i=0;
	
	Region *r = [[Region alloc] initWithName:name];
	NSMutableArray *locations = [[NSMutableArray alloc] init];

	
	root_element = xmlDocGetRootElement(_docRegions);
	
	xpathCtx = xmlXPathNewContext(_docRegions);
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
						
						if (![name isEqual:@"more .."]) {		
						
							NSString* prefix = @"http://geo.craigslist.org";
									
							Location *tmp=nil;
							//si addresse de type geo.craigslist : 
							if ([url hasPrefix:prefix] && url.length  > prefix.length ) {
								tmp = [self parseGeoAdress:url andName:name];
							} else { //sinon (addresse type directe)
								tmp = [self handleLocation:(NSString*)name andUrl:(NSString*)url];
							}
							
							if (tmp!=nil) {
								[locations addObject:tmp];
							}
							
						}
						
						
						//NSLog(@"Finished Location : ");
						//NSLog(name);
					}
				}
			}
		}
		
		xmlXPathFreeObject(xpathObj);
		xmlXPathFreeContext(xpathCtx);
	}
	
	

	
	r.locations =  locations;
	[regions addObject:r];
	
}


- (Location *) parseGeoAdress : (NSString*) address andName:(NSString*) name {
    xmlNodePtr root_element = NULL;
	xmlXPathContextPtr xpathCtx; 
    xmlXPathObjectPtr xpathObj; 
	
	//nouvelle location comme "parente" adresse nil
	Location* ret = [[Location alloc] initParentWithName:name];
	NSMutableArray* sublocations = [[NSMutableArray alloc] init];
	
	//télécharger la page
	NSURL* url = [[NSURL alloc] initWithString:address];
	
	ConnectionManager *cm = [[ConnectionManager alloc] init];
	
	NSString *content2 = [cm getStringFromUrl:url];
	
	[cm release];
	
	//parser tous les <a> avec craigslist dedans
	
	_docGeo = htmlParseDoc([content2 UTF8String],[@"UTF-8" UTF8String]);
	
	if (_docGeo == NULL) {
        NSLog(@"error: could not parse file\n");
		return nil;
    }
	
	root_element = xmlDocGetRootElement(_docGeo);
	
	xpathCtx = xmlXPathNewContext(_docGeo);
    if(xpathCtx != NULL) {
		
		xpathObj = xmlXPathEvalExpression("/html/body/blockquote/blockquote/blockquote/blockquote/div/a", xpathCtx);
		
		if (xpathObj == NULL) {
			xmlXPathFreeContext(xpathCtx);
			return nil;
		}
		
		xmlNodeSetPtr nodes = xpathObj->nodesetval;
		xmlNodePtr cur;
		int size,i;
		
		
		size = (nodes) ? nodes->nodeNr : 0;
		
						
		//pour chaque <a> traiter (addresse type directe)
		for (i=0;i<size;i++) {
			if(nodes->nodeTab[i]->type == XML_ELEMENT_NODE) {
				cur = nodes->nodeTab[i];
				
				////pour chaque <a> créer une new location
				if( cur->properties->children->content && cur->children->content) {
					NSString * url = [NSString stringWithUTF8String:cur->properties->children->content];
					NSString * name = [NSString stringWithUTF8String:cur->children->content];
					
					Location *sl = [self handleLocation:(NSString*)name andUrl:(NSString*)url];
					[sublocations addObject:sl];
					
				}
			}
		}
		
			
		if ([sublocations count] == 0) {
			NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:address]];
			NSURLResponse *resp = nil;
			NSError *err = nil;
			[NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
			NSString* realAddress = ([[resp URL] absoluteString]);
			
			ret.url = realAddress;
			ret.hasSublocations = NO;
			ret.sublocations = nil;
		} else {
			ret.sublocations = sublocations;
		}	
		
		xmlXPathFreeObject(xpathObj);
		
	}
	
	xmlXPathFreeContext(xpathCtx);
	
	return ret;
}
	
-(Location*) handleLocation:(NSString*)thename andUrl:(NSString*)theurl {
    xmlNodePtr root_element = NULL;
	xmlXPathContextPtr xpathCtx; 
    xmlXPathObjectPtr xpathObj; 
	
	//télécharger la page
	ConnectionManager *cm = [[ConnectionManager alloc] init];
	NSString *content = [cm getStringFromString:theurl];
	[cm release];
	
	
	
	//parser tous les <a> avec craigslist dedans
	
	_docLocation = htmlParseDoc([content UTF8String],[@"UTF-8" UTF8String]);
	[content release];
	if (_docLocation == NULL) {
        NSLog(@"error: could not parse file\n");
		return nil;
    }
	
	root_element = xmlDocGetRootElement(_docLocation);
	
	xpathCtx = xmlXPathNewContext(_docLocation);
    if(xpathCtx != NULL) {
		
		//on cherche si des sous parties au site
		xpathObj = xmlXPathEvalExpression("//span[@class='for']/a", xpathCtx);
		
		if (xpathObj == NULL) {
			xmlXPathFreeContext(xpathCtx);
			return nil;
		}
		
		xmlNodeSetPtr nodes = xpathObj->nodesetval;
		xmlNodePtr cur;
		int size,i;
		
		size = (nodes) ? nodes->nodeNr : 0;
		
		//pour chaque <a> traiter (addresse type directe)
		if (size > 0) {
			
			//nouvelle location comme "parente" adresse nil
			Location* ret = [[Location alloc] initParentWithName:thename];
			NSMutableArray* sublocations = [[NSMutableArray alloc] init];
			
			//creer une location avec nom du site parent et (all)
			Location *first = [[Location alloc]initWithName:[thename stringByAppendingString:@" (all)"] andUrl:theurl];
			[sublocations addObject:first];
			
			//pour tous les sous locations
			for (i=0;i<size;i++) {
				if(nodes->nodeTab[i]->type == XML_ELEMENT_NODE) {
					cur = nodes->nodeTab[i];
					
					////pour chaque <a> créer une new location
					if( cur->properties->children->content && cur->children->content) {
						NSString * url = [NSString stringWithUTF8String:cur->properties->children->content];
						//NSString * name = [NSString stringWithUTF8String:cur->children->content];
						
						//parser tous les <a> dedans loader page et créer une location finale avec nom et addresse

						Location *sl = [self handleFinalLocation:[theurl stringByAppendingString:[url substringFromIndex:1]]];
						[sublocations addObject:sl];
					}
				}
			}
			
			ret.sublocations = sublocations; 
			xmlXPathFreeObject(xpathObj);
			xmlXPathFreeContext(xpathCtx);
			return ret;

			
		} else { // il n'y a pas de sous locations sur la meme page donc traiter comme finale
			Location *sl =[[Location alloc] initWithName:thename andUrl:theurl];
			xmlXPathFreeObject(xpathObj);
			xmlXPathFreeContext(xpathCtx);
			return sl;
		}

	}
	xmlXPathFreeContext(xpathCtx);		
	return nil;
}

-(Location*) handleFinalLocation:(NSString*)theurl {
	xmlNodePtr root_element = NULL;
	xmlXPathContextPtr xpathCtx; 
    xmlXPathObjectPtr xpathObj; 
	
	Location *ret = [[Location alloc] initWithName:@"nil" andUrl:theurl];;
	
	
	//télécharger la page
	ConnectionManager *cm = [[ConnectionManager alloc] init];
	NSString *content3 = [cm getStringFromString:theurl];
	[cm release];
	
	
	_docFinal = htmlParseDoc([content3 UTF8String],[@"UTF-8" UTF8String]);
	[content3 release];
	if (_docFinal == NULL) {
        NSLog(@"error: could not parse file\n");
		return nil;
    }
	
	root_element = xmlDocGetRootElement(_docFinal);
	
	xpathCtx = xmlXPathNewContext(_docFinal);
    if(xpathCtx != NULL) {
		
		//on cherche si des sous parties au site
		xpathObj = xmlXPathEvalExpression("//h2", xpathCtx);
		
		if (xpathObj == NULL) {
			xmlXPathFreeContext(xpathCtx);
			return nil;
		}
		
		xmlNodeSetPtr nodes = xpathObj->nodesetval;
		xmlNodePtr cur;
		int size;
		
		size = (nodes) ? nodes->nodeNr : 0;
		
		//pour chaque <a> traiter (addresse type directe)
		if (size >= 1) {
			if(nodes->nodeTab[0]->type == XML_ELEMENT_NODE) {
				cur = nodes->nodeTab[0];
				if (cur->children->content) {
					NSString * sname = [NSString stringWithUTF8String:cur->children->content];
					ret.name = sname;

					
				}
			}
		} else{
			//problem
			ret = nil;
		} 
		xmlXPathFreeObject(xpathObj);	
	}

	xmlXPathFreeContext(xpathCtx);
	return ret;
}

@end
