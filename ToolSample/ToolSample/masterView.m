//
//  MasterView.m
//  image-browser-appearance
//
//  Created by Prashant on 12/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "masterView.h"
#import "TSLayerData.h"


#define RECT_WIDTH 200.0
#define CIRCLE_WIDTH 20.0

@interface masterView(Private)
-(void)updateShapeWithRect:(NSRect)newRect;
-(BOOL)getOriginOfRectFromHitPoint:(NSPoint)localPoint outOrigin:(NSPoint *)outOrigin;
@end


@implementation masterView(Private)


#pragma mark - private method

-(BOOL)getOriginOfRectFromHitPoint:(NSPoint)localPoint outOrigin:(NSPoint *)outOrigin
{
	BOOL didHitCircle = NO;
	if( [_circle  containsPoint:localPoint] )
	{
		NSPoint circle3Origin = NSMakePoint(_rectangleStruct.origin.x + _rectangleStruct.size.width, _rectangleStruct.origin.y+_rectangleStruct.size.height );
		outOrigin->x = circle3Origin.x;
		outOrigin->y=circle3Origin.y;
		didHitCircle = YES;
	}
	else if( [_circle2  containsPoint:localPoint] )
	{
		NSPoint circle4Origin = NSMakePoint(_rectangleStruct.origin.x , _rectangleStruct.origin.y+_rectangleStruct.size.height);
		outOrigin->x = circle4Origin.x;
		outOrigin->y=circle4Origin.y;
		didHitCircle = YES;
	}
	else if( [_circle3  containsPoint:localPoint] )
	{
        
		NSPoint circle1Origin = NSMakePoint(_rectangleStruct.origin.x, _rectangleStruct.origin.y ) ;
		outOrigin->x = circle1Origin.x;
		outOrigin->y=circle1Origin.y;
		didHitCircle = YES;
	}
	else if( [_circle4  containsPoint:localPoint] )
	{
		NSPoint circle2Origin = NSMakePoint(_rectangleStruct.origin.x + _rectangleStruct.size.width, _rectangleStruct.origin.y  );
		outOrigin->x = circle2Origin.x;
		outOrigin->y=circle2Origin.y;
		didHitCircle = YES;
	}
    if( [_rectangle  containsPoint:localPoint] )
	{
		NSPoint circle2Origin = NSMakePoint(_rectangleStruct.origin.x + _rectangleStruct.size.width, _rectangleStruct.origin.y  );
		outOrigin->x = circle2Origin.x;
		outOrigin->y=circle2Origin.y;
		didHitCircle = YES;
	}
    
    
	return didHitCircle;
}

-(void)updateShapeWithRect:(NSRect)newRect
{
	NSLog(@"New Rect %@", NSStringFromRect(newRect));
	_rectangleStruct = newRect;
    
	//NSBezierPath *_newRectPath = [NSBezierPath bezierPathWithRect:_rectangleStruct];
	//[self setBezierPath:_newRectPath];
	
	//circle1
    NSRect circle1Rect = NSMakeRect(newRect.origin.x, newRect.origin.y, CIRCLE_WIDTH, CIRCLE_WIDTH);
	if( _circle)
	{
		[_circle release];
	}
	_circle = [[NSBezierPath bezierPathWithRect:circle1Rect]retain];
	
	
	//circle2
	NSRect circle2Rect = NSMakeRect(newRect.origin.x + newRect.size.width-CIRCLE_WIDTH, newRect.origin.y  , CIRCLE_WIDTH, CIRCLE_WIDTH);
	if( _circle2)
	{
		[_circle2 release];
	}
	_circle2 = [[NSBezierPath bezierPathWithRect:circle2Rect]retain];
	
	//circle3
	NSRect circle3Rect = NSMakeRect(newRect.origin.x + newRect.size.width-CIRCLE_WIDTH, newRect.origin.y+newRect.size.height-CIRCLE_WIDTH  , CIRCLE_WIDTH, CIRCLE_WIDTH);
	if( _circle3)
	{
		[_circle3 release];
	}
	_circle3 = [[NSBezierPath bezierPathWithRect:circle3Rect]retain];
	
	
	//circle4
	NSRect circle4Rect = NSMakeRect(newRect.origin.x , newRect.origin.y+newRect.size.height-CIRCLE_WIDTH  , CIRCLE_WIDTH, CIRCLE_WIDTH);
	if( _circle4)
	{
		[_circle4 release];
	}
	_circle4 = [[NSBezierPath bezierPathWithRect:circle4Rect]retain];
	
}

