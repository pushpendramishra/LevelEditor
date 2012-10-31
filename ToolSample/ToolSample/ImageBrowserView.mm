//
//  ImageBrowserView.h
//  browserImage
//
//  Created by Alpana on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageBrowserView.h"
#import "ImageBrowserCell.h"


@implementation ImageBrowserView

// Allocate and return our own cell class for the specified item. The returned cell must not be autoreleased 

- (IKImageBrowserCell *) newCellForRepresentedItem:(id) cell
{
	return [[ImageBrowserCell alloc] init];
}

// override draw rect and force the background layer to redraw if the view did resize or did scroll 

- (void) drawRect:(NSRect) rect
{
	//retrieve the visible area
    //NSLog(@"draw rect of ImageBrowserView   ");
	NSRect visibleRect = [self visibleRect];
	
	//compare with the visible rect at the previous frame
	if(!NSEqualRects(visibleRect, lastVisibleRect))
    {		
		//update last visible rect
		lastVisibleRect = visibleRect;
	}
	
	[super drawRect:rect];
}

@end
