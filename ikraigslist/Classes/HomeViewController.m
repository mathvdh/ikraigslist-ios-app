#import "HomeViewController.h"
#import "HomeView.h"
#import "CraigsListAppDelegate.h"
#import "Manager.h"
#import "CraigSectionXMLReader.h"
#import "DataManager.h"

static UIImage *tabImage = nil;

@implementation HomeViewController 

@synthesize mode=_mode;
@synthesize list;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		_mode=1;
		self.navigationItem.title=@"Browse";
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
												  initWithTitle:@"Save search" 
												  style:UIBarButtonItemStylePlain 
												  target:self 
												  action:@selector(saveQuery)] 
												 autorelease]; 
		 self.list = [NSMutableArray array];
		 tabImage = [[UIImage imageNamed:@"toolbar_browse.png"] retain];
		[self.tabBarItem initWithTitle:@"Browse" image:tabImage tag:0];
		[self restoreFromParams];
	}
    return self;
}

- (void) restoreFromParams {
	HomeView *view = (HomeView*)self.view;
	QueryParams * p = (QueryParams*)[Manager queryParams];
	NSString *tmp=nil,*tmp2=nil;
	
	tmp = [p searchCriteria];
	if (tmp != nil && [tmp length] > 0) {
		[view setSearch:tmp];
	} else {
		[view setSearch:@""];
	}
	tmp2 =[p categoryLong];
	if (tmp2 != nil && [tmp2 length] > 0) {
		[view setSection:tmp2];
	} else {
		[view setSection:@"Touch to choose"];
	}
	if ([p minValue] !=0) {
		[view setMin:[p minValue]];
	} else {
		[view resetMin];	
	}
	if ([p maxValue] !=0) {
		[view setMax:[p maxValue]];
	} else {
		[view resetMax];	
	}
	[view setDog:[p dogs]];
	[view setCat:[p cats]];
	[view setTitles:[p onlyTitles]];
	[view setPic:[p onlyPics]];
	[view setAptCount:[p roomsCount]];
	[view setViewMode:[p mode]];	
}

- (void)setSectionTitle:(NSString*)atitle {
	[(HomeView*)self.view setSection:atitle];
}

- (void)setViewMode:(int) mode {
	[[Manager queryParams] setMode:mode];
	[(HomeView*)self.view setViewMode:mode];
}

- (void)getItemsData
{
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSError *parseError = nil;
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    CraigSectionXMLReader *streamingParser = [[[CraigSectionXMLReader alloc] init] autorelease];
	NSURL *url = [NSURL URLWithString:[[Manager queryParams] getQueryAsString]];
	[streamingParser parseXMLFileAtURL:url parseError:&parseError];
      
    
	[pool drain];
	
    
}

- (void)addToItemsList:(CraigSimpleItem *)newItem
{
    [self.list addObject:newItem];
}

- (NSUInteger)countOfList {
	return [list count];
}

- (id)objectInListAtIndex:(NSUInteger)theIndex {
	return [list objectAtIndex:theIndex];
}

- (void)getList:(id *)objsPtr range:(NSRange)range {
	[list getObjects:objsPtr range:range];
}

- (void)switchToList {
	
	
	[[Manager getHomeNav] popToRootViewControllerAnimated:NO];
	
	[list removeAllObjects];
	
	if ([Manager isDataSourceAvailable] == NO) {
        return;
    }
	
	[[Manager getList] setTitle:[[Manager queryParams] categoryLong]];
	
	
	[[Manager getHomeNav] pushViewController:[Manager getList] animated:YES]; 
	
	[NSThread detachNewThreadSelector:@selector(getItemsData) toTarget:self withObject:nil];
	
}


- (void)reloadTable
{
	[[(ListViewController *)[Manager getList] tableView] reloadData];
}


- (IBAction) chooseSection: (id) sender 
{ 
	[[Manager getHomeNav] popToRootViewControllerAnimated:NO];
	[[Manager getHomeNav] pushViewController:[Manager getSection] animated:YES]; 
}


- (IBAction) goJobsPrefs: (id) sender 
{ 
	[[Manager getHomeNav] popToRootViewControllerAnimated:NO];
	[[Manager getHomeNav] pushViewController:[Manager getJobsOptions] animated:YES]; 
	
}


