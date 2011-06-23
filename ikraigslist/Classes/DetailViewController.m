//
//  DetailViewController.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 08/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailView.h"
#import "Manager.h"
#import "BookMark.h"
#import "DataManager.h"

#define ACTION_EMAIL_TO_AD_POSTER 0
#define ACTION_FORWARD_AD 1


@implementation DetailViewController

@synthesize currentItem=_currentItem;
@synthesize buttons;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil number:(NSInteger)thenumber withSaveButton:(bool) yesno {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		_number = thenumber;
		
		[(DetailView*)self.view setScalesPageToFit:YES];
		//NSArray *buttonNames = [NSArray arrayWithObjects:@"Mail", @"Pictures", @"Map", nil]; 
		
		_showSaveButton = yesno;
		
		if (_showSaveButton) {
			buttons = [[UISegmentedControl alloc] initWithItems:
					   [NSArray arrayWithObjects:
						[UIImage imageNamed:@"bookmark_small.png"],
						[UIImage imageNamed:@"email_small.png"],
						[UIImage imageNamed:@"photos_small.png"],
						//	  [UIImage imageNamed:@"map_small.png"],
						nil]];		
		} else {
			buttons = [[UISegmentedControl alloc] initWithItems:
					   [NSArray arrayWithObjects:
						//[UIImage imageNamed:@"bookmark_small.png"],
						[UIImage imageNamed:@"email_small.png"],
						[UIImage imageNamed:@"photos_small.png"],
						//	  [UIImage imageNamed:@"map_small.png"],
						nil]];			
		}
		
		
		//buttons = [[UISegmentedControl alloc] initWithItems:buttonNames]; 
		buttons.momentary= YES; 
		buttons.autoresizingMask = UIViewAutoresizingFlexibleWidth; 
		buttons.segmentedControlStyle = UISegmentedControlStyleBar; 
		buttons.frame = CGRectMake(0, 0, 400, 30);
		
		[buttons addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventValueChanged]; 

		
		
		self.navigationItem.title=@"Detail";
		self.navigationItem.titleView = buttons;
		
		savedFrame = self.view.frame;
	}
	return self;
}

- (void) buttonsAction:(id) sender 
{
	if(_showSaveButton) {
		switch([sender selectedSegmentIndex]) 
		{ 
			case 0: [self bookmark]; break;
			case 1: [self sendMail]; break; 
			case 2: [self showPics]; break; 
			//		case 3: [self showMap]; break; 
			default: break; 
		} 
	} else {
		switch([sender selectedSegmentIndex]) 
		{ 
			case 0: [self sendMail]; break; 
			case 1: [self showPics]; break; 
			//		case 3: [self showMap]; break; 
			default: break; 
		} 
	}

	
	
}

- (void) laadFromBookmark:(BookMark*) thebookmark {
	if (thebookmark.picturesLoaded==NO) {
		[thebookmark loadPictures];
	}
	self.currentItem = thebookmark.savedItem;
	
	if(_showSaveButton) {
		if (_currentItem.emailLink != nil && [_currentItem.emailLink length] > 0) {
			[buttons setEnabled:YES forSegmentAtIndex:1];
		} else {
			[buttons setEnabled:NO forSegmentAtIndex:1];
		}
		
		if ([_currentItem.images count] > 0) {
			[buttons setEnabled:YES forSegmentAtIndex:2];
		} else {
			[buttons setEnabled:NO forSegmentAtIndex:2];
		}
		/*
		 if (_currentItem.mapLink != nil && [_currentItem.mapLink length] > 0) {
		 [buttons setEnabled:YES forSegmentAtIndex:3];
		 } else {
		 [buttons setEnabled:NO forSegmentAtIndex:3];
		 }*/
	} else {
		if (_currentItem.emailLink != nil && [_currentItem.emailLink length] > 0) {
			[buttons setEnabled:YES forSegmentAtIndex:0];
		} else {
			[buttons setEnabled:NO forSegmentAtIndex:0];
		}
		
		if ([_currentItem.images count] > 0) {
			[buttons setEnabled:YES forSegmentAtIndex:1];
		} else {
			[buttons setEnabled:NO forSegmentAtIndex:1];
		}
		/*
		 if (_currentItem.mapLink != nil && [_currentItem.mapLink length] > 0) {
		 [buttons setEnabled:YES forSegmentAtIndex:3];
		 } else {
		 [buttons setEnabled:NO forSegmentAtIndex:3];
		 }*/
	}

	[(UIWebView*)self.view loadHTMLString:[_currentItem bodyContent] baseURL:[NSURL fileURLWithPath:[DataManager getDocumentDirectory]]];

}

- (void) setItem:(CraigDetailedItem*) theItem {
	if (self.currentItem !=nil) {
		[self.currentItem release];
	}
	self.currentItem = theItem;	
}

- (void) reload {
	if (_showSaveButton) {
		[buttons setEnabled:NO forSegmentAtIndex:0];
		[buttons setEnabled:NO forSegmentAtIndex:1];
		[buttons setEnabled:NO forSegmentAtIndex:2];
		//	[buttons setEnabled:NO forSegmentAtIndex:3];
	} else {
		[buttons setEnabled:NO forSegmentAtIndex:0];
		[buttons setEnabled:NO forSegmentAtIndex:1];
		//	[buttons setEnabled:NO forSegmentAtIndex:2];
	}
	

	
	
	[_currentItem loadMe];
}

