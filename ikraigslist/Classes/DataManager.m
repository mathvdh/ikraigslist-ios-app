//
//  DataManager.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "CraigDetailedItem.h"
#import "BookMark.h"
#import "QueryParams.h"
#import <sqlite3.h>
#import "Manager.h"
#import "Region.h"
#import "RegionsParser.h"
#import "Section.h"
#import "SectionsParser.h"

static NSMutableArray *sections;

static NSMutableArray *regions;
static NSArray *jobsOpts;
static NSArray *jobsUrlOpts;


static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *get_statement = nil;
static sqlite3_stmt *update_statement = nil;
static sqlite3_stmt *drop_statement = nil;

static sqlite3_stmt *bookmark_insert_statement = nil;
static sqlite3_stmt *bookmark_delete_statement = nil;
static sqlite3_stmt *bookmark_drop_statement = nil;
static sqlite3_stmt *bookmark_get_statement = nil;
static sqlite3_stmt *bookmark_get_one_statement=nil;

static sqlite3_stmt *query_insert_statement = nil;
static sqlite3_stmt *query_delete_statement = nil;
static sqlite3_stmt *query_drop_statement = nil;
static sqlite3_stmt *query_get_statement = nil;
static sqlite3_stmt *query_get_one_statement=nil;


static sqlite3 *database = nil;

static  NSArray *paths;
static NSString *documentsDirectory;
static NSString *mytempDirectory;

static NSString *loadingHtml;

static RegionsParser* rp;
static SectionsParser* sp;


@interface DataManager()

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (NSString*) newUUID;
+ (NSString*) writeImageTemp:(UIImage*) theImage;
+ (void)checkTempDir;

@end



@implementation DataManager

