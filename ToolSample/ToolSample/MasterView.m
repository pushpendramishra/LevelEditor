////
//  MasterView.m
//  image-browser-appearance
//
//  Created by Prashant on 12/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MasterView.h"
#import "TSLayerData.h"


#define RECT_WIDTH      200.0
#define RECTANGLE_WIDTH 20.0

@interface MasterView(Private)
-(void)updateShapeWithRect:(NSRect)newRect;
-(BOOL)getOriginOfRectFromHitPoint:(NSPoint)localPoint outOrigin:(NSPoint *)outOrigin;
@end


@implementation MasterView(Private)


#pragma mark - private method

-(BOOL)getOriginOfRectFromHitPoint:(NSPoint)localPoint outOrigin:(NSPoint *)outOrigin
{
	BOOL didHitRect = NO;
	if( [_rectangle1  containsPoint:localPoint] )
	{
		NSPoint rectangle3Origin = NSMakePoint(_rectangleStruct.origin.x + _rectangleStruct.size.width, _rectangleStruct.origin.y+_rectangleStruct.size.height );
		outOrigin->x = rectangle3Origin.x;
		outOrigin->y=rectangle3Origin.y;
		didHitRect = YES;
	}
	else if( [_rectangle2  containsPoint:localPoint] )
	{
		NSPoint rectangle4Origin = NSMakePoint(_rectangleStruct.origin.x , _rectangleStruct.origin.y+_rectangleStruct.size.height);
		outOrigin->x = rectangle4Origin.x;
		outOrigin->y=rectangle4Origin.y;
		didHitRect = YES;
	}
	else if( [_rectangle3  containsPoint:localPoint] )
	{
        
		NSPoint rectangle1Origin = NSMakePoint(_rectangleStruct.origin.x, _rectangleStruct.origin.y ) ;
		outOrigin->x = rectangle1Origin.x;
		outOrigin->y=rectangle1Origin.y;
		didHitRect = YES;
	}
	else if( [_rectangle4  containsPoint:localPoint] )
	{
		NSPoint rectangle2Origin = NSMakePoint(_rectangleStruct.origin.x + _rectangleStruct.size.width, _rectangleStruct.origin.y  );
		outOrigin->x = rectangle2Origin.x;
		outOrigin->y=rectangle2Origin.y;
		didHitRect = YES;
	}
    
    
    
	return didHitRect;
}


-(void)updateShapeWithRect:(NSRect)newRect
{
	NSLog(@"New Rect %@", NSStringFromRect(newRect));
	_rectangleStruct = newRect;
    
	//NSBezierPath *_newRectPath = [NSBezierPath bezierPathWithRect:_rectangleStruct];
	//[self setBezierPath:_newRectPath];
	
	//_rectangle1
    NSRect circle1Rect = NSMakeRect(newRect.origin.x, newRect.origin.y, RECTANGLE_WIDTH, RECTANGLE_WIDTH);
	if( _rectangle1)
	{
		[_rectangle1 release];
	}
	_rectangle1 = [[NSBezierPath bezierPathWithRect:circle1Rect]retain];
	
	
	//_rectangle2
	NSRect circle2Rect = NSMakeRect(newRect.origin.x + newRect.size.width-RECTANGLE_WIDTH, newRect.origin.y  , RECTANGLE_WIDTH, RECTANGLE_WIDTH);
	if( _rectangle2)
	{
		[_rectangle2 release];
	}
	_rectangle2 = [[NSBezierPath bezierPathWithRect:circle2Rect]retain];
	
	//_rectangle3
	NSRect circle3Rect = NSMakeRect(newRect.origin.x + newRect.size.width-RECTANGLE_WIDTH, newRect.origin.y+newRect.size.height-RECTANGLE_WIDTH  , RECTANGLE_WIDTH, RECTANGLE_WIDTH);
	if( _rectangle3)
	{
		[_rectangle3 release];
	}
	_rectangle3 = [[NSBezierPath bezierPathWithRect:circle3Rect]retain];
	
	
	//_rectangle4
	NSRect circle4Rect = NSMakeRect(newRect.origin.x , newRect.origin.y+newRect.size.height-RECTANGLE_WIDTH  , RECTANGLE_WIDTH, RECTANGLE_WIDTH);
	if( _rectangle4)
	{
		[_rectangle4 release];
	}
	_rectangle4 = [[NSBezierPath bezierPathWithRect:circle4Rect]retain];
    
	
}

