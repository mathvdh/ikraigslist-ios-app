//
//  ViewManager.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 14/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"
#import "BookmarksViewController.h"
#import "PreferencesViewController.h"
#import "HomeViewController.h"
#import "DetailViewController.h"
#import "ListSectionsViewController.h"
#import "QueryParams.h"
#import "AppParams.h"
#import "MasterViewController.h"
#import "ImageGalleryController.h"
#import "ListRegionsViewController.h"

#import "SavedQueryViewController.h"
#import "JobsOptionViewController.h"
#import "HelpViewController.h"


@interface Manager : NSObject {

}

+ (MasterViewController *) getMain ;
+ (HomeViewController *) getHome ;
+ (UINavigationController *) getHomeNav ;
+ (UINavigationController *) getPrefNav ;
+ (UINavigationController *) getBookmarksNav ;
+ (UINavigationController *) getQueriesNav ;
+ (BookmarksViewController *) getBookmarks;
+ (SavedQueryViewController *) getSavedQueries ; 
+ (PreferencesViewController *) getPref;
+ (void) setQueryParams:(QueryParams*) newparams;
+ (QueryParams *) queryParams ;
+ (AppParams *) appParams ;


+ (ListViewController*)  getList ;
+ (ListSectionsViewController*) getSection ;
+ (DetailViewController*) getDetail ;
+ (ImageGalleryController*) getImagesDetail;
+ (DetailViewController*) getDetail2;
+ (ImageGalleryController*) getImagesDetail2;
+ (ListRegionsViewController*) getListRegions;
+ (JobsOptionViewController*) getJobsOptions;
+ (HelpViewController*) getHelp;
+ (BOOL)isDataSourceAvailable;
+ (void) reinitparams;
@end