- (void)dialogEmailAction
{
	// open a dialog with two custom buttons
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose email action :"
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Send email to ad poster", @"Send ad by email", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromTabBar:[(UITabBarController*)[Manager getMain]tabBar]]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == ACTION_EMAIL_TO_AD_POSTER || buttonIndex == ACTION_FORWARD_AD) {
		Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
		if (mailClass != nil)
		{
			// We must always check whether the current device is configured for sending emails
			if ([mailClass canSendMail])
			{
				[self displayComposerSheet:buttonIndex];
			}
			else
			{
				[self launchMailAppOnDevice:buttonIndex];
			}
		}
		else
		{
			[self launchMailAppOnDevice:buttonIndex];
		}
	}
}


- (void) sendMail {
	//first ask if email answer to seller or forward ad
	[self dialogEmailAction];
}

- (void) displayComposerSheet:(NSInteger) type{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;

	if (type==ACTION_EMAIL_TO_AD_POSTER) {
				
		NSCharacterSet* emailSeparators = [NSCharacterSet characterSetWithCharactersInString:@":?"];
		NSString * mailLink = [_currentItem emailLink];
		NSArray * components = [mailLink componentsSeparatedByCharactersInSet:emailSeparators];
		NSString * emailAddress = [components objectAtIndex:1];
		
		NSString *emailRegEx =
		@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
		@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
		@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
		@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
		@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
		@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
		@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
		
		NSPredicate *regExPredicate =
		[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
		BOOL isWellFormatedEmailAddress = [regExPredicate evaluateWithObject:emailAddress];
		
		if (isWellFormatedEmailAddress) {
			NSArray *toRecipients = [NSArray arrayWithObject:emailAddress]; 
			[picker setToRecipients:toRecipients];
			
			NSString *emailBody = @"";
			[picker setMessageBody:emailBody isHTML:NO];
			[picker setSubject:[[_currentItem baseItem]title]];
			
			[self presentModalViewController:picker animated:YES];
			[picker release];
			
		} else {
			UIAlertView *baseAlert = [[UIAlertView alloc] 
									  initWithTitle:@"Attention"message:@"Problem with email address" 
									  delegate:nil cancelButtonTitle:nil 
									  otherButtonTitles:@"OK", nil]; 
			
			[baseAlert show];
			
			[baseAlert release];
			
		}
		
	} else { //forward ad to email
		NSArray *toRecipients = [NSArray array]; 
		[picker setToRecipients:toRecipients];
		
		[picker setMessageBody:[_currentItem bodyContent] isHTML:YES];
		[picker setSubject:[[_currentItem baseItem]title]];
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}


- (void) launchMailAppOnDevice:(NSInteger)type {
	NSURL *url;
	if (type==ACTION_EMAIL_TO_AD_POSTER) {
		url = [[NSURL alloc] initWithString:[_currentItem emailLink]];
	} else {
		//create a new mailto link
		NSString *mailtolink = @"mailto:enteryouremailhere@please.com";
		NSString *subject = [[_currentItem baseItem]title];
		NSString *body=[_currentItem bodyContent];
		
		mailtolink = [mailtolink stringByAppendingFormat:@"?Subject=%@",[subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		mailtolink = [mailtolink stringByAppendingFormat:@"&Body=%@",[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
		
		url = [[NSURL alloc] initWithString:mailtolink];
	}
	
	[[UIApplication sharedApplication] openURL:url];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{    
    //message.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //message.text = @"Result: canceled";
            break;
        case MFMailComposeResultSaved:
            //message.text = @"Result: saved";
            break;
        case MFMailComposeResultSent:
            //message.text = @"Result: sent";
            break;
        case MFMailComposeResultFailed:
            //message.text = @"Result: failed";
            break;
        default:
            //message.text = @"Result: not sent";
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) showPics {
	if (_number == 1) {
		[[Manager getImagesDetail] setImages:[_currentItem images]];
		[[self navigationController] pushViewController:[Manager getImagesDetail] animated:YES];
	} else {
		[[Manager getImagesDetail2] setImages:[_currentItem images]];
		[[self navigationController] pushViewController:[Manager getImagesDetail2] animated:YES];
		
	}
	
}

/*- (void) showMap {
	
}*/

- (void) bookmark {
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle: @"Bookmark" 
						  message:@"Enter a name for the bookmark" 
						  delegate:self 
						  cancelButtonTitle:@"Cancel" 
						  otherButtonTitles:@"OK", nil]; 
	// Name field 
	UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
	tf.clearButtonMode = UITextFieldViewModeWhileEditing; 
	tf.keyboardType = UIKeyboardTypeAlphabet; 
	tf.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf.autocapitalizationType = UITextAutocapitalizationTypeWords; 
	tf.autocorrectionType = UITextAutocorrectionTypeNo; 
	tf.delegate=self;
	tf.tag=13;
	
	[tf setBackgroundColor:[UIColor whiteColor]];
	tf.text = _currentItem.baseItem.title;
	
	[alert addSubview:tf];
	
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 80.0);
	[alert setTransform:myTransform];
	
	[alert show];

}

- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex 
{ 
	if (buttonIndex == 1) {
		//save
		BookMark *b = [[BookMark alloc] initWithItem:_currentItem];
		b.name =[(UITextField*)[alertView viewWithTag:13] text];
		[DataManager saveBookmark:b];
		[b release];
		[[Manager getBookmarks] reload];
		[buttons setEnabled:NO forSegmentAtIndex:0];
		
	} 
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{		
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField endEditing:YES];
	return YES;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end