+ (void) initialize {
	[DataManager createEditableCopyOfDatabaseIfNeeded];
	
	rp = [[RegionsParser alloc] init];
	sp = [[SectionsParser alloc] init];
	
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [[paths objectAtIndex:0] retain];
	mytempDirectory = [documentsDirectory stringByAppendingPathComponent:@"temp"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"icraigslist_userdata.sqlite"];
	
	loadingHtml = @"<html><head></head><body><br/><div style=\"font-family:serif;text-align:center;font-size:60px;color:purple\"> ikraigslist </div> <div style=\"font-family:arial,sans-serif;text-align:center;font-size:50px;\"><br/><br/><div style=\"font-size:80px;font-weight:bolder;\">Loading</div><br/>please wait ... <br/><br/> <img src=\"loading.gif\" width=\"100\"> </img></div> </body></html>";
	
	[self checkTempDir];
	
	
	//opening db
	if (sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
		
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
		sqlite3_close(database);
	}
	
	//preparing the statements for params
	const char *sql = "SELECT value FROM params WHERE key=?";
	if (sqlite3_prepare_v2(database, sql, -1, &get_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql2 = "INSERT INTO params (key,value) VALUES (?,?)";
	if (sqlite3_prepare_v2(database, sql2, -1, &insert_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql3 = "UPDATE params SET value=? WHERE key=?";
	if (sqlite3_prepare_v2(database, sql3, -1, &update_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql31 = "DELETE FROM params WHERE 1";
	if (sqlite3_prepare_v2(database, sql31, -1, &drop_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	//bookmarks
	const char *sql4 = "INSERT INTO bookmarks (name,htmlContent,bodyContent,directLink,date,location,emailLink,mapLink,images,title) VALUES (?,?,?,?,?,?,?,?,?,?)";
	if (sqlite3_prepare_v2(database, sql4, -1, &bookmark_insert_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql5 = "DELETE FROM bookmarks WHERE id = ?";
	if (sqlite3_prepare_v2(database, sql5, -1, &bookmark_delete_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql6 = "DELETE FROM bookmarks WHERE 1";
	if (sqlite3_prepare_v2(database, sql6, -1, &bookmark_drop_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql7 = "SELECT * FROM bookmarks ORDER BY id";
	if (sqlite3_prepare_v2(database, sql7, -1, &bookmark_get_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql8 = "SELECT * FROM bookmarks WHERE id = ?";
	if (sqlite3_prepare_v2(database, sql8, -1, &bookmark_get_one_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	//queries
	const char *sql9 = "INSERT INTO queries (name,queryString) VALUES (?,?)";
	if (sqlite3_prepare_v2(database, sql9, -1, &query_insert_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql10 = "DELETE FROM queries WHERE id = ?";
	if (sqlite3_prepare_v2(database, sql10, -1, &query_delete_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql11 = "DELETE FROM queries WHERE 1";
	if (sqlite3_prepare_v2(database, sql11, -1, &query_drop_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql12 = "SELECT * FROM queries ORDER BY id";
	if (sqlite3_prepare_v2(database, sql12, -1, &query_get_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	const char *sql13 = "SELECT * FROM queries WHERE id = ?";
	if (sqlite3_prepare_v2(database, sql13, -1, &query_get_one_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	regions = rp.regions;
	sections = sp.sections;

	
	
	jobsOpts = [[NSArray arrayWithObjects:
					  @"telecommute", @"contract", @"internship", @"part-time", @"non-profit",
					  nil] retain];

	jobsUrlOpts = [[NSArray arrayWithObjects:
				 @"&addOne=telecommuting", @"&addTwo=contract", @"&addThree=internship", @"&addFour=part-time", @"&addFive=non-profit",
				 nil] retain];
	
	
	
}

+ (void)checkTempDir {
	NSFileManager* manager = [NSFileManager defaultManager];
	BOOL success;
	success = [manager fileExistsAtPath:mytempDirectory];
    
	if (success) { //empty this directory
		#if ! defined(TARGET_IPHONE_SIMULATOR)
		
		NSArray* fileList = [manager contentsOfDirectoryAtPath:mytempDirectory error:nil];
		for (NSString *file in fileList)
		{
			[manager removeItemAtPath:[mytempDirectory stringByAppendingPathComponent:file] error:nil];
		}
		
		#endif

	} else { //create it
		[manager createDirectoryAtPath:mytempDirectory attributes:nil];
	}
}


+ (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"icraigslist_userdata.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"userdata.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


+ (NSString*) getValueForKey:(NSString*)thekey {
	NSString *answer;
	
//	NSLog(@"%s",[thekey UTF8String]);
	
	sqlite3_bind_text(get_statement, 1, [thekey UTF8String], -1, SQLITE_TRANSIENT);
	if (sqlite3_step(get_statement) == SQLITE_ROW) {
		//answer = [NSString stringWithUTF8String:(char *)sqlite3_column_text(get_statement, 0)];
		answer = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(get_statement, 0)];
	} else {
		NSLog(@"not found : %s", sqlite3_errmsg(database));
		answer=nil;
	}
	// Reset the statement for future reuse.
	sqlite3_reset(get_statement);
		
	return answer;
}

+ (BOOL) setValue:(NSString*) value forKey:(NSString*)thekey {

//	NSLog(@"%s",[thekey UTF8String]);
//	NSLog(@"%s",[value UTF8String]);
	
	NSString* val = [DataManager getValueForKey:thekey];
	
	
	if (val == nil) {
		sqlite3_bind_text(insert_statement, 1, [thekey UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(insert_statement, 2, [value UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(insert_statement);
		// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
		sqlite3_reset(insert_statement);
		if (success != SQLITE_DONE) {
			NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
			return NO;
		} else {
			return YES;
		}
		
	} else {
		sqlite3_bind_text(update_statement, 1, [value UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(update_statement, 2, [thekey UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(update_statement);
		// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
		sqlite3_reset(update_statement);
		if (success != SQLITE_DONE) {
			NSLog(@"Error: failed to update '%s'.", sqlite3_errmsg(database));
			return NO;
		} else {
			return YES;
		}
		
	}
}

+ (void) closeDB {
	if (insert_statement) {
        sqlite3_finalize(insert_statement);
        insert_statement = nil;
    }
    if (get_statement) {
        sqlite3_finalize(get_statement);
        get_statement = nil;
    }
    if (update_statement) {
        sqlite3_finalize(update_statement);
        update_statement = nil;
    }	
	if (database) {
		sqlite3_close(database);
	}
}


+ (Region*) getRegion:(NSInteger)index {
	return [regions objectAtIndex:index];
}

+ (NSInteger) getRegionsCount {
	return [regions count];
}

+ (NSArray*) getSections {
	return sections;
}



+ (BOOL) dropAllParams {
	
	//dropping saved params from DB
	int success = sqlite3_step(drop_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(drop_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return NO;
	} 
	
	
	//dropping saved bookmarks
	success = sqlite3_step(bookmark_drop_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(bookmark_drop_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return NO;
	} 
	
	
	//should erase saved searchs also here
	
	success = sqlite3_step(query_drop_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(query_drop_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return NO;
	} 
	
	
	//ici effacer tous les params query aussi
	[Manager reinitparams];
	
	return YES;
}

+ (BOOL) dropBookmarks {
	int success = sqlite3_step(bookmark_drop_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(bookmark_drop_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return NO;
	} else {
		[[Manager getBookmarks] reload];
		return YES;
	}
}

+ (NSMutableArray*) getBookmarks {
	
	NSMutableArray *books = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(bookmark_get_statement) == SQLITE_ROW) {
		NSString* tmp;
		CraigSimpleItem *it = [[CraigSimpleItem alloc] init];
		
		tmp =  [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 10)];
		it.title = tmp;
		[tmp release];
		
		tmp =  [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 5)] ;
		it.date =  tmp;
		[tmp release];
	
		if ((char *)sqlite3_column_text(bookmark_get_statement, 6) != NULL) {
			tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 6)] ;
			it.location = tmp;
			[tmp release];
		}

		tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 4)] ;
		it.directlink = tmp;
		[tmp release];
		
		it.hasPics =  NO;
		
		CraigDetailedItem *ditem = [[CraigDetailedItem alloc] initWithBase:it];
		
		tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 3)];
		ditem.bodyContent = tmp;
		[tmp release];
		
		tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 2)];
		ditem.htmlContent = tmp;
		[tmp release];
		
		if ((char *)sqlite3_column_text(bookmark_get_statement, 8) != NULL) {
			tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 8)];
			ditem.mapLink=tmp;
			[tmp release];
		}
		
		if ((char *)sqlite3_column_text(bookmark_get_statement, 7) != NULL) {
			tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 7)] ;
			ditem.emailLink=tmp;
			[tmp release];
		}
		
		
		BookMark *bookm = [[BookMark alloc] initWithItem:ditem];
		
		bookm.bookId =  sqlite3_column_int(bookmark_get_statement, 0);
		
		if ((char *)sqlite3_column_text(bookmark_get_statement, 9) != NULL) {
			tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 9)];
			bookm.picturesString = tmp ;
			[tmp release];
		}

		tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(bookmark_get_statement, 1)] ;
		bookm.name=  tmp;
		[tmp release];
		
		//NSLog(@"---%@",bookm.name);
		
		[books addObject:bookm];
		
		[it release];
		[ditem release];
		[bookm release];
	}
	
	
	// Reset the statement for future reuse.

	sqlite3_reset(bookmark_get_statement);	
	
	return books;
}



+ (BOOL) saveBookmark:(BookMark*)book {
	//save all the images and keep the names in an array
	NSString *imagesSerial = [[NSString alloc] initWithString:@""];

	CraigDetailedItem *item = book.savedItem;
	NSArray *images = item.images;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	int cnt=0;
	
	if ( [images count] > 0 ) {
		for ( UIImage *im in images) {
			
			NSString* iname = [item.imagesUrls objectAtIndex:cnt];
			NSString* from = [[self getTempDirectory] stringByAppendingPathComponent:iname];			
			NSString* to = [[self getDocumentDirectory] stringByAppendingPathComponent:iname];
			
			[fileManager copyItemAtPath:from toPath:to error:nil];
			
			cnt++;
			
			if (iname!=nil) {
				
				if (im == [images lastObject]) {
					imagesSerial = [imagesSerial stringByAppendingString:iname];
				} else {
					imagesSerial = [imagesSerial stringByAppendingFormat:@"%@||",iname];
				}
			}
		}
	}
				
	//NSLog(@"****%@",imagesSerial);
	
	sqlite3_bind_text(bookmark_insert_statement, 1, [[book name] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 2, [[item htmlContent] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 3, [[item bodyContent] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 4, [[[item baseItem] directlink] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 5, [[[item baseItem] date] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 6, [[[item baseItem] location] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 7, [[item emailLink] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 8, [[item mapLink] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 9, [imagesSerial UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(bookmark_insert_statement, 10, [[[item baseItem] title] UTF8String], -1, SQLITE_TRANSIENT);
	
	
	int success = sqlite3_step(bookmark_insert_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(bookmark_insert_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return NO;
	} else {
		return YES;
	}
	
				
}
				
+ (BOOL) deleteBookmark:(BookMark*)book {
	if ([book bookId] !=0) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		sqlite3_bind_int(bookmark_delete_statement,1,[book bookId]);
		
		int success = sqlite3_step(bookmark_delete_statement);
		// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
		sqlite3_reset(bookmark_delete_statement);
		if (success != SQLITE_DONE) {
			NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
			return NO;
		} 
		
		
		if ([book picturesString] != nil && [[book picturesString] length] >0) {
			NSArray *filenames =  [[book picturesString] componentsSeparatedByString:@"||"];
			for (NSString* filename in filenames) {
				NSString *thePath = [documentsDirectory stringByAppendingPathComponent:filename];
				[fileManager removeItemAtPath:thePath error:nil];
			}
		}
		return YES;
	}
	

	return NO;
}



+ (NSMutableArray*) getSavedQueries {
	NSMutableArray *queries = [[NSMutableArray alloc] init];
	
	while (sqlite3_step(query_get_statement) == SQLITE_ROW) {
		NSString* tmp;
		
		QueryParams *it = [[QueryParams alloc] initEmpty];
		
		it.sqid =  sqlite3_column_int(query_get_statement, 0);
		
		tmp = [[NSString alloc ] initWithUTF8String:(char *)sqlite3_column_text(query_get_statement, 1)];
		it.name= tmp;
		[tmp release];
		
		tmp = [[NSString alloc ] initWithUTF8String:(char*)sqlite3_column_text(query_get_statement, 2)];
		[it setFromSavedQueryString:tmp];
		[tmp release];
		
		[queries addObject:it];
		[it release];
	}
	
	
	// Reset the statement for future reuse.
	sqlite3_reset(query_get_statement);	
	
	return queries;
	
}

+ (BOOL) dropSavedQueries {
	//delete all the queries
	int success = sqlite3_step(query_drop_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(query_drop_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return NO;
	} else {
		[[Manager getSavedQueries] reload];
		return YES;
	}
}

+ (BOOL) saveQuery:(QueryParams*) params {
	//here we can get the query as a string
	//then save it to db
	
	NSString* tmp = [params getAsSavedQueryString];
	
	sqlite3_bind_text(query_insert_statement, 1, [[params name] UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(query_insert_statement, 2, [tmp UTF8String], -1, SQLITE_TRANSIENT);
		
	int success = sqlite3_step(query_insert_statement);
	// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
	sqlite3_reset(query_insert_statement);
	if (success != SQLITE_DONE) {
		NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
		return NO;
	} else {
		return YES;
	}
	
	
}

+ (BOOL) deleteSavedQuery: (QueryParams*) query {
	//delete the query
	if ([query sqid] > 0) {
		
		sqlite3_bind_int(query_delete_statement,1,[query sqid]);
		
		int success = sqlite3_step(query_delete_statement);
		// Because we want to reuse the statement, we "reset" it instead of "finalizing" it.
		sqlite3_reset(query_delete_statement);
		if (success != SQLITE_DONE) {
			NSLog(@"Error: failed to insert '%s'.", sqlite3_errmsg(database));
			return NO;
		} 

		return YES;
	}
	
	
	return NO;
}


+ (UIImage*) loadImage:(NSString*) filename {
	NSString *thePath = [documentsDirectory stringByAppendingPathComponent:filename];
	UIImage *theImage = [UIImage imageWithContentsOfFile:thePath];
	
	return theImage;
}

/*
+ (NSString*) writeImage:(UIImage*) theImage {
   	NSString *imageName = [DataManager newUUID];
	imageName = [imageName stringByAppendingString: @".jpg"];
    NSString *thePath = [documentsDirectory stringByAppendingPathComponent:imageName];
	
	NSData *theImageData = UIImageJPEGRepresentation(theImage, 1.0f);
	
	if (theImageData!=nil) {
		[theImageData writeToFile:thePath atomically:YES];
		return imageName;
	} else {
		return nil;
	}
}
*/

+ (NSString*) writeImageTemp:(UIImage*) theImage {
	NSString * tempD = [self getTempDirectory];
	
   	NSString *imageName = [DataManager newUUID];
	imageName = [imageName stringByAppendingString: @".jpg"];
    NSString *thePath = [tempD stringByAppendingPathComponent:imageName];
	
	NSData *theImageData = UIImageJPEGRepresentation(theImage, 1.0f);
	
	if (theImageData!=nil) {
		[theImageData writeToFile:thePath atomically:YES];
		return imageName;
	} else {
		return nil;
	}
}

+ (NSString*) newUUID {
	CFUUIDRef     myUUID = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef   myUUIDString=CFUUIDCreateString(kCFAllocatorDefault, myUUID);
	CFRelease(myUUID);
	return [(NSString *)myUUIDString autorelease];
}

+ (void) deleteImage: (NSString*) theName {
	NSString *thePath = [documentsDirectory stringByAppendingPathComponent:theName];
	[[NSFileManager defaultManager] removeItemAtPath:thePath error:nil];
}


+(NSArray*) getJobsOptionsArray {
	return jobsOpts;
}

+(NSArray*) getJobsUrlOptions {
	return jobsUrlOpts;
}

+(NSString*) getDocumentDirectory {
	return documentsDirectory;
}

+(NSString*) getTempDirectory {
	return [documentsDirectory stringByAppendingPathComponent:@"temp"];
}

+(NSString*) getLoadingHtml {
	return loadingHtml;
}

+(NSString*) getBundleDirectory {
	return [[NSBundle mainBundle] resourcePath];
}


@end
