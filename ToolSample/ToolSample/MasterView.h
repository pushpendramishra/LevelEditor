//
//  MasterView.h
//  image-browser-appearance
//
//  Created by Prashant on 12/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WrapperImage.h"
#import "TSController.h"
#import "TSLayerData.h"

@interface MasterView : NSView
{
    //array
    NSMutableArray                      *imagesArrayPath;
    NSMutableArray                      *layerArray;
    NSMutableArray                      *bottomLayerArray;
    NSMutableArray                      *middleLayerArray;
    NSMutableArray                      *topLayerArray;
    
    //BezierPath
    NSBezierPath                        *_rectangle;
    NSBezierPath                        *_rectangle1, *_rectangle2, *_rectangle3, *_rectangle4;

    //Rect
	NSRect                              _rectangleStruct;
    NSRect                              collisionRect;

    //Points
	NSPoint                             _stationaryOrigin;
	NSPoint                             originPoints;
    NSPoint                             location;
    //bool
    BOOL                                _isRectResize;
    BOOL                                isImageSelected;
    BOOL                                isFirstTime;
    

    //int
    int                                 flag;
    int                                 selectedImageIndex;
    int                                 counter;
    float                               defaultSize;
    
    
    
    //class object
    WrapperImage                        *newWrapperImage;
    TSController                        *obj_TSController;
    TSLayerData                         *object_LD;
    
    //delegate
    id                                  <MyViewDelegate> delegate;
}

@property (assign)      NSMutableArray                             *layerArray;
@property (nonatomic)   BOOL                                       isCollision;
@property (nonatomic,retain)   TSController                        *obj_TSController;
@property(nonatomic,retain)    WrapperImage                        *newWrapperImage;
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

