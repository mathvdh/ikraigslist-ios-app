//
//  ViewManager.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 14/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.


#import "Manager.h"
#import "ListViewController.h"
#import "BookmarksViewController.h"
#import "PreferencesViewController.h"
#import "HomeViewController.h"
#import "DetailViewController.h"
#import "ListSectionsViewController.h"
#import "QueryParams.h"
#import "MasterViewController.h"
#import "ListLocationsViewController.h"
#import "ListRegionsViewController.h"
#import "DataManager.h"
#import "AppParams.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "SavedQueryViewController.h"
#import "HelpViewController.h"


static BookmarksViewController *bookmarksVC;
static UINavigationController *bookmarksNavVC;
static HomeViewController *homeVC;
static UINavigationController *homeNavVC;
static UINavigationController *prefNavVC;
static PreferencesViewController *prefVC;
static DetailViewController *detailVC;
static DetailViewController *detailVC2;
static ListViewController *listVC;
static MasterViewController *mainVC;
static QueryParams *params;
static AppParams *appparams;
static ListSectionsViewController *sectionsVC;
static ImageGalleryController *detailImgVC;
static ImageGalleryController *detailImgVC2;
static JobsOptionViewController * jobsOptionVC;
static HelpViewController *helpVC;

static ListRegionsViewController *listRegionsVC;
static UINavigationController *queriesNavVC;
static SavedQueryViewController *savedQueryVC;
static BOOL _isDataSourceAvailable;

@interface Manager()
	+ (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags;

@end





@implementation Manager

+ (void) initialize {
	params = [[QueryParams alloc] init];
	appparams = [[AppParams alloc] init];
	homeVC = [[HomeViewController alloc] initWithNibName:@"Home" bundle:nil];
	homeNavVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
	bookmarksVC = [[BookmarksViewController alloc] initWithStyle:UITableViewStylePlain ];
	bookmarksNavVC = [[UINavigationController alloc] initWithRootViewController:bookmarksVC];
	savedQueryVC = [[SavedQueryViewController alloc] initWithStyle:UITableViewStylePlain ];
	queriesNavVC = [[UINavigationController alloc] initWithRootViewController:savedQueryVC];
	prefVC = [[PreferencesViewController alloc] initWithNibName:@"Preferences" bundle:nil];
	prefNavVC = [[UINavigationController alloc] initWithRootViewController:prefVC];
	listVC = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	sectionsVC = [[ListSectionsViewController alloc]  initWithStyle:UITableViewStylePlain title:@"Choose section"];
	sectionsVC.sections = [ DataManager getSections];
	detailVC = [[DetailViewController alloc] initWithNibName:@"Detail" bundle:nil number:1 withSaveButton:YES];
	detailVC2 = [[DetailViewController alloc] initWithNibName:@"Detail" bundle:nil number:2 withSaveButton:NO];
	helpVC = [[HelpViewController alloc] initWithNibName:nil bundle:nil];
	
	jobsOptionVC = [[JobsOptionViewController alloc] initWithStyle:UITableViewStylePlain ];
	
	mainVC = [[MasterViewController alloc] initWithNibName:nil bundle:nil];
	detailImgVC = [[ImageGalleryController alloc] initWithNibName:nil bundle:nil];
	detailImgVC2 = [[ImageGalleryController alloc] initWithNibName:nil bundle:nil];
	
	listRegionsVC = [[ListRegionsViewController alloc] initWithStyle:UITableViewStylePlain];
	
	_isDataSourceAvailable = NO;
	
}

+ (void) reinitparams {
	[params release];
	[appparams release];
	
	params = [[QueryParams alloc] init];
	appparams = [[AppParams alloc] init];
	
	[prefVC restoreFromParams];
	[homeVC restoreFromParams];
	[bookmarksVC reload];
	[jobsOptionVC reload];
	[savedQueryVC reload];
	
	//saved search restore from params


}



+ (MasterViewController *) getMain {
	return mainVC;
}

+ (HomeViewController *) getHome {
	return homeVC;
}

+ (UINavigationController *) getHomeNav {
	return homeNavVC;
}

+ (UINavigationController *) getBookmarksNav {
	return bookmarksNavVC;
}

+ (UINavigationController *) getQueriesNav {
	return queriesNavVC;
}

+ (BookmarksViewController *) getBookmarks {
	return bookmarksVC;
}

+ (JobsOptionViewController *) getJobsOptions {
	return jobsOptionVC;
}

+ (SavedQueryViewController *) getSavedQueries {
	return savedQueryVC;
}

+ (PreferencesViewController *) getPref {
	return prefVC;
}

+ (void) setQueryParams:(QueryParams*) newparams {
	if (params != nil) {
		[params release];
	}
	params = [newparams retain];
	//params = newparams;
}

+ (QueryParams *) queryParams {
	return params;
}

+ (AppParams *) appParams {
	return appparams;
}

+ (ListViewController*)  getList {
	return listVC;
}

+ (ListSectionsViewController*) getSection {
	return sectionsVC;
}

+ (DetailViewController*) getDetail {
	return detailVC;
}

+ (DetailViewController*) getDetail2 {
	return detailVC2;
}

+ (ImageGalleryController*) getImagesDetail {
	return detailImgVC;	
}

+ (ImageGalleryController*) getImagesDetail2 {
	return detailImgVC2;	
}

+ (UINavigationController *) getPrefNav {
	return prefNavVC;
}
+ (ListRegionsViewController*) getListRegions {
	return listRegionsVC;
}

+ (HelpViewController*) getHelp {
	return helpVC;
}


+ (BOOL)isDataSourceAvailable
{
	static BOOL checkNetwork = YES;
	if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
        checkNetwork = NO;
	
		NSString * host = @"craigslist.org";
		if (!host || ![host length]) {
			_isDataSourceAvailable = NO;
			return NO;
		}
		
		SCNetworkReachabilityFlags flags;
		SCNetworkReachabilityRef reachability =  SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
		BOOL gotFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
		
		CFRelease(reachability);
		
		if (!gotFlags) {
			_isDataSourceAvailable = NO;
		} else {
			_isDataSourceAvailable = [self isReachableWithoutRequiringConnection:flags];
		}
		
		
			
	}
	
	return _isDataSourceAvailable;

	
}

+ (BOOL)isReachableWithoutRequiringConnection:(SCNetworkReachabilityFlags)flags
{
    // kSCNetworkReachabilityFlagsReachable indicates that the specified nodename or address can
    // be reached using the current network configuration.
    BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
    
    // This flag indicates that the specified nodename or address can
    // be reached using the current network configuration, but a
    // connection must first be established.
    //
    // If the flag is false, we don't have a connection. But because CFNetwork
    // automatically attempts to bring up a WWAN connection, if the WWAN reachability
    // flag is present, a connection is not required.
    BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
        noConnectionRequired = YES;
    }
    
    return (isReachable && noConnectionRequired) ? YES : NO;
}

/*
+ (BOOL)isDataSourceAvailable
{
    static BOOL checkNetwork = YES;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
        checkNetwork = NO;
        
        Boolean success;    
        const char *host_name = "craigslist.org";
		
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return _isDataSourceAvailable;
}
 
 
 
 - (BOOL)isHostReachable:(NSString *)host
 {
 if (!host || ![host length]) {
 return NO;
 }
 
 SCNetworkReachabilityFlags        flags;
 SCNetworkReachabilityRef reachability =  SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
 BOOL gotFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
 
 CFRelease(reachability);
 
 if (!gotFlags) {
 return NO;
 }
 
 return [self isReachableWithoutRequiringConnection:flags];
 }
 
 
 
 */

@end
