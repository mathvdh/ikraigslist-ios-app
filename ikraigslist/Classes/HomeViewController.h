// View controller that autorotates 
#import "ListSectionsViewController.h";
#import "ListViewController.h";

@interface HomeViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate> {
	int _mode;
	NSMutableArray *list;
}

@property(readonly) int mode;
@property (nonatomic, retain) NSMutableArray *list;

- (void) setSectionTitle:(NSString*)atitle;
- (void) setViewMode:(int) mode;
- (void) pushQueryParams;
- (void) restoreFromParams;
- (NSUInteger)countOfList;
- (id)objectInListAtIndex:(NSUInteger)theIndex;
- (void)getList:(id *)objsPtr range:(NSRange)range;
- (IBAction) gocraig: (id) sender;

@end