//
//  CraigDetailXMLReader.m
//  CraigsList
//
//  Created by Mathieu Van der Haegen on 17/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CraigDetailXMLReader.h"
#import "DetailView.h"
#import "Manager.h"
#import "DataManager.h"
#include <libxml/parser.h>
#include <libxml/tree.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>

@interface CraigDetailXMLReader()
- (void) parseBody;
- (void) parseImages;
- (void) parseEmail;
- (void) parseMap;

@end


@implementation CraigDetailXMLReader

- (void) parseBody {
	
	xmlNodeSetPtr nodes = NULL;
	xmlNodePtr root_element = NULL;
	xmlXPathContextPtr xpathCtx = NULL; 
    xmlXPathObjectPtr xpathObj = NULL; 
	xmlNodePtr cur = NULL;
	xmlBufferPtr bufptr = NULL;
	NSString* conte;
	int size=0,i=0;
	
	root_element = xmlDocGetRootElement(_doc);
	
	xpathCtx = xmlXPathNewContext(_doc);
    if(xpathCtx != NULL) {
		
		xpathObj = xmlXPathEvalExpression("/html/body/div[@id='userbody']", xpathCtx);
		
		if (xpathObj == NULL) {
			xmlXPathFreeContext(xpathCtx);
			return;
		}
		
		nodes = xpathObj->nodesetval;
	
		size = (nodes) ? nodes->nodeNr : 0;
		
		if (size == 1) {
			if(nodes->nodeTab[0]->type == XML_ELEMENT_NODE) {
				cur = nodes->nodeTab[0];
				
				bufptr = xmlBufferCreate();
				
				i = htmlNodeDump(bufptr,_doc,cur);
				
				const char* aaa = xmlBufferContent(bufptr);
				
				conte = [NSString stringWithUTF8String:aaa];
				
				
				[_item setBodyContent:conte];
				
				xmlBufferFree(bufptr);
			}
		} else {
			[_item setBodyContent:@"<font color='#FF0000' size='18'><b>Not found</b></font>"];
		}
		xmlXPathFreeContext(xpathCtx);
		xmlXPathFreeObject(xpathObj);
		
		
		//NSLog(@"%@", [_item bodyContent]);
	}
}

- (void) parseImages {
	xmlXPathContextPtr xpathCtx = NULL; 
    xmlXPathObjectPtr xpathObj = NULL; 
	xmlNodePtr cur = NULL;
	xmlNodeSetPtr nodes = NULL;
	int size=0,i=0;
	
	xpathCtx = xmlXPathNewContext(_doc);
	
	if(xpathCtx != NULL) {
		xpathObj = xmlXPathEvalExpression("//img/@src", xpathCtx);
		if (xpathObj != NULL) {
			nodes = xpathObj->nodesetval;
			
			size = (nodes) ? nodes->nodeNr : 0;
			
			if (size > 0) {
				[[[Manager getDetail] buttons] setEnabled:YES forSegmentAtIndex:2];
				for (i=0;i<size;i++) {
					if(nodes->nodeTab[i]->type == XML_ATTRIBUTE_NODE) {
						cur = nodes->nodeTab[i];
						
						if( cur->children->content) {
							//here we got the image name / url : cur->children->content
							[_item addImage: [NSString stringWithUTF8String:cur->children->content]];
						}
					}
				}
			}
			xmlXPathFreeObject(xpathObj);
		}
		xmlXPathFreeContext(xpathCtx);
	}
	
	
}

- (void) parseEmail {
	xmlXPathContextPtr xpathCtx = NULL; 
    xmlXPathObjectPtr xpathObj = NULL; 
	xmlNodePtr cur = NULL;
	xmlNodeSetPtr nodes = NULL;
	int size=0;
	
	xpathCtx = xmlXPathNewContext(_doc);
	
	if(xpathCtx != NULL) {
		xpathObj = xmlXPathEvalExpression("/html/body//a[starts-with(@href, 'mailto:')]", xpathCtx);
		if (xpathObj != NULL) {
			nodes = xpathObj->nodesetval;
			
			size = (nodes) ? nodes->nodeNr : 0;
			
			if (size == 1) {
				if(nodes->nodeTab[0]->type == XML_ELEMENT_NODE) {
					cur = nodes->nodeTab[0];
					if (cur->properties->children->content) {
						NSString* tmp = [NSString stringWithUTF8String:cur->properties->children->content];
						_item.emailLink =tmp;
						[[[Manager getDetail] buttons] setEnabled:YES forSegmentAtIndex:1];
					}
				}
			}
			xmlXPathFreeObject(xpathObj);
		}
		xmlXPathFreeContext(xpathCtx);
	}
}

- (void) parseMap {
	//[[[Manager getDetail] buttons] setEnabled:YES forSegmentAtIndex:1];
	
}

- (void) parseFromObject:(CraigDetailedItem *) item {
	_doc= NULL;
	_item = item;
	
	//NSLog(@"%@",[item htmlContent]);
	
	[(UIWebView*) [[Manager getDetail] view] loadHTMLString:[DataManager getLoadingHtml] baseURL:[NSURL fileURLWithPath:[DataManager getBundleDirectory]]];

	//NSLog([DataManager getLoadingHtml]);
	
	_doc= htmlParseDoc([[item htmlContent] UTF8String],[@"UTF-8" UTF8String]);
	
	if (_doc == NULL) {
        NSLog(@"error: could not parse file\n");
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		return;
    }
	

	[self parseBody];
	[self parseEmail];
	[self parseImages];
	[self parseMap];
	
	//here we should replace the images by copies in temp dir
	NSArray *images = item.images;
	int cnt=0;
	
	if ( [images count] > 0 ) {
		for ( UIImage *im in images) {
			NSString* tmp = [DataManager writeImageTemp:im];
			NSString* oldName = [item.imagesUrls objectAtIndex:cnt];
			
			cnt++;
			
			if (tmp!=nil && oldName!=nil) {
				[item.imagesUrls replaceObjectAtIndex:(cnt-1) withObject:tmp];
				item.bodyContent = [[item bodyContent] stringByReplacingOccurrencesOfString: oldName withString: tmp]; //maybe add something here
			}
			
			
		}
	}
	
	//NSLog([DataManager getDocumentDirectory]);
	
	//NSLog([DataManager getTempDirectory]);
	
	//NSLog([_item bodyContent]);
	
	[(UIWebView*) [[Manager getDetail] view] loadHTMLString:[_item bodyContent] baseURL:[NSURL fileURLWithPath:[DataManager getTempDirectory]]];
	[[[Manager getDetail] buttons] setEnabled:YES forSegmentAtIndex:0];
	
	xmlFreeDoc(_doc);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
}
@end
