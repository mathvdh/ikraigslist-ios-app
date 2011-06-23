//
//  QueryParams.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 10/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "QueryParams.h"
#import "DataManager.h"
#import "Manager.h"


@implementation QueryParams

@synthesize searchCriteria;
@synthesize category;
@synthesize categoryLong;
@synthesize minValue;
@synthesize maxValue;
@synthesize onlyPics;
@synthesize cats;
@synthesize dogs;
@synthesize roomsCount;
@synthesize mode;
@synthesize onlyTitles;
@synthesize sqid=_sqid;
@synthesize name=_name;



-(id) init {
	if (self = [super init]) {
		_sqid = -1;
		_name = @"no_name";
		NSString *tmp1=nil,*tmp2=nil,*tmp3=nil,*tmp4=nil,*tmp5=nil,*tmp6=nil,*tmp7=nil,*tmp8=nil,*tmp9=nil,*tmp10=nil,*tmp11=nil,*tmp12=nil;
		
		tmp1 = [DataManager getValueForKey:@"default_category"];
		tmp2 = [DataManager getValueForKey:@"default_category_long"];
		if (tmp1 !=nil && tmp2!=nil) {
			self.category=tmp1;
			self.categoryLong=tmp2;
		}
		
		tmp3 = [DataManager getValueForKey:@"default_search_criteria"];
		if (tmp3!=nil) {
			self.searchCriteria = tmp3;
		}
		
		tmp4 = [DataManager getValueForKey:@"default_min_value"];
		if (tmp4!=nil) {
			self.minValue = [tmp4 intValue];
		}
		
		tmp5 = [DataManager getValueForKey:@"default_max_value"];
		if (tmp5!=nil) {
			self.maxValue = [tmp5 intValue];
		}
		
		tmp6 = [DataManager getValueForKey:@"default_only_pics"];
		if (tmp6!=nil) {
			self.onlyPics = [tmp6 boolValue];
		} else {
			self.onlyPics=NO;
		}
		
		tmp7 = [DataManager getValueForKey:@"default_cats"];
		if (tmp7!=nil) {
			self.cats = [tmp7 boolValue];
		} else {
			self.cats=NO;
		}
		
		tmp8 = [DataManager getValueForKey:@"default_dogs"];
		if (tmp8!=nil) {
			self.dogs = [tmp8 boolValue];
		} else {
			self.dogs=NO;
		}
		
		tmp9 = [DataManager getValueForKey:@"default_rooms_count"];
		if (tmp9!=nil) {
			self.roomsCount = [tmp9 intValue];
		}
		
		tmp10 = [DataManager getValueForKey:@"default_mode"];
		if (tmp10!=nil) {
			self.mode = [tmp10 intValue];
		} else {
			self.mode = 1;
		}
		
		tmp11 = [DataManager getValueForKey:@"default_only_titles"];
		if (tmp11!=nil) {
			self.onlyTitles = [tmp11 boolValue];
		} else {
			self.onlyTitles=NO;
		}
		
		
		for (int x=0; x<5;x++) {
			
			tmp12=nil;
			tmp12 = [DataManager getValueForKey:[NSString stringWithFormat:@"j_opt_%d",x]];
			if (tmp12) {
				jopt[x]=[tmp12 boolValue];
				[tmp12 release];
			}
		}
		
		[tmp1 release];
		[tmp2 release];
		[tmp3 release];
		[tmp4 release];
		[tmp5 release];
		[tmp6 release];
		[tmp7 release];
		[tmp8 release];
		[tmp9 release];
		[tmp10 release];
		[tmp11 release];
		
	}
	return self;
}

-(id) initEmpty {
	if (self = [super init]) {
		self.category=nil;
		self.categoryLong=nil;
		self.searchCriteria = nil;
		self.minValue = 0;
		self.maxValue = 0;
		self.onlyPics=NO;
		self.cats=NO;
		self.dogs=NO;
		self.roomsCount = 0;
		self.mode = 1;
		self.onlyTitles=NO;

		for (int x=0; x<5;x++) {
			jopt[x]=NO;
		}
		_sqid = -1;
		_name = @"no_name";
	}
	return self;
}


