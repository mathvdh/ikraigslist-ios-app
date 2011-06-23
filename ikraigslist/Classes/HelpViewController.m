//
//  HelpViewController.m
//  ikraigslist
//
//  Created by Mathieu Van der Haegen on 12/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"
#import "DataManager.h"

static UIImage *tabImage = nil;

@implementation HelpViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		_wv = [[UIWebView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)];
		[self.view addSubview:_wv];
		
		tabImage = [[UIImage imageNamed:@"toolbar_help.png"] retain];
		[self.tabBarItem initWithTitle:@"Help" image:tabImage tag:0];
		[self loadHelp];
    }
    return self;
}

-(void) loadHelp {
	NSURL *urlbundle = [NSURL fileURLWithPath:[DataManager getBundleDirectory]];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"help_index" ofType:@"html"];
	NSString * content = [NSString stringWithContentsOfFile:filePath];
	
	[_wv loadHTMLString:content baseURL:urlbundle];
}


- (void)dealloc {
	[_wv release];
    [super dealloc];
}


@end
