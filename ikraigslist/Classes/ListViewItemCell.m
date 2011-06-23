//
//  ListViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ListViewItemCell.h"

static UIImage *picImage = nil;

@interface ListViewItemCell()
- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;
@end

@implementation ListViewItemCell

@synthesize itemLabel = _itemLabel;
@synthesize locLabel = _locLabel;
@synthesize dateLabel = _dateLabel;

@synthesize picImageView = _picImageView;

+ (void)initialize
{
    // The magnitude images are cached as part of the class, so they need to be
    // explicitly retained.
    picImage = [[UIImage imageNamed:@"camera_icon.png"] retain];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        UIView *myContentView = self.contentView;
        
               
		// A label that displays title of the add
        self.itemLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:NO]; 
		self.itemLabel.numberOfLines=2;
		self.itemLabel.lineBreakMode=UILineBreakModeTailTruncation;
		self.itemLabel.textAlignment = UITextAlignmentLeft; // default
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[myContentView addSubview:self.itemLabel];
		[self.itemLabel release];
                
        // A picture if there are pics
		self.picImageView = [[UIImageView alloc] initWithImage:picImage];
		[myContentView addSubview:self.picImageView];
        [self.picImageView release];
		
		//A label for the location
		self.locLabel = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:10.0 bold:NO];
		self.locLabel.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview:self.locLabel];
		[self.locLabel release];
		
		self.dateLabel = [self newLabelWithPrimaryColor:[UIColor blueColor] selectedColor:[UIColor whiteColor] fontSize:8.0 bold:NO];
		self.dateLabel.textAlignment = UITextAlignmentLeft;
		[myContentView addSubview:self.dateLabel];
		[self.dateLabel release];
        

    }
    return self;
}

- (UIImage *)imagePic:(BOOL)pic
{
	if (pic) {
		return picImage;
	} else {
		return nil;
	}	
		
}


- (CraigSimpleItem *)item
{
    return _item;
}

// Rather than using one of the standard UITableViewCell content properties like 'text',
// we're using a custom property called 'quake' to populate the table cell. Whenever the
// value of that property changes, we need to call [self setNeedsDisplay] to force the
// cell to be redrawn.
- (void)setItem:(CraigSimpleItem *)newItem
{
    [newItem retain];
    [_item release];
    _item = newItem;
    
    self.itemLabel.text = newItem.title;
	self.locLabel.text = newItem.location;
	self.dateLabel.text = newItem.date;
	
	
	self.picImageView.image = [self imagePic:newItem.hasPics];
      
    [self setNeedsDisplay];
}


- (void)layoutSubviews {
    
#define LEFT_COLUMN_OFFSET 20
#define LEFT_COLUMN_WIDTH 265
	
#define MIDDLE_COLUMN_OFFSET 285
#define MIDDLE_COLUMN_WIDTH 40
		
#define UPPER_ROW_TOP 4
#define LOWER_ROW_TOP 44
    
    [super layoutSubviews];
	
    CGRect contentRect = self.contentView.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
    if (!self.editing) {
		
        CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
        
        // Place the item label.
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, 40);
		self.itemLabel.frame = frame;
		
		//date
		frame = CGRectMake(boundsX + MIDDLE_COLUMN_OFFSET, UPPER_ROW_TOP -4 , LEFT_COLUMN_WIDTH, 12);
		self.dateLabel.frame = frame;
		
		
        // Place the pic image.
        UIImageView *imageView = self.picImageView;
        frame = [imageView frame];
		frame.origin.x = boundsX;
		frame.origin.y = 5;
 		imageView.frame = frame;
		
		// Place the loc label.
		frame = CGRectMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP, LEFT_COLUMN_WIDTH, 14);
		self.locLabel.frame = frame;
        
	}
	 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	/*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so in newLabelForMainText: the labels are made opaque and given a white background.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  
     */
	[super setSelected:selected animated:animated];
	
	UIColor *backgroundColor = nil;
	if (selected) {
	    backgroundColor = [UIColor clearColor];
	} else {
		backgroundColor = [UIColor whiteColor];
	}
    
	self.itemLabel.backgroundColor = backgroundColor;
	self.itemLabel.highlighted = selected;
	self.itemLabel.opaque = !selected;
	
	self.locLabel.backgroundColor = backgroundColor;
	self.locLabel.highlighted = selected;
	self.locLabel.opaque = !selected;
	
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

@end