@end
@implementation MasterView
@synthesize isCollision;
@synthesize obj_TSController;
@synthesize newWrapperImage;
@synthesize layerArray;
@synthesize object_LD;
@synthesize originPoints;

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
    collisionObjectArray = [[NSMutableArray alloc]init];
    
    
    
    self.object_LD = [[[TSLayerData alloc]init ]autorelease];
    
    
    //add 
    [layerArray addObject:bottomLayerArray];
    [layerArray addObject:middleLayerArray];
    [layerArray addObject:topLayerArray];

    counter = 0;
    
    
    
    
}


#pragma mark -  drawrect

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];    

    for (NSArray*object in layerArray)
    {
        for (TSLayerData*obj in object)
        {
            NSLog(@"draw Rect image location point is image %f", obj.width);
            NSLog(@"draw Rect image location point is image %f", obj.height);
            
            // ##### Condition to Prevent Drawing in -X direction from Origin !!
            if(obj.originX < obj.width/2)
                obj.originX = obj.width/2;
            
            NSRect imageRect;
            imageRect = NSMakeRect(obj.originX-obj.width/2,obj.originY-obj.height/2,  obj.width ,obj.height);

            [[obj.imageObject getImage] compositeToPoint:NSMakePoint(obj.originX-obj.width/2,obj.originY-obj.height/2) operation:NSCompositeSourceOver];
            
            for (int  i= 0; i<[obj.collisionRectArray count]; i++)
            {
                //draw collision rectangle
                [[NSColor redColor] set];
                NSBezierPath  *temp =[NSBezierPath bezierPathWithRect:[[obj.collisionRectArray objectAtIndex:i] rectValue]];
                [temp fill];
                
                [[NSColor yellowColor]set];
                [_rectangle1 fill];
                [_rectangle2 fill];
                [_rectangle3 fill];
                [_rectangle4 fill];

            }

            
            if(isImageSelected)
            {
                    //draw image border
                    NSLog(@"draw Rect image location point is rect %f", object_LD.originX - object_LD.width/2);
                    NSLog(@"draw Rect image location point is rect %f", object_LD.originY -object_LD.height/2);
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

    /*if(![layerArray count]) return;
    if (isCollision )
    {
      
        //draw collision rectangle
        [[NSColor redColor] set];
        NSBezierPath  *temp =[NSBezierPath bezierPathWithRect:_rectangleStruct];
        [temp stroke];
        
        [[NSColor yellowColor]set];
        [_rectangle1 fill];
        [_rectangle2 fill];
        [_rectangle3 fill];
        [_rectangle4 fill];
    }*/
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
	if( _rectangle1 != newBezierPath)
	{
		[newBezierPath retain];
		[_rectangle1 release];
		_rectangle1 = newBezierPath;
		
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
    if (!isFirstTime)
    {
        defaultSize = self.frame.size.width;
        isFirstTime =YES;
    }
    
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) == NSDragOperationGeneric) 
    {
        return NSDragOperationGeneric;
    }
	
    // not a drag we can use
	return NSDragOperationNone;		
}


- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
    
    //set origin
    if (defaultSize<self.frame.size.width)
    {
        float diff = self.frame.size.width - defaultSize;
        location = [sender draggedImageLocation];
        location.x = location.x+diff;
    }
    else
    {
        location = [sender draggingLocation];
    }
    
    [newWrapperImage setOrigin:location];
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
        
        self.newWrapperImage=[[[WrapperImage alloc]init] autorelease];               //object of wrapperImage class which has a NSImage and origin associated with it
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
        NSArray *layerArrayReversed = [[layerArray reverseObjectEnumerator] allObjects];
        for(NSArray*object in layerArrayReversed)
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
    

    
    for (int i = 0; i<[object_LD.collisionRectArray count]; i++)
    {
        BOOL intersect = CGRectContainsPoint([[object_LD.collisionRectArray objectAtIndex:i] rectValue], CGPointMake( mouseLocationInView.x, mouseLocationInView.y));
        if (intersect)
        {
            [self updateShapeWithRect:[[object_LD.collisionRectArray objectAtIndex:i] rectValue]];
            RemoveIndex = i;
            break;
        }
    }

}



