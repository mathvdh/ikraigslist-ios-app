//
//  SimpleCellWithDate.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 10/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleCellWithDate.h"

@interface SimpleCellWithDate()
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
@end

@implementation SimpleCellWithDate

@synthesize labelText;
@synthesize labelDate;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		UIView *myContentView = self.contentView;
        
		
		// A label that displays title of the add
        self.labelText = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:18.0 bold:NO];
		self.labelText.textAlignment = UITextAlignmentLeft; // default
		
		self.labelDate = [self newLabelWithPrimaryColor:[UIColor blueColor] selectedColor:[UIColor whiteColor] fontSize:10.0 bold:NO];
		self.labelDate.textAlignment = UITextAlignmentLeft; // default
		
		[myContentView addSubview:self.labelText];
		[myContentView addSubview:self.labelDate];
		
		[self.labelText release];
    }
    return self;
}

- (void)layoutSubviews {
    
#define LEFT_COLUMN_OFFSET 10
#define LEFT_COLUMN_WIDTH 290	
#define UPPER_ROW_TOP 4
#define MIDDLE_COLUMN_OFFSET 285
    
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
        
        // Place the item label.
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, 20);
		self.labelText.frame = frame;
		
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP +20 , LEFT_COLUMN_WIDTH, 12);
		self.labelDate.frame = frame;
        
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
	
	UIColor *backgroundColor = nil;
	if (selected) {
	    backgroundColor = [UIColor clearColor];
	} else {
		backgroundColor = [UIColor whiteColor];
	}
    
	self.labelText.backgroundColor = backgroundColor;
	self.labelText.highlighted = selected;
	self.labelText.opaque = !selected;
	
	self.labelDate.backgroundColor = backgroundColor;
	self.labelDate.highlighted = selected;
	self.labelDate.opaque = !selected;
	
}

- (void) setTheText:(NSString*) text andDate:(NSString*) date {
	self.labelText.text=text;
	self.labelDate.text=date;
	
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	/*
	 Create and configure a label.
	 */
	
    UIFont *font;
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    /*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
	 */
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}


- (void)dealloc {
    [super dealloc];
}


@end
