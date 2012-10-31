//
//  MasterView.h
//  image-browser-appearance
//
//  Created by Prashant on 12/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "wrapperImage.h"
#import "TSController.h"
#import "TSLayerData.h"

@interface masterView : NSView 
{
    //array
    NSMutableArray                      *imagesArrayPath;
    NSMutableArray                      *layerArray;
    NSMutableArray                      *bottomLayerArray;
    NSMutableArray                      *middleLayerArray;
    NSMutableArray                      *topLayerArray;
    
    
    NSBezierPath                        *_rectangle;
    NSBezierPath                        *_circle, *_circle2, *_circle3, *_circle4;

	NSRect                              _rectangleStruct;
	NSPoint                             _stationaryOrigin;
	NSPoint                             imagePoints;
    NSRect                             collisionRect;
    
    //bool
    BOOL                                _isRectResize;
    BOOL                                isImageSelected;
    

    //int
    int                                 flag;
    int                                 selectedImageIndex;
    int                                 counter;
    
    //class object
    wrapperImage                        *newWrapperImage;
    TSController                        *obj_TSController;
    TSLayerData                         *object_LD;
    
    //delegate
    id                                  <MyViewDelegate> delegate;
}

@property (assign)      NSMutableArray                             *layerArray;
@property (nonatomic)   BOOL                                       isCollision;
@property (nonatomic,retain)   TSController                        *obj_TSController;
@property(nonatomic,retain)    wrapperImage                        *newWrapperImage;
@property(nonatomic,retain)    TSLayerData                         *object_LD;
@property(nonatomic,assign)    NSPoint                             imagePoints;

//getter 
-(NSMutableArray*)                      imagesArrayPath;


//methods
-(void)setCollision;
-(void)setBezierPath:(NSBezierPath*)newBezierPath;
-(void)setBezierPathCircle:(NSBezierPath*)newBezierPath;
-(void)addObjectArray;
-(void)create;
-(void)saveData;
-(void)openData;


//delagate
- (void)setDelegate:(id<MyViewDelegate>)_delegate;

@end

