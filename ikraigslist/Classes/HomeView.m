#import "HomeView.h"

@implementation HomeView

@synthesize minfield;
@synthesize maxfield;
@synthesize searchfield;

- (NSString*) getSearch {
	return [searchfield text];
}
- (NSInteger) getMin {
	return [[minfield text] intValue];
}
- (NSInteger) getMax {
	return [[maxfield text] intValue];
}
- (BOOL) getPic {
	return [picSwitch isOn];
}
- (BOOL) getCat {
	return [catSwitch isOn];
}
- (BOOL) getDog {
	return [dogSwitch isOn];
}
- (BOOL) getTitles {
	return [titlesSwitch isOn];
}

- (NSInteger) getAptCount {
	return [roomsCtrl selectedSegmentIndex];
}

- (void) setSection:(NSString*)section {
	sectionLabel.text=section;
}

-  (void) setSearch: (NSString*) search {
	searchfield.text = search;
}

- (void) resetMin {
	minfield.text =@"";	
}

-  (void) setMin : (NSInteger) min {
	minfield.text = [NSString stringWithFormat:@"%d",min];
}

- (void) resetMax {
	maxfield.text =@"";	
}

-  (void) setMax : (NSInteger) max {
	maxfield.text = [NSString stringWithFormat:@"%d",max];
}
- (void) setPic : (BOOL) pic {
	[picSwitch setOn: pic];
}
- (void) setDog: (BOOL) dog {
	[dogSwitch setOn: dog];
}
- (void) setCat : (BOOL) cat {
	[catSwitch setOn: cat];	
}
- (void) setTitles: (BOOL) titles {
	[titlesSwitch setOn: titles];	
}
- (void) setAptCount: (NSInteger) count {
	roomsCtrl.selectedSegmentIndex=count;
}

- (void)setViewMode:(int) mode {
	
	if (mode==1) {
		[aptOptions setHidden:TRUE ];
		[jobOptions setHidden:TRUE ];
		[minmaxView setHidden:FALSE];
	} else if (mode==2) {
		[aptOptions setHidden:FALSE ];
		[jobOptions setHidden:TRUE ];
		[minmaxView setHidden:FALSE];
	} else if (mode==3) {
		[aptOptions setHidden:TRUE ];
		[jobOptions setHidden:FALSE ];
		[minmaxView setHidden:TRUE];
	} else if (mode==4) {
		[aptOptions setHidden:TRUE ];
		[jobOptions setHidden:TRUE ];
		[minmaxView setHidden:TRUE];
	}
}

@end 
