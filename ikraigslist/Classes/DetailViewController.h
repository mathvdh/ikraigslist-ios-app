//
//  DetailViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 08/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CraigDetailedItem.h"
#import "BookMark.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface DetailViewController: UIViewController <MFMailComposeViewControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
@private 
	UISegmentedControl *buttons;
	CGRect savedFrame;
	CraigDetailedItem *_currentItem;
	NSInteger _number;
	bool _showSaveButton;

}

@property (nonatomic,retain) CraigDetailedItem* currentItem;
@property (nonatomic,retain) UISegmentedControl* buttons;

- (void) reload;
- (void) sendMail;
- (void) showPics;
//- (void) showMap;
- (void) bookmark;
- (void) setItem:(CraigDetailedItem*) theItem;
- (void) laadFromBookmark:(BookMark*) thebookmark;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil number:(NSInteger)thenumber withSaveButton:(bool) yesno;
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
- (void) displayComposerSheet:(NSInteger) type;
	- (void) launchMailAppOnDevice:(NSInteger)type;
@end
