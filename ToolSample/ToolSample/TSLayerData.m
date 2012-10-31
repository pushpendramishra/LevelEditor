//
//  TSLayerData.m
//  ToolSample
//
//  Created by prashant shukla on 26/10/12.
//  Copyright (c) 2012 prashant shukla. All rights reserved.
//

#import "TSLayerData.h"

@implementation TSLayerData
@synthesize imageObject;
@synthesize uniqueID;
@synthesize originX;
@synthesize originY;
@synthesize width;
@synthesize height;
@synthesize zOrder;
@synthesize ID;


#pragma mark - Encode/ Decode

- (void) encodeWithCoder :(NSCoder*) encoder
{
    [encoder encodeObject:  self. imageObject             forKey:@"imageObject"];
    [encoder encodeFloat:   self. originX                 forKey:@"originX"];
    [encoder encodeFloat:   self. originY                 forKey:@"originY"];
    [encoder encodeFloat:   self. width                   forKey:@"width"];
    [encoder encodeFloat:   self. height                  forKey:@"height"];
    [encoder encodeInteger: self. uniqueID                forKey:@"uniqueID"];
    [encoder encodeInteger: self. zOrder                  forKey:@"zOrder"];
    [encoder encodeInteger: self. ID                      forKey:@"ID"];
}

- (id) initWithCoder: (NSCoder*) decoder
{
    if (self = [super init])
    {
        // NOTE: Decoded objects are auto-released and must be retained
        self. imageObject               = [decoder decodeObjectForKey: @"imageObject"];
        self. originX                   = [decoder decodeFloatForKey:  @"originX"];
        self. originY                   = [decoder decodeFloatForKey:  @"originY"];
        self. width                     = [decoder decodeFloatForKey:  @"width"];
        self. height                    = [decoder decodeFloatForKey:  @"height"];
        self. uniqueID                  = [decoder decodeIntegerForKey:@"uniqueID"];
        self. zOrder                    = [decoder decodeIntegerForKey:@"zOrder"];
        self. ID                        = [decoder decodeIntegerForKey:@"ID"];
        
    }
    return self;
}


- (void)dealloc
{
    if(imageObject != nil)
    {
        [imageObject   release];
        imageObject = nil;
    }
    [super dealloc];
    
}

@end