- (void)rightMouseDown:(NSEvent *)theEvent
{
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    [theMenu insertItemWithTitle:@"Add Collision" action:@selector(setCollision) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"Remove Collision" action:@selector(removeCollision) keyEquivalent:@"" atIndex:1];
    [NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
    [theMenu release];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint mouseLocationInWindow = [theEvent locationInWindow];
    NSPoint mouseLocationInView   = [self convertPoint:mouseLocationInWindow fromView:nil];
    NSPoint tempPoint ;
    
    
    
    if(isImageSelected)
    {
        
        tempPoint.x = object_LD.originX;
        tempPoint.y = object_LD.originY;

        object_LD.originX =  mouseLocationInView.x;
        object_LD.originY =  mouseLocationInView.y;
        
    }

    
    //set scalingfactor
    originPoints.x =object_LD.originX - object_LD.width/2;
    originPoints.y =object_LD.originY - object_LD.height/2;
    
    if(originPoints.x < 0)
        originPoints.x = 0;
    
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
        

       if(selectedREct == -1)
       {
        for (int i = 0; i<[object_LD.collisionRectArray count]; i++)
        {
            BOOL intersect = CGRectContainsPoint([[object_LD.collisionRectArray objectAtIndex:i] rectValue], CGPointMake( mouseLocationInView.x, mouseLocationInView.y));
            if (intersect)
            {
                [object_LD.collisionRectArray replaceObjectAtIndex:i withObject:[NSValue valueWithRect:newRect]];
                selectedREct = i;
                break;
            }
        }
       }
       if(selectedREct != -1)
       {
        [object_LD.collisionRectArray replaceObjectAtIndex:selectedREct withObject:[NSValue valueWithRect:newRect]];
        [self updateShapeWithRect:newRect];
        [self setNeedsDisplayInRect:newRect];
       }
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
    
    
    if (!_isRectResize && isImageSelected)
    {
//        NSPoint point;
//        point.x = _rectangleStruct.origin.x -  tempPoint.x;
//        point.y =_rectangleStruct.origin.y -  tempPoint.y;
        
        if(newRect.origin.x == 0&&newRect.origin.y==0)
        {
            newRect.origin.x = originPoints.x;
            newRect.origin.y = originPoints.y+ object_LD.height;
        }
        
//        _rectangleStruct.origin.x =  object_LD.originX + _rectangleStruct.origin.x -  tempPoint.x;
//        _rectangleStruct.origin.y =  object_LD.originY + _rectangleStruct.origin.x -  tempPoint.y;
        

        for (int i = 0; i<[object_LD.collisionRectArray count]; i++)
        {

            NSRect rect = [[object_LD.collisionRectArray objectAtIndex:i] rectValue];
            rect.size.width = [[object_LD.collisionRectArray objectAtIndex:i] rectValue].size.width;
            rect.size.height = [[object_LD.collisionRectArray objectAtIndex:i] rectValue].size.height;
            rect.origin.x = [[object_LD.collisionRectArray objectAtIndex:i] rectValue].origin.x +object_LD.originX - tempPoint.x;
            rect.origin.y = [[object_LD.collisionRectArray objectAtIndex:i] rectValue].origin.y +object_LD.originY - tempPoint.y;

            [object_LD.collisionRectArray replaceObjectAtIndex:i withObject:[NSValue valueWithRect:rect]];
            [self updateShapeWithRect:[[object_LD.collisionRectArray objectAtIndex:i] rectValue]];
        }
        
        //[self updateShapeWithRect:_rectangleStruct];
        

    }
    
    
    //setting origin for the only image which has been clicked in mouseDown instead of again iterating over the whole image array r
    

    
    
	[self setNeedsDisplay:YES];
    
    //call delegate method for mouse events
    if (delegate && [delegate respondsToSelector:@selector(doStuff:)])
    {
    [delegate doStuff:theEvent];
    }
    return;
}

- (void)mouseUp:(NSEvent *)pTheEvent
{
    
    /*if( _isRectResize )
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
	}*/
     selectedREct = -1;
    isImageSelected = NO;
    return;
}


#pragma mark - z-Order


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


#pragma mark - add object in array

// method for adding object in array
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
    
    if (self.frame.size.height<[newWrapperImage getImage].size.height)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,[newWrapperImage getImage].size.height );
    }
}


