//
//  ListViewController.h
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CraigSimpleItem.h"

@interface ListViewItemCell : UITableViewCell {

@private	
	CraigSimpleItem *_item;
    UILabel *_itemLabel;
	UILabel *_locLabel;
	UILabel *_dateLabel;
	UIImageView *_picImageView;
}

@property (nonatomic, retain) UILabel *itemLabel;
@property (nonatomic, retain) UILabel *locLabel;
@property (nonatomic, retain) UILabel *dateLabel;

@property (nonatomic, retain) UIImageView *picImageView;

- (UIImage *)imagePic:(BOOL)pic;
- (CraigSimpleItem *)item;
- (void)setItem:(CraigSimpleItem *)newItem;

@end