- (void) setFromSavedQueryString:(NSString*) saved_query_string {
	NSString* separator = @"§°§";
	NSArray* params = [saved_query_string componentsSeparatedByString:separator];
	
	NSString* tmp;
	NSInteger cnt=0;
	
	//category
	tmp = [params objectAtIndex:cnt++];
	if ([tmp isEqualToString:@"nil"]) {
		category = nil;	
	} else {
		category = [tmp copy];
	}
	
	//categoryLong
	tmp = [params objectAtIndex:cnt++];
	if ([tmp isEqualToString:@"nil"]) {
		categoryLong = nil;	
	} else {
		categoryLong = [tmp copy];
	}
	
	//searchCriteria
	tmp = [params objectAtIndex:cnt++];
	if ([tmp isEqualToString:@"nil"]) {
		searchCriteria = nil;	
	} else {
		searchCriteria = [tmp copy];
	}
	
	//minValue
	tmp = [params objectAtIndex:cnt++];
	minValue = [tmp intValue];

	//maxValue
	tmp = [params objectAtIndex:cnt++];
	maxValue = [tmp intValue];
	
	//onlyPics
	tmp = [params objectAtIndex:cnt++];
	if ([tmp isEqualToString:@"Y"]) {
		onlyPics = YES;	
	} else {
		onlyPics = NO;
	}
	
	//cats
	tmp = [params objectAtIndex:cnt++];
	if ([tmp isEqualToString:@"Y"]) {
		cats = YES;	
	} else {
		cats = NO;
	}
	
	
	//dogs
	tmp = [params objectAtIndex:cnt++];
	if ([tmp isEqualToString:@"Y"]) {
		dogs = YES;	
	} else {
		dogs = NO;
	}
	
	//roomsCount
	tmp = [params objectAtIndex:cnt++];
	roomsCount = [tmp intValue];
	
	//mode
	tmp = [params objectAtIndex:cnt++];
	mode = [tmp intValue];
	
	//onlyTitles
	tmp = [params objectAtIndex:cnt++];
	if ([tmp isEqualToString:@"Y"]) {
		onlyTitles = YES;	
	} else {
		onlyTitles = NO;
	}
	
	//job options
	for (int x=0; x<5;x++) {
		tmp = [params objectAtIndex:cnt++];
		if([tmp isEqualToString:@"Y"]) {
			jopt[x] = YES;
		} else {
			jopt[x] = NO;
		}
	}
		

}


- (NSString*) getAsSavedQueryString {
	NSString* returnString = @"";
	NSString* separator = @"§°§";
	
	if (category==nil || [category length] == 0) {
		returnString = @"nil";
	} else {
		returnString = [category copy];
	}
	
	if (categoryLong==nil || [categoryLong length] == 0) {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"nil"];
	} else {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,categoryLong];
	}
	
	if (searchCriteria==nil || [searchCriteria length] == 0) {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"nil"];
	} else {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,searchCriteria];
	}
	
	returnString = [NSString stringWithFormat:@"%@%@%d",returnString,separator,minValue];
	returnString = [NSString stringWithFormat:@"%@%@%d",returnString,separator,maxValue];
	
	if (onlyPics) {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"Y"];
	} else {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"N"];
	}
	
	if (cats) {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"Y"];
	} else {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"N"];
	}
	
	if (dogs) {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"Y"];
	} else {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"N"];
	}
	
	
	returnString = [NSString stringWithFormat:@"%@%@%d",returnString,separator,roomsCount];

	returnString = [NSString stringWithFormat:@"%@%@%d",returnString,separator,mode];

	
	if (onlyTitles) {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"Y"];
	} else {
		returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"N"];
	}
	
	
	for (int x=0; x<5;x++) {
		if( jopt[x] ) {
			returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"Y"];
		} else {
			returnString = [NSString stringWithFormat:@"%@%@%@",returnString,separator,@"N"];
		}
	}
	
	return returnString;
}