@end
@implementation masterView
@synthesize isCollision;
@synthesize obj_TSController;
@synthesize newWrapperImage;
@synthesize layerArray;
@synthesize object_LD;
@synthesize mousePoints;

- (id)initWithFrame:(NSRect)frame 
{
    if (! (self = [super initWithFrame:frame] ) ) 
    {
		NSLog(@"Error: MyNSView initWithFrame");
        flag=1;
        return self;
    } 
    isImageSelected = NO;
    [newWrapperImage setImage: nil];
    layerArray = [[NSMutableArray alloc]init];
	imagesArrayPath = [[NSMutableArray alloc]init];
    isCollision =NO;
    
	[self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, NSFilenamesPboardType, nil]];
    
    return self;
} 


- (void)awakeFromNib
{
    layerArray = [[NSMutableArray alloc]init];
    bottomLayerArray = [[NSMutableArray alloc]init];
    middleLayerArray = [[NSMutableArray alloc]init];
    topLayerArray = [[NSMutableArray alloc]init];
    
    
    self.object_LD = [[[TSLayerData alloc]init ]autorelease];
    
    //add 
    [layerArray addObject:bottomLayerArray];
    [layerArray addObject:middleLayerArray];
    [layerArray addObject:topLayerArray];

    counter = 0;
    
    
    
    
}


-(void)setCollision
{
    NSRect dirtyRect;
    dirtyRect = NSMakeRect(object_LD.originX - object_LD.width/2, object_LD.originY ,  object_LD.width/2 ,object_LD.height/2);
    collisionRect.size.width =  object_LD.width/2;
    collisionRect.size.height =object_LD.height/2;
    [self updateShapeWithRect:dirtyRect];
    [self setNeedsDisplay:YES];
	
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];    

    for (NSArray*object in layerArray)
    {
        for (TSLayerData*obj in object)
        {
            NSLog(@"draw Rect image location point is %f", obj.originY);
            
            // ##### Condition to Prevent Drawing in -X direction from Origin !!
            if(obj.originX < obj.width/2)
                obj.originX = obj.width/2;
            
            [[obj.imageObject getImage] compositeToPoint:NSMakePoint(obj.originX-obj.width/2,obj.originY-obj.height/2) operation:NSCompositeSourceOver];
            
            if(isImageSelected)
            {
                    //draw image border
                    NSRect dirtyRect2;
                   dirtyRect2 = NSMakeRect(object_LD.originX - object_LD.width/2, object_LD.originY -object_LD.height/2,  object_LD.width ,object_LD.height);

                   [[NSColor greenColor] set];
                   [NSBezierPath strokeRect:dirtyRect2];
            }
            
        }
    }
    // Draw your custom content here. Anything you draw
    // automatically has the shadow effect applied to it.
    
    //draw border

    if(![layerArray count]) return;
    if (isCollision )
    {
      
        //draw collision rectangle
        [[NSColor redColor] set];
        NSBezierPath  *temp =[NSBezierPath bezierPathWithRect:_rectangleStruct];
        [temp stroke];
        
        [[NSColor yellowColor]set];
        [_circle fill];
        [_circle2 fill];
        [_circle3 fill];
        [_circle4 fill];
    }
    /*if(isCollision && isImageSelected)
    {
        CGRect rectangle;
//        rectangle.origin.x = collisionRect.origin.x+object_LD.originX+object_LD.width/2;
//        rectangle.origin.y = collisionRect.origin.y+object_LD.originY+object_LD.height/2;
//        rectangle.size.width = collisionRect.size.width;
//        rectangle.size.height = collisionRect.size.height;
        //rectangle.origin.x = collisionRect.origin.x+object_LD.originX ;
        //rectangle.origin.y = collisionRect.origin.y+object_LD.originY;//-collisionRect.size.height
        rectangle.origin.x = object_LD.originX -object_LD.width/2;
        rectangle.origin.y = object_LD.originY-collisionRect.size.height;//

        rectangle.size.width = collisionRect.size.width;
        rectangle.size.height = collisionRect.size.height;
        NSBezierPath *__rectangle = [NSBezierPath bezierPathWithRect:rectangle];
        NSLog(@"change ... %@",NSStringFromRect(collisionRect));
             NSLog(@"object ... %f %f %f %f",object_LD.originX,object_LD.originY,object_LD.width,object_LD.height);
        NSLog(@"collision  ... %@",NSStringFromRect(rectangle));

        [[NSColor redColor] set];
        [__rectangle stroke];
        
        [[NSColor yellowColor]set];
        [_circle fill];
        [_circle2 fill];
        [_circle3 fill];
        [_circle4 fill];
        

        
    }*/
    


    
    
}

