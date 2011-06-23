//
//  CraigSectionXMLReader.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 07/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CraigSectionXMLReader.h"
#import "Manager.h"
#import "ConnectionManager.h"

#include <libxml/parser.h>
#include <libxml/tree.h>
#include <libxml/HTMLparser.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>





@implementation CraigSectionXMLReader

@synthesize currentItemObject = _currentItemObject;
@synthesize currentItemDate = _currentItemDate;


// Limit the number of parsed earthquakes to 50. Otherwise the application runs very slowly on the device.
#define MAX_ITEMS 50




- (void) printElements: (xmlNodePtr) cur_node {
	if (cur_node && cur_node->type == XML_ELEMENT_NODE) {
		
		//NSLog(@"node type: Element, name: %@\n", [NSString stringWithUTF8String:cur_node->name]);
		
		[self printElements:cur_node->children];
		
	}
	
}

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error
{	
	
	htmlDocPtr doc= NULL;
    xmlNodePtr root_element = NULL;
	xmlXPathContextPtr xpathCtx; 
    xmlXPathObjectPtr xpathObj; 
	int itemsCount=1;
	int maxItems = [[Manager appParams] numberItems];
	
	_currentItemObject=nil;
	_currentItemDate=nil;
	
	ConnectionManager * cm = [[ConnectionManager alloc] init]; //:[[[ConnectionManager alloc] init] autorelease];
	NSString *theString = [cm getStringFromUrl:URL];
	[cm release];
		
	
	if (theString == nil) {
		return;
	}
	
	NSRange tmp = [theString rangeOfString:@"Nothing found for that search"];
	
	if (tmp.location != NSNotFound) {
		UIAlertView *baseAlert = [[UIAlertView alloc] 
								  initWithTitle:@"Attention"message:@"No results found for this search" 
								  delegate:nil cancelButtonTitle:nil 
								  otherButtonTitles:@"OK", nil]; 
		
		[baseAlert show];
		[theString release];
		[baseAlert release];
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		return;
		
	}
		
		
	
	doc= htmlParseDoc([theString UTF8String],[@"UTF-8" UTF8String]);
	[theString release];
	
	if (doc == NULL) {
        NSLog(@"error: could not parse file\n");
    }
	
	root_element = xmlDocGetRootElement(doc);
	
	xpathCtx = xmlXPathNewContext(doc);
    if(xpathCtx != NULL) {
		
		xpathObj = xmlXPathEvalExpression("/html/body/blockquote/p[not(@align)]/descendant-or-self::* | /html/body/blockquote/h4", xpathCtx);

		if (xpathObj == NULL) {
			xmlXPathFreeContext(xpathCtx);
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			return;
		}
		xmlNodeSetPtr nodes = xpathObj->nodesetval;
		xmlNodePtr cur;
		int size,i;
		
		
			
		size = (nodes) ? nodes->nodeNr : 0;
		
		
		for(i = 0; i < size; ++i) {
			if(nodes->nodeTab[i]->type == XML_ELEMENT_NODE) {
				cur = nodes->nodeTab[i];
				if(!cur->ns) { 
					if (cur->name && strcmp(cur->name,"p")==0) {
						if( self.currentItemObject) {
							itemsCount++;
							[[Manager getHome]  performSelectorOnMainThread:@selector(addToItemsList:) withObject:self.currentItemObject waitUntilDone:YES];
							//[(id)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(addToItemsList:) withObject:self.currentItemObject waitUntilDone:YES];
							if (itemsCount > maxItems) {
								break;
							}
							[_currentItemObject release];
						}
						
						self.currentItemObject = [[CraigSimpleItem alloc] init];
						
						if (cur->children->content) {
							NSString *tmp = [NSString stringWithFormat:@"%s",cur->children->content];
							self.currentItemObject.date = [tmp substringToIndex: [tmp length]-2];
						} else if (self.currentItemDate) {
							self.currentItemObject.date = self.currentItemDate; 
						}
						
					} else if (cur->name && strcmp(cur->name,"a")==0) {
						
						if (cur->properties->children->content) {
							NSString *temp = [NSString stringWithUTF8String:cur->properties->children->content];
							//quickfix
							if ([temp characterAtIndex:(0)] == '/') {
								temp = [temp substringFromIndex:(1)];
							}
							
							
							
							if ([temp length]>5) {
								
								NSRange trange = [temp rangeOfString:[[Manager appParams] locationUrl]];
								
								if (trange.location == NSNotFound) {
									self.currentItemObject.directlink = [NSString stringWithFormat:@"%@%@",[[Manager appParams] locationUrl],temp];
								} else {
									self.currentItemObject.directlink = [NSString stringWithFormat:@"%@",temp];
								}
								
								if (cur->children->content) {
									self.currentItemObject.title = [NSString stringWithFormat:@"%s",cur->children->content];
								}
							}
							
						}
					} else if (cur->name && strcmp(cur->name,"font")==0) {
						if (cur->children->content) {
							self.currentItemObject.location = [NSString stringWithFormat:@"%s",cur->children->content];
						}
					} else if (cur->name && strcmp(cur->name,"span")==0) {
						self.currentItemObject.hasPics=TRUE;
					} else if (cur->name && strcmp(cur->name,"h4")==0) {
						if (cur->children->content) {
							self.currentItemDate = [NSString stringWithFormat:@"%s",(cur->children->content+4*sizeof(char))];
						}
					}
				}
			}
		}
		
		
		
		if (size!=0) {
			if( self.currentItemObject!=nil) {
				[[Manager getHome]  performSelectorOnMainThread:@selector(addToItemsList:) withObject:self.currentItemObject waitUntilDone:YES];
				[_currentItemObject release];
				//[(id)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(addToItemsList:) withObject:self.currentItemObject waitUntilDone:YES];
			}			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			[[Manager getHome] performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
			//[(id)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
		}
		

		xmlXPathFreeContext(xpathCtx);
		xmlXPathFreeObject(xpathObj);
	}

	
	
}

- (void) dealloc {
	if (_currentItemObject) {
		[_currentItemObject release];
	}
	
	if (_currentItemDate) {
		[_currentItemDate release];
	}
	
	[super dealloc];
}



@end
