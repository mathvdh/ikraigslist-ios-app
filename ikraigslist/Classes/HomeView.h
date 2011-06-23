@interface HomeView : UIView  { 
	IBOutlet UITextField *searchfield;
	IBOutlet UIView *minmaxView;
	IBOutlet UITextField *minfield;
	IBOutlet UITextField *maxfield;
	IBOutlet UISwitch *picSwitch;
	IBOutlet UISwitch *catSwitch;
	IBOutlet UISwitch *dogSwitch;
	IBOutlet UISwitch *titlesSwitch;
	IBOutlet UISegmentedControl *roomsCtrl;
	IBOutlet UILabel *sectionLabel;
	IBOutlet UIView *aptOptions;
	IBOutlet UIView *jobOptions;
	
}

@property (nonatomic, retain) UITextField *minfield;
@property (nonatomic, retain) UITextField *maxfield;
@property (nonatomic, retain) UITextField *searchfield;

- (NSString*) getSearch ;
- (NSInteger) getMin ;
- (NSInteger) getMax ;
- (BOOL) getPic;
- (BOOL) getDog;
- (BOOL) getCat;
- (BOOL) getTitles;
- (NSInteger) getAptCount;

- (void)setViewMode:(int) mode;
- (void) setSection:(NSString*)section;
-  (void) setSearch: (NSString*) search ;
-  (void) setMin : (NSInteger) min ;
-  (void) setMax : (NSInteger) max;
- (void) setPic : (BOOL) pic;
- (void) setDog: (BOOL) dog;
- (void) setCat : (BOOL) cat;
- (void) setTitles: (BOOL) titles;
- (void) setAptCount: (NSInteger) count;

- (void) resetMin;
- (void) resetMax;

@end 