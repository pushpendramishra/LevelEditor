//
//  TSLayerData.h
//  ToolSample
//
//  Created by prashant shukla on 26/10/12.
//  Copyright (c) 2012 prashant shukla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WrapperImage.h"
@interface TSLayerData : NSObject <NSCoding>
{
    WrapperImage        *imageObject;
    int                 uniqueID;
    int                 ID;
    int                 zOrder;
    float               originX;
    float               originY;
    float               width;
    float               height;
}


@property (nonatomic,retain) WrapperImage        *imageObject;
@property (nonatomic,assign) int                 uniqueID;
@property (nonatomic,assign) int                 ID;
@property (nonatomic,assign) int                 zOrder;
@property (nonatomic,assign) float               originX;
@property (nonatomic,assign) float               originY;
@property (nonatomic,assign) float               width;
@property (nonatomic,assign) float               height;


// ##### Encoding And Decoding Of Data !!
-(void ) decodingOfObjectData : (NSCoder*) decoder;
- (void) encodeWithCoder :(NSCoder*) encoder;


@end
