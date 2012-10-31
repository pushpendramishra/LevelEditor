//
//  wrapperImage.m
//  image-browser-appearance
//
//  Created by Ashwin Kumar on 15/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "wrapperImage.h"


@implementation wrapperImage


- (id)init
{
    self = [super init];
    if (self) {
        self.imageOnView=[[[NSImage alloc]init] autorelease ] ;
    }
    
    return self;
}


- (void) encodeWithCoder :(NSCoder*) encoder
{
    [encoder encodeObject:  self.imageOnView              forKey:@"imageOnView"];
    [encoder encodePoint:   self.origin                    forKey:@"origin"];
}

- (id) initWithCoder: (NSCoder*) decoder
{
    if (self = [self init])
    {
        // NOTE: Decoded objects are auto-released and must be retained
        self.imageOnView      = [decoder decodeObjectForKey:  @"imageOnView"];
        self.origin           = [decoder decodePointForKey:   @"origin"];
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (void)setImage:(NSImage*)curImage
{
    self.imageOnView=curImage;
}

- (NSImage*)getImage
{
	return self.imageOnView;
}

- (void)setOrigin:(NSPoint)newOrigin
{
    origin=newOrigin;
}

- (NSPoint)getOriginPoint
{
	return origin;
}

@end