- (void) saveDB {
	if (category!=nil) {
		[DataManager setValue:category forKey:@"default_category"];
	}
	if (categoryLong!=nil) {
		[DataManager setValue:categoryLong forKey:@"default_category_long"];
	}
	if (searchCriteria!=nil) {
		[DataManager setValue:searchCriteria forKey:@"default_search_criteria"];
	}

	[DataManager setValue:[NSString stringWithFormat:@"%i",minValue] forKey:@"default_min_value"];
	[DataManager setValue:[NSString stringWithFormat:@"%i",maxValue] forKey:@"default_max_value"];
	
	
	
	if(onlyPics) {
		[DataManager setValue:@"Y" forKey:@"default_only_pics"];
	} else {
		[DataManager setValue:@"N" forKey:@"default_only_pics"];
	}

	if(cats) {
		[DataManager setValue:@"Y" forKey:@"default_cats"];
	} else {
		[DataManager setValue:@"N" forKey:@"default_cats"];
	}
	
	if(dogs) {
		[DataManager setValue:@"Y" forKey:@"default_dogs"];
	} else {
		[DataManager setValue:@"N" forKey:@"default_dogs"];
	}
	if(roomsCount!=0) {
		[DataManager setValue:[NSString stringWithFormat:@"%d",roomsCount] forKey:@"default_rooms_count"];
	}
	
	if (mode!=0) {
		[DataManager setValue:[NSString stringWithFormat:@"%d",mode] forKey:@"default_mode"];
	}
		

	if(onlyTitles) {
		[DataManager setValue:@"Y" forKey:@"default_only_titles"];
	} else {
		[DataManager setValue:@"N" forKey:@"default_only_titles"];
	}
	
	//saving jobs options

	for (int x=0; x<5;x++) {
		if( jopt[x] ) {
			[DataManager setValue:@"Y" forKey:[NSString stringWithFormat:@"j_opt_%d",x]];
		} else {
			[DataManager setValue:@"N" forKey:[NSString stringWithFormat:@"j_opt_%d",x]];
		}
	}
	
	
	
}

- (void) setJopt:(bool) value atIndex:(int)index {
	jopt[index] = value;	
}

- (bool) getJopt:(int) index {
	return jopt[index];	
}

//mode 1 == withminmax
//mode 2 == with apt and minmax
//mode 3 == with job options
//mode 4 == with nothing

- (NSString*) getQueryAsString {
	NSString* min = @"min";
	NSString* max = @"max";
	NSString* pics = @"0";
	NSString* cat = @"";
	NSString* dog = @"";
	NSString* rooms = @"";
	NSString* titless= @"";
	
	NSString* url;
	
	
	if (mode!=3 && !onlyPics && !onlyTitles && minValue==0 && maxValue==0 && [searchCriteria length] ==0 && !cats && !dogs && roomsCount==0) {
		NSString* url = [NSString stringWithFormat:@"%@%@",[[Manager appParams] locationUrl],category];		
		//NSLog(@"QUERY : %@",url);
		return url;
	}
	
	NSString* goodCriteria = [[searchCriteria copy] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSString* urltemp = [[Manager appParams] locationUrl];
	
	
	if (onlyPics) {
		pics=@"1";
	}
	
	if (onlyTitles) {
		titless=@"T";
	}
	
	if (mode==1 || mode==2) {
		if (minValue != 0) {
			min= [NSString stringWithFormat:@"%d",minValue];
		}
		if (maxValue != 0) {
			max= [NSString stringWithFormat:@"%d",maxValue];
		}
		
		url = [NSString stringWithFormat:@"%@search/%@?query=%@&minAsk=%@&maxAsk=%@&hasPic=%@&srchType=%@",urltemp,category,goodCriteria,min,max,pics,titless];
	} else {
		url = [NSString stringWithFormat:@"%@search/%@?query=%@&hasPic=%@&srchType=%@",urltemp,category,goodCriteria,pics,titless];
	}
	
	
	[goodCriteria release];

	
	
	if (mode==2) {
		if (cats) {
			cat=@"purrr";
		}
		if (dogs) {
			dog=@"wooof";
		}
		if (roomsCount!=0) {
			rooms= [NSString stringWithFormat:@"%d",roomsCount];
	
		}
		url = [url stringByAppendingFormat:@"&bedrooms=%@&addTwo=%@&addThree=%@",rooms,cat,dog];
	}
	
	if (mode==3) {
		//jobs ?
		NSArray* tmp = [DataManager getJobsUrlOptions];
		int cnt=0;
		for (int x=0;x<5;x++) {
			if( jopt[x] == TRUE) {
				url = [url stringByAppendingString:[tmp objectAtIndex:x]];
				cnt++;
			} 
		}
	}
	
	NSLog(@"QUERY : %@",url);
	
	return url;
}

- (void) dealloc {
	if (searchCriteria) {
		[searchCriteria release];
	}
	if (category) {
		[category release];
	}
	if (categoryLong) {
		[categoryLong release];
	}
	if (_name) {
		[_name release];
	}
	
	[super dealloc];
}

@end