#pragma mark - set delegate
//set delegate
- (void)setDelegate:(id<MyViewDelegate>)_delegate
{
    delegate = _delegate;
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


#pragma mark - collision methods


-(void)setCollision
{
    NSRect dirtyRect;
    dirtyRect = NSMakeRect(object_LD.originX - object_LD.width/2, object_LD.originY ,  object_LD.width/2 ,object_LD.height/2);
    collisionRect.size.width  =  object_LD.width/2;
    collisionRect.size.height =  object_LD.height/2;
    [object_LD.collisionRectArray addObject:[NSValue valueWithRect:dirtyRect]];
    [self updateShapeWithRect:dirtyRect];
    [self setNeedsDisplay:YES];
	
}



//remove collision from object
-(void)removeCollision
{
    if([object_LD.collisionRectArray count] )
    {
        [object_LD.collisionRectArray removeObjectAtIndex:RemoveIndex];
        [self setNeedsDisplay:YES];
    }
}


#pragma mark - menu methods


//clear previous data
-(void)clearData
{
    [topLayerArray removeAllObjects];
    [middleLayerArray removeAllObjects];
    [bottomLayerArray removeAllObjects];
    [self setNeedsDisplay:YES];
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

//remove all objects 
-(void)resetView
{
    [layerArray removeAllObjects];
    [self setNeedsDisplay:YES];
}



#pragma mark - method for zoom

float y =1;
- (void)scrollWheel:(NSEvent *)theEvent
{
    
    
    if ([theEvent deltaY] >0.0)
    {
        [self zoom:y event:theEvent];
        y= y+.01;

    }
    else if([theEvent deltaY] <0.0)
    {
        if (y>.5)
        {
            [self zoom:y event:theEvent];
            y= y-.01;

        }

    }

}

static const NSSize unitSize = {1.5, 1.5};

// Returns the scale of the receiver's coordinate system, relative to the window's base coordinate system.
- (NSSize)scale;
{
    return [self convertSize:unitSize toView:nil];
}

// Sets the scale in absolute terms.
- (void)setScale:(NSSize)newScale;
{
    [self resetScaling]; // First, match our scaling to the window's coordinate system
    [self scaleUnitSquareToSize:newScale]; // Then, set the scale.
    [self setNeedsDisplay:YES]; // Finally, mark the view as needing to be redrawn
}

// Makes the scaling of the receiver equal to the window's base coordinate system.
- (void)resetScaling;
{
    [self scaleUnitSquareToSize:[self convertSize:unitSize fromView:nil]];
}


- (void)setZoom:(CGFloat)scaleFactor {
//    NSRect frame = [self frame];
//    NSRect bounds = [self bounds];
//    frame.size.width = bounds.size.width * scaleFactor;
//    frame.size.height = bounds.size.height * scaleFactor;

    //[self setFrameSize: frame.size];    // Change the view's size.
    
    //[self scaleUnitSquareToSize:NSMakeSize(1000, 1000)];
    //[self setBoundsSize: bounds.size];
    NSSize sz = NSSizeFromString(@"{1.75,1.75}");
    [self scaleUnitSquareToSize:sz];
    [self  setNeedsDisplay:YES];
}


-(void)zoom:(float)newFactor event:(NSEvent *)mouseEvent
{
    //self.frame = NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width*newFactor, self.frame.size.height*newFactor);

    
    NSScrollView *scrollView = obj_TSController.scrollView;
    NSClipView *clipView = [scrollView contentView];
    NSRect clipViewBounds = [clipView bounds];
    NSSize clipViewSize = [clipView frame].size;
    
    NSPoint clipLocalPoint = [clipView convertPoint:[mouseEvent
                                                     locationInWindow] fromView:nil];
    
    float xFraction = ( clipLocalPoint.x - clipViewBounds.origin.x ) /
    clipViewBounds.size.width;
    float yFraction = ( clipLocalPoint.y - clipViewBounds.origin.y ) /
    clipViewBounds.size.height;
    
    clipViewBounds.size.width = clipViewSize.width / newFactor;
    clipViewBounds.size.height = clipViewSize.height / newFactor;
    
    clipViewBounds.origin.x = clipLocalPoint.x - ( xFraction *
                                                  clipViewBounds.size.width );
    clipViewBounds.origin.y = clipLocalPoint.y - ( yFraction *
                                                  clipViewBounds.size.height );
    
    [clipView setBounds:clipViewBounds];
    
    
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