#pragma mark - setter method

-(void)setBezierPath:(NSBezierPath*)newBezierPath
{
	if( _rectangle != newBezierPath)
	{
		[newBezierPath retain];
		[_rectangle release];
		_rectangle = newBezierPath;
		
		
	}
    
    
	
	
}

-(void)setBezierPathCircle:(NSBezierPath*)newBezierPath
{
	if( _circle != newBezierPath)
	{
		[newBezierPath retain];
		[_circle release];
		_circle = newBezierPath;
		
	}
	
	
}


#pragma mark - getter method

-(NSMutableArray*)imagesArrayPath
{
    return imagesArrayPath;
}


#pragma mark - drag method

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
        NSLog(@"draggingEntered master view");
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) 
    {
        return NSDragOperationGeneric;
    }
	
    // not a drag we can use
	return NSDragOperationNone;		
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
    [newWrapperImage setOrigin:[sender draggingLocation]];
    [self addObjectArray];
    [self setNeedsDisplay:YES];    
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender 
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender 
{
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
	
    NSArray *zImageTypesAry = [NSArray arrayWithObjects:NSPasteboardTypeTIFF, NSFilenamesPboardType, nil];
	
    NSString *zDesiredType = [zPasteboard availableTypeFromArray:zImageTypesAry];
	
	if ([zDesiredType isEqualToString:NSPasteboardTypeTIFF]) 
    { 
		NSData *zPasteboardData   = [zPasteboard dataForType:zDesiredType];
		if (zPasteboardData == nil) 
        {
			NSLog(@"Error: MyNSView performDragOperation zPasteboardData == nil");
			return NO;
		}
        
		return YES;		
	}
	
	
    if ([zDesiredType isEqualToString:NSFilenamesPboardType]) 
    {
		// the pasteboard contains a list of file names, Take the first one
		NSArray *zFileNamesAry = [zPasteboard propertyListForType:@"NSFilenamesPboardType"];
		NSString *zPath = [zFileNamesAry objectAtIndex:0];	
        
        self.newWrapperImage=[[[wrapperImage alloc]init] autorelease];               //object of wrapperImage class which has a NSImage and origin associated with it
        [newWrapperImage setImage:[[NSImage alloc]initWithContentsOfFile:zPath]];        
        
        if (newWrapperImage == nil) 
            {			
         		NSLog(@"Error: MyNSView performDragOperation zNewImage == nil");
          		return NO;
            }


        [imagesArrayPath addObject:zPath];
		return YES;
        
    }
	
	NSLog(@"Error MyNSView performDragOperation");
	return NO;
	
} 

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}


#pragma mark - mouseevent method

-(void)mouseDown:(NSEvent *)pTheEvent 
{
    NSPoint mouseLocationInWindow = [pTheEvent locationInWindow];
	NSPoint mouseLocationInView   = [self convertPoint:mouseLocationInWindow fromView:nil];
	
	_isRectResize = [self getOriginOfRectFromHitPoint:mouseLocationInView outOrigin:&_stationaryOrigin] ;
    
    if (!_isRectResize)
    {
        for(NSArray*object in layerArray)
        {
            object = [[object reverseObjectEnumerator] allObjects];
            for (TSLayerData*obj in object)
            {
                
                if( CGRectContainsPoint(CGRectMake(obj.originX-obj.width/2, obj.originY-obj.height/2, obj.width, obj.height), CGPointMake( mouseLocationInView.x, mouseLocationInView.y)))

                {
                    self.object_LD = obj;
                    selectedImageIndex = self.object_LD.uniqueID;
                    isImageSelected = YES;
                    break;
                }
                
            }
            if(isImageSelected)
                break;
        }
        
    }
    
    

    
    
    if(isImageSelected)
    {
        [self setNeedsDisplay:YES];
    }
    


}



