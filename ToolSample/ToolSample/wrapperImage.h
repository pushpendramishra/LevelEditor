//
//  wrapperImage.h
//  image-browser-appearance
//
//  Created by Ashwin Kumar on 15/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface wrapperImage : NSObject
{
    NSImage* imageOnView;
    NSPoint origin;
}
@property(nonatomic,retain) NSImage* imageOnView;
@property(nonatomic) NSPoint origin;


- (void)setImage:(NSImage*)curImage;
- (NSImage*)getImage;
- (void)setOrigin:(NSPoint)newOrigin;
- (NSPoint)getOriginPoint;
@end
