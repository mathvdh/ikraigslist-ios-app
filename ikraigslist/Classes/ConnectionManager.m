//
//  ConnectionManager.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 25/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ConnectionManager.h"


@implementation ConnectionManager


/*
 NSError *err = nil;
 NSURLRequest *myRequest = [ [NSURLRequest alloc] initWithURL:URL ];
 NSData *data = [ NSURLConnection sendSynchronousRequest:myRequest returningResponse: nil error: &err ];
 if (err != nil) {
 NSLog(@"code : %d ,  desc: %@",[err code],[err localizedDescription]);
 return;
 }
 
 NSString *theString = [[NSString alloc] initWithData: data encoding: NSASCIIStringEncoding ];
 */


- (NSString *) getStringFromString : (NSString *) theString {
	
	NSURL *url = [NSURL URLWithString:theString];
	
	return [self getStringFromUrl: url];
	
}

- (NSString *) getStringFromUrl : (NSURL *) theUrl {
	NSError *err=nil;
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:theUrl];
	NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err]; 
	
	
	if (data==nil) {
		data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err]; 
		
		if (data==nil) {
			data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err]; 
			
			if (data==nil) {
				data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&err]; 
			}
		}
		
	}
	
	
	
	if (err != nil || data==nil) {
		NSLog(@"code : %d ,  desc: %@",[err code],[err localizedDescription]);
		return nil;
	} else {
		NSString *tmp = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];;
		return tmp;
	}
}

- (UIImage *) getImageFromString : (NSString *) theString {
	NSURL *url = [NSURL URLWithString:theString];
	
	return [self getImageFromUrl: url];
}

- (UIImage *) getImageFromUrl : (NSURL *) theUrl {
	NSData *imageData = [NSData dataWithContentsOfURL:theUrl options:NSMappedRead error:nil];
	UIImage *temp = [UIImage imageWithData:imageData];
	if (temp == nil) {
		temp = [UIImage imageWithData:[NSData dataWithContentsOfURL:theUrl]];
		
		if (temp == nil) {
			temp = [UIImage imageWithData:[NSData dataWithContentsOfURL:theUrl]];
		}
	}
	
	return temp;
}



-(id) init {
	return [super init];
}


- (void) dealloc {
	[super dealloc];
}

@end