- (void)rightMouseDown:(NSEvent *)theEvent
{
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    [theMenu insertItemWithTitle:@"Beep" action:@selector(beep) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Honk" action:@selector(honk) keyEquivalent:@"" atIndex:1];
    
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];

}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint mouseLocationInWindow = [theEvent locationInWindow];
    NSPoint mouseLocationInView   = [self convertPoint:mouseLocationInWindow fromView:nil];

    if(isImageSelected)
    {
        object_LD.originX =  mouseLocationInView.x;
        object_LD.originY =  mouseLocationInView.y;
    }

    
    //set scalingfactor
    mousePoints.x =object_LD.originX - object_LD.width/2;
    mousePoints.y =object_LD.originY - object_LD.height/2;
    
    if(mousePoints.x < 0)
        mousePoints.x = 0;
    
    NSRect newRect = _rectangleStruct;
    
    if( _isRectResize )
	{
        NSLog(@"mouse Dragged");
		
		
		if( _stationaryOrigin.x > mouseLocationInView.x )
		{
			newRect.origin.x = mouseLocationInView.x;
		}
		
		if( _stationaryOrigin.y > mouseLocationInView.y )
		{
			newRect.origin.y = mouseLocationInView.y;
		}
		
		newRect.size.width = fabsf(_stationaryOrigin.x - mouseLocationInView.x);
		newRect.size.height = fabsf(_stationaryOrigin.y - mouseLocationInView.y);
        
		
		[self updateShapeWithRect:newRect];
		[self setNeedsDisplayInRect:newRect];
        
//        newRect.origin.x = imagePoints.x;
//        newRect.origin.y = imagePoints.y+ object_LD.height;
//        newRect.size.width = 200;
//        newRect.size.height = 200;

        
	}
    
//    if(isCollision)
//    {
//        if(newRect.origin.x == 0&&newRect.origin.y==0)
//        {
//             newRect.origin.x = imagePoints.x;
//             newRect.origin.y = imagePoints.y+ object_LD.height;
//        }
//            
//        collisionRect.origin.x =  newRect.origin.x -  object_LD.originX;
//        collisionRect.origin.y =  newRect.origin.y -  object_LD.originY;
//        
//        
//        collisionRect.size.width = newRect.size.width;
//        collisionRect.size.height = newRect.size.height;
//
//    }
    
    /*if(isCollision && isImageSelected)
    {
        if(newRect.origin.x == 0&&newRect.origin.y==0)
        {
            newRect.origin.x = imagePoints.x;
            newRect.origin.y = imagePoints.y+ object_LD.height;
        }
        
        collisionRect.origin.x =  _rectangleStruct.origin.x -  object_LD.originX;
        collisionRect.origin.y =  _rectangleStruct.origin.y -  object_LD.originY;
        
        
        collisionRect.size.width = _rectangleStruct.size.width;
        collisionRect.size.height = _rectangleStruct.size.height;
        [self updateShapeWithRect:_rectangleStruct];
        
    }*/
    
    

    //setting origin for the only image which has been clicked in mouseDown instead of again iterating over the whole image array r
    

    
    
	[self setNeedsDisplay:YES];
    
    
    if (delegate && [delegate respondsToSelector:@selector(doStuff:)])
    {
    [delegate doStuff:theEvent];
    }
    return;
}

- (void)mouseUp:(NSEvent *)pTheEvent
{
    
    if( _isRectResize )
	{
		NSPoint event_location = [pTheEvent locationInWindow];
		NSPoint local_point = [self convertPoint:event_location fromView:nil];
		
		NSRect newRect = _rectangleStruct;
		if( _stationaryOrigin.x > local_point.x )
		{
			newRect.origin.x = local_point.x;
		}
		
		if( _stationaryOrigin.y > local_point.y )
		{
			newRect.origin.y = local_point.y;
		}
		
		newRect.size.width = fabsf(_stationaryOrigin.x - local_point.x);
		newRect.size.height = fabsf(_stationaryOrigin.y - local_point.y);
		
		
		[self updateShapeWithRect:newRect];
		[self setNeedsDisplay:YES];
	}
    isImageSelected = NO;
    return;
}



#pragma mark - keyEvent opreatons



