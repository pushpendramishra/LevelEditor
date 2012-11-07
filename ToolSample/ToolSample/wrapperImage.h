//
//  wrapperImage.h
//  image-browser-appearance
//
//  Created by Ashwin Kumar on 15/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface wrapperImage : NSImageView
{
    NSImage* imageOnView;
    NSPoint  origin;
}

// Properties Of Class !!
@property(nonatomic,retain) NSImage* imageOnView;
@property(nonatomic) NSPoint origin;


// Functions !!
- (void )setImage:(NSImage*)curImage;
- (NSImage* )getImage;
- (void )setOrigin:(NSPoint)newOrigin;
- (NSPoint )getOriginPoint;

@end
