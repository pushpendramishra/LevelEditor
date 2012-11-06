//
//  TSMasterView.h
//  ToolSample
//
//  Created by prashant shukla on 05/11/12.
//  Copyright (c) 2012 prashant shukla. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "wrapperImage.h"
#import "TSController.h"
#import "TSLayerData.h"

@interface TSMasterView : NSView

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
	NSPoint                             originPoints;
    NSRect                              collisionRect;
    
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
@property(nonatomic,assign)    NSPoint                             originPoints;

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
-(void)resetView;


//delagate
- (void)setDelegate:(id<MyViewDelegate>)_delegate;

@end