- (IBAction) gocraig: (id) sender 
{ 	
	if (![Manager isDataSourceAvailable]) {
		UIAlertView *baseAlert = [[UIAlertView alloc] 
								  initWithTitle:@"Attention"message:@"Craigslist couldn't be reached, either you don't have internet access or craigslist is down" 
								  delegate:nil cancelButtonTitle:nil 
								  otherButtonTitles:@"OK", nil]; 
		
		[baseAlert show];
		
		[baseAlert release];
		return;
	}else  if ([[Manager queryParams] category] == nil) {
		UIAlertView *baseAlert = [[UIAlertView alloc] 
								  initWithTitle:@"Attention"message:@"Please choose a section first" 
								  delegate:nil cancelButtonTitle:nil 
								  otherButtonTitles:@"OK", nil]; 
		
		[baseAlert show];
		
		[baseAlert release];		
	} else if ([[Manager appParams] locationUrl] == nil){
		UIAlertView *baseAlert = [[UIAlertView alloc] 
								  initWithTitle:@"Attention"message:@"Please choose a location first" 
								  delegate:nil cancelButtonTitle:nil 
								  otherButtonTitles:@"OK", nil]; 
		
		[baseAlert show];
		
		[baseAlert release];
	} else  {
		HomeView *temp = (HomeView *)[self view];
		QueryParams *p = (QueryParams *)[Manager queryParams];
		
		[p setSearchCriteria:[temp getSearch]];
		[p setMinValue:[temp getMin]];
		[p setMaxValue:[temp getMax]];
		[p setOnlyPics:[temp getPic]];
		[p setOnlyTitles:[temp getTitles]];
		
		if ([p mode]==2) { //appts
			[p setCats:[temp getCat]];
			[p setDogs:[temp getDog]];
			[p setRoomsCount:[temp getAptCount]];
		}
		
		[self switchToList];
		
		
	}
} 

- (void) moveviewtop {
	CGRect r = self.view.frame;
	CGPoint p = r.origin;
	
	if (p.y != -100) {
		p.y=-100;
		r.origin = p;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0f];
		self.view.frame=r;
		[UIView commitAnimations];
	}
}

- (void) moveviewnormal {
	CGRect r = self.view.frame;
	CGPoint p = r.origin;
	
	if (p.y != 0) {
		p.y=0;
		r.origin = p;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0f];
		self.view.frame=r;
		[UIView commitAnimations];
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{		
    
	if (textField == ((HomeView*)self.view).minfield || textField == ((HomeView*)self.view).maxfield) {
		[self moveviewtop];
	}
	
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField endEditing:YES];
	
	if (textField == ((HomeView*)self.view).minfield || textField == ((HomeView*)self.view).maxfield) {
		[self moveviewnormal];
	}
	
	return YES;
}

- (void) saveQuery {
	
	if ([[Manager queryParams] category] == nil) {
		UIAlertView *baseAlert = [[UIAlertView alloc] 
								  initWithTitle:@"Attention"message:@"Please choose a category before saving a search" 
								  delegate:nil cancelButtonTitle:nil 
								  otherButtonTitles:@"OK", nil]; 
		
		[baseAlert show];
		
		[baseAlert release];
	/*} else if ( [[Manager queryParams] searchCriteria] == nil ) {
		UIAlertView *baseAlert = [[UIAlertView alloc] 
								  initWithTitle:@"Attention"message:@"Please enter a search criteria before saving a search" 
								  delegate:nil cancelButtonTitle:nil 
								  otherButtonTitles:@"OK", nil]; 
		
		[baseAlert show];
		
		[baseAlert release];*/
	} else {
		[self pushQueryParams];
		QueryParams *p = (QueryParams *)[Manager queryParams];
		
		NSString *defaultName = [NSString stringWithFormat:@"%@-%@",p.categoryLong,p.searchCriteria];
		
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle: @"Save your search" 
							  message:@"Enter a name for this search" 
							  delegate:self 
							  cancelButtonTitle:@"Cancel" 
							  otherButtonTitles:@"OK", nil]; 
		
		UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
		tf.clearButtonMode = UITextFieldViewModeWhileEditing; 
		tf.keyboardType = UIKeyboardTypeAlphabet; 
		tf.keyboardAppearance = UIKeyboardAppearanceAlert;
		tf.autocapitalizationType = UITextAutocapitalizationTypeWords; 
		tf.autocorrectionType = UITextAutocorrectionTypeNo; 
		tf.delegate=self;
		tf.tag=13;
		
		[tf setBackgroundColor:[UIColor whiteColor]];
		tf.text = defaultName;

		[alert addSubview:tf];
		
		CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 80.0);
		[alert setTransform:myTransform];
		
		
		[alert show];

		
		
	} 
	
	
	

}

- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex 
{ 
	if (buttonIndex == 1) {
		QueryParams *p = (QueryParams *)[Manager queryParams];
		p.name = [(UITextField*)[alertView viewWithTag:13] text];
		[DataManager saveQuery:p];
		
		[[Manager getSavedQueries] reload];
	} 
}

- (void) pushQueryParams {
	HomeView *temp = (HomeView *)[self view];
	QueryParams *p = (QueryParams *)[Manager queryParams];
	
	p.searchCriteria = [temp getSearch];
	p.minValue = [temp getMin];
	p.maxValue = [temp getMax];
	p.onlyPics = [temp getPic];
	p.onlyTitles = [temp getTitles];
	
	p.cats = [temp getCat];
	p.dogs = [temp getDog];
	p.roomsCount = [temp getAptCount];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[self moveviewnormal];
}

- (void) viewWillDisappear:(BOOL)animated {
	[self moveviewnormal];
}

- (void) viewDidLoad {
	UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithTitle:@"Go"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(gocraig:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
	
}

- (void)dealloc {
	[list release];
	[super dealloc];
}

@end 
