//
//  ImageBrowserCell.m
//  browserImage
//
//  Created by Alpana on 09/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "ImageBrowserCell.h"

@implementation ImageBrowserCell

// imageFrame, define where the image should be drawn

- (NSRect) imageFrame
{
	//get default imageFrame and aspect ratio
	NSRect imageFrame = [super imageFrame];
	
	if(imageFrame.size.height == 0 || imageFrame.size.width == 0) return NSZeroRect;
	
	float aspectRatio =  imageFrame.size.width / imageFrame.size.height;
	
	// compute the rectangle included in container with a margin of at least 10 pixel at the bottom, 5 pixel at the top and keep a correct  aspect ratio
	NSRect container = [self imageContainerFrame];
	container = NSInsetRect(container, 8, 8);
	
	if(container.size.height <= 0) return NSZeroRect;
	
	float containerAspectRatio = container.size.width / container.size.height;
	
	if(containerAspectRatio > aspectRatio)
    {
		imageFrame.size.height = container.size.height;
		imageFrame.origin.y = container.origin.y;
		imageFrame.size.width = imageFrame.size.height * aspectRatio;
		imageFrame.origin.x = container.origin.x + (container.size.width - imageFrame.size.width)*0.5;
	}
	else
    {
		imageFrame.size.width = container.size.width;
		imageFrame.origin.x = container.origin.x;		
		imageFrame.size.height = imageFrame.size.width / aspectRatio;
		imageFrame.origin.y = container.origin.y + container.size.height - imageFrame.size.height;
	}
	
	//rounding
	imageFrame.origin.x = floorf(imageFrame.origin.x);
	imageFrame.origin.y = floorf(imageFrame.origin.y);
	imageFrame.size.width = ceilf(imageFrame.size.width);
	imageFrame.size.height = ceilf(imageFrame.size.height);
	
    //NSLog(@"Image Rect is %@", NSStringFromRect(imageFrame));
	return imageFrame;
}

// imageContainerFrame, override the default image container frame
- (NSRect) imageContainerFrame
{
	NSRect container = [super frame];
	
	//make the image container 15 pixels up
	container.origin.y += 15;
	container.size.height -= 15;
	
	return container;
}

// titleFrame, override the default frame for the title
- (NSRect) titleFrame
{
	//get the default frame for the title
	NSRect titleFrame = [super titleFrame];
	
	//move the title inside the 'photo' background image
	NSRect container = [self frame];
	titleFrame.origin.y = container.origin.y + 3;
	
	//make sure the title has a 7px margin with the left/right borders
	float margin = titleFrame.origin.x - (container.origin.x + 3);
	if(margin < 0)
		titleFrame = NSInsetRect(titleFrame, -margin, 0);
	
	return titleFrame;
}

// selectionFrame, make the selection frame a little bit larger than the default one

- (NSRect) selectionFrame
{
	return NSInsetRect([self frame], -5, -5);
}

@end