-(void)keyDown:(NSEvent *)event
{
    NSString *characters;
    characters = [event characters];
    unichar keyCode = [characters characterAtIndex: 0];
    TSLayerData  *tempObj;
    
    if (keyCode == 43 || keyCode == 61)
    {
        
        for (int i =0; i<[[layerArray objectAtIndex:object_LD.ID] count]; i++)
        {
            tempObj =[[layerArray objectAtIndex:object_LD.ID] objectAtIndex:i];
            if (object_LD.uniqueID == tempObj.uniqueID)
            {
                if (i!=[[layerArray objectAtIndex:object_LD.ID] count]-1 && [[layerArray objectAtIndex:object_LD.ID] count] != 1)
                {
                    object_LD.zOrder = object_LD.zOrder+1;
                    
                }
            }
        }
        
        [[layerArray objectAtIndex:object_LD.ID] sortUsingFunction:sortTagByName context:nil];
        
        
        [self setNeedsDisplay:YES];
    }
    else if (keyCode == 45 || keyCode == 95)
    {
        for (int i =0; i<[[layerArray objectAtIndex:object_LD.ID] count]; i++)
        {
            tempObj =[[layerArray objectAtIndex:object_LD.ID] objectAtIndex:i];
            if (object_LD.uniqueID == tempObj.uniqueID)
            {
                if (i!=0 && [[layerArray objectAtIndex:object_LD.ID] count] != 1)
                {
                    object_LD.zOrder = object_LD.zOrder-1;
                    
                }
            }
        }
        
        [[layerArray objectAtIndex:object_LD.ID] sortUsingFunction:sortTagByName context:nil];
        
        
        [self setNeedsDisplay:YES];
    }
    else
    {
        
    }
    
}


NSComparisonResult sortTagByName(TSLayerData *tag1, TSLayerData *tag2, void *ignore)
{
    return [[NSNumber numberWithInt:tag1.zOrder] compare:[NSNumber numberWithInt:tag2.zOrder]];
}


#pragma mark - other method


- (void)addObjectArray
{
    TSLayerData   *obj_TSLayerData = [[TSLayerData alloc] init];
    NSTabViewItem  *item = [obj_TSController.tabView selectedTabViewItem];
    counter++;
    
    obj_TSLayerData.uniqueID = counter ;
    obj_TSLayerData.imageObject = newWrapperImage;
    obj_TSLayerData.originX = [newWrapperImage getOriginPoint].x;
    obj_TSLayerData.originY = [newWrapperImage getOriginPoint].y;
    obj_TSLayerData.width = [newWrapperImage getImage].size.width;
    obj_TSLayerData.height = [newWrapperImage getImage].size.height;
    obj_TSLayerData.ID = [[item identifier] intValue ];
    obj_TSLayerData.zOrder = 0;
    
    [[layerArray objectAtIndex:[[item identifier] intValue ]] addObject:obj_TSLayerData];
    [obj_TSLayerData release];
    
    
}


- (void)setDelegate:(id<MyViewDelegate>)_delegate
{
    delegate = _delegate;
}

-(void)create
{
    NSRect dirtyRect;
    dirtyRect = NSMakeRect( collisionRect.origin.x, collisionRect.origin.y, collisionRect.size.width ,collisionRect.size.height);
    [self updateShapeWithRect:dirtyRect];
    [self setNeedsDisplay:YES];

}


#pragma mark - Encode/ Decode

- (void) encodeWithCoder :(NSCoder*) encoder
{
    [encoder encodeObject:  self. layerArray              forKey:@"dataArray"];
}

- (id) initWithCoder: (NSCoder*) decoder
{
    if (self = [self init])
    {
        // NOTE: Decoded objects are auto-released and must be retained
        self. layerArray      = [decoder decodeObjectForKey:  @"dataArray"];
    }
    return self;
}

-(void)saveData
{

 
}

-(void)openData
{
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"Property List.plist"];

    NSData  *modelData = [NSData dataWithContentsOfFile:filePath];
    
    if (modelData != nil)
    {
        // retrieve stored data
        masterView *obj_ProfileModelUnarchiever = [[masterView alloc] init];
        obj_ProfileModelUnarchiever. layerArray = [NSKeyedUnarchiver unarchiveObjectWithData: modelData];
        
        NSLog(@"loadFromSerializedObjects %@", obj_ProfileModelUnarchiever. layerArray);
        
        if (obj_ProfileModelUnarchiever. layerArray != nil)
        {
            [layerArray removeAllObjects];
            [self.layerArray addObjectsFromArray:obj_ProfileModelUnarchiever. layerArray];
            [self setNeedsDisplay:YES];
        }

    }*/
    
    
    [self setNeedsDisplay:YES];


}

-(void)resetView
{
    [layerArray removeAllObjects];
    [self setNeedsDisplay:YES];
}


#pragma mark - memory management

- (void) dealloc
{
    [layerArray release];
    [imagesArrayPath release];
    [obj_TSController release];
    [bottomLayerArray release];
    [middleLayerArray release];
    [topLayerArray release];
    
    
    [super dealloc];
}
@end
