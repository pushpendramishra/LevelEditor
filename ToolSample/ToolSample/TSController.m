//
//  TSController.m
//  ToolSample
//
//  Created by prashant shukla on 19/10/12.
//  Copyright (c) 2012 prashant shukla. All rights reserved.
//

#import "TSController.h"



// C function that opens NSOpenPanel and returns an array of file paths.	It uses uniform type identifiers (UTIs) for proper filtering of image files.
static NSArray* openFiles()
{
	// Get a list of extensions to filter in our NSOpenPanel.
	NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
	[panel setAllowsMultipleSelection:YES];
	
	if ([panel runModalForTypes:[NSImage imageUnfilteredTypes]] == NSOKButton)
		return [panel filenames];
    
    return nil;
}


static NSArray* fetchFiles()
{
	NSOpenPanel *panel = [[NSOpenPanel openPanel] retain];
    
    // Configure your panel the way you want it
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
    
    if ([panel runModalForTypes:[NSArray arrayWithObject:@"txt"]] == NSOKButton)
		return [panel filenames];
    
    return nil;
}

// data source object.
@interface myImageObject : NSObject
{
    NSString* path;
}
@end

@implementation myImageObject

- (void)dealloc
{
    [path release];

    [super dealloc];
}

//	The data source object is just a file path representation
- (void)setPath:(NSString*)inPath
{
    if (path != inPath)
	{
        [path release];
        path = [inPath retain];
    }
}

// The required methods of the IKImageBrowserItem protocol.
#pragma mark -
#pragma mark item data source protocol


//	Set up the image browser to use a path representation.
- (NSString*)imageRepresentationType
{
	return IKImageBrowserPathRepresentationType;
}

//	Give the path representation to the image browser.
- (id)imageRepresentation
{
	return path;
}

//	Use the absolute file path as the identifier.
- (NSString*)imageUID
{
    return path;
}

//	Use the last path component as the title.
- (NSString*)imageTitle
{
    return [[path lastPathComponent] stringByDeletingPathExtension];
}

//	Use the file extension as the subtitle.
- (NSString*)imageSubtitle
{
    return [path pathExtension];
}

@end

#import "masterView.h"


@implementation TSController

@synthesize object;
@synthesize tabView;
@synthesize selectedTab;



- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)dealloc
{
    [images release];
    [importedImages release];
    tabView = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
    NSSize masterViewSize=object.frame.size;
    scalingFactor.x=320/masterViewSize.width;
    scalingFactor.y=480/masterViewSize.height;
	// Create two arrays : The first is for the data source representation. The second one contains temporary imported images  for thread safeness.
    
    [object setDelegate:self];
    
    //
    object.obj_TSController = self;
    images = [[NSMutableArray alloc] init];
    
    importedImages = [[NSMutableArray alloc] init];
    
    [object setBackgroundFilters:[NSArray arrayWithObject:[NSColor colorWithCalibratedWhite:0.5 alpha:1]]];
    
    check =1;
    
    // Allow reordering, animations and set the dragging destination delegate.
    [imageBrowser setAllowsReordering:YES];
    [imageBrowser setAnimates:YES];
    [imageBrowser setDraggingDestinationDelegate:self];
	
	[imageBrowser setCellsStyleMask:IKCellsStyleTitled | IKCellsStyleOutlined];
	
	[imageBrowser setIntercellSpacing:NSMakeSize(10, 10)];      //intercell spacing
	
	[imageBrowser setValue:[NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1.0] forKey:IKImageBrowserSelectionColorKey];   //change selection text color
	
	[imageBrowser setZoomValue:0.5];
    
    
    //set
    
    int   index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue] ;
    NSLog(@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]);
    NSString  *tabName;
    
    if(index ==1 && [[NSUserDefaults standardUserDefaults] objectForKey:@"props"] != nil)
    {
        tabName= @"props";
    }
    else if (index ==2 && [[NSUserDefaults standardUserDefaults] objectForKey:@"layers"] != nil)
    {
        tabName= @"layers";
    }
    else
    {
        tabName= @"tiles";
    }
    [NSThread detachNewThreadSelector:@selector(addImagesWithPaths:) toTarget:self withObject:[[NSUserDefaults standardUserDefaults] objectForKey:tabName]];
}


- (BOOL)acceptsFirstResponder
{
    return YES;
}

//	This is the entry point for reloading image browser data and triggering setNeedsDisplay.
- (void)updateDatasource
{
    // Update the datasource, add recently imported items.
    [images addObjectsFromArray:importedImages];
	
	// Empty the temporary array.
    [importedImages removeAllObjects];

    // Reload the image browser, which triggers setNeedsDisplay.
    [imageBrowser reloadData];
}

#pragma mark -
#pragma mark import images from file system

//	isImageFile:filePath
//	This utility method indicates if the file located at 'filePath' is	an image file based on the UTI. It relies on the ImageIO framework for the supported type identifiers.

- (BOOL)isImageFile:(NSString*)filePath                     //check for the file whether is image file or not
{
	BOOL				isImageFile = NO;
	LSItemInfoRecord	info;
	CFStringRef			uti = NULL;
	
	CFURLRef url = CFURLCreateWithFileSystemPath(NULL, (CFStringRef)filePath, kCFURLPOSIXPathStyle, FALSE);
	
	if (LSCopyItemInfoForURL(url, kLSRequestExtension | kLSRequestTypeCreator, &info) == noErr)
	{
		// Obtain the UTI using the file information.
		
		// If there is a file extension, get the UTI.
		if (info.extension != NULL)
		{
			uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, info.extension, kUTTypeData);
			CFRelease(info.extension);
		}
        
		// No UTI yet
		if (uti == NULL)
		{
			// If there is an OSType, get the UTI.
			CFStringRef typeString = UTCreateStringForOSType(info.filetype);
			if ( typeString != NULL)
			{
				uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassOSType, typeString, kUTTypeData);
				CFRelease(typeString);
			}
		}
		
		// Verify that this is a file that the ImageIO framework supports.
		if (uti != NULL)
		{
			CFArrayRef  supportedTypes = CGImageSourceCopyTypeIdentifiers();
			CFIndex		i, typeCount = CFArrayGetCount(supportedTypes);
            
			for (i = 0; i < typeCount; i++)
			{
				if (UTTypeConformsTo(uti, (CFStringRef)CFArrayGetValueAtIndex(supportedTypes, i)))
				{
					isImageFile = YES;
					break;
				}
			}
		}
	}
	
	return isImageFile;
}




- (void)addAnImageWithPath:(NSString*)path
{
	BOOL addObject = NO;
	
	NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
	if (fileAttribs)
	{
		// Check for packages.
		if ([NSFileTypeDirectory isEqualTo:[fileAttribs objectForKey:NSFileType]])
		{
			if ([[NSWorkspace sharedWorkspace] isFilePackageAtPath:path] == NO)
				addObject = YES;	// If it is a file, it's OK to add.
		}
		else
		{
			addObject = YES;	// It is a file, so it's OK to add.
		}
	}
	
	if (addObject && [self isImageFile:path])
	{
		// Add a path to the temporary images array.
		myImageObject* p = [[myImageObject alloc] init];
		[p setPath:path];
        NSLog(@"hey file array %@ ",p);
		[importedImages addObject:p];
		[p release];
	}
}

//	addImagesWithPath:path:recursive
- (void)addImagesWithPath:(NSString*)path
{
    BOOL dir;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir];
    
    if (dir)
	{
		NSInteger i, n;
		
		NSArray* content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        n = [content count];
        
		// Parse the directory content.
        for (i = 0; i < n; i++)
		{
			[self addAnImageWithPath:[path stringByAppendingPathComponent:[content objectAtIndex:i]]];
        }
    }
    else
	{
		[self addAnImageWithPath:path];
	}
}


//	Performed in an independent thread, parse all paths in "paths" and	add these paths in the temporary images array.
- (void)addImagesWithPaths:(NSArray*)paths
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    [paths retain];
    
    NSInteger i, n;
	n = [paths count];
    for (i = 0; i < n; i++)
	{
        NSString* path = [paths objectAtIndex:i];
		[self addImagesWithPath:path];
    }
    
	// Update the data source in the main thread.
    [self performSelectorOnMainThread:@selector(updateDatasource) withObject:nil waitUntilDone:YES];
    
    [paths release];
    [pool release];
}


- (void)fetchedFiles:(NSArray*)path
{
    
}

#pragma mark -
#pragma mark actions

- (IBAction)placeImages:(id)sender
{
    [popupWindow makeKeyAndOrderFront:self];

}


- (IBAction)addImageButtonClicked:(id)sender
{
//    NSBundle *resourcesBundle = [[NSBundle mainBundle]init];
//    NSString *resourcesPathToApp = [resourcesBundle resourcePath];
//    NSString *resourcesPathToAppExtraInfo = @"/";
//    NSString *imageResourcesFolderPath = [resourcesPathToApp stringByAppendingString:resourcesPathToAppExtraInfo];
//    [self addImagesWithPaths:[NSArray arrayWithObject:imageResourcesFolderPath]];
    NSArray* path = openFiles();
    if (path)
	{
        if(selectedTab ==1 )
        {
            [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"props"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"props"]);
        }
        else if(selectedTab ==2 )
        {
            [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"layers"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"layers"]);
        }
        else if(selectedTab ==3 )
        {
            [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"tiles"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"tiles"]);
        }
        else
        {
            
        }
        [images removeAllObjects];
        [imageBrowser reloadData];
		[NSThread detachNewThreadSelector:@selector(addImagesWithPaths:) toTarget:self withObject:path];
	}

    
}


- (IBAction)segmentSwitch:(id)sender
{

}

- (IBAction)comboBox:(id)sender
{
    NSSize masterViewSize=object.frame.size;
    switch (((NSComboBox *)sender).indexOfSelectedItem)
    {
        case 0:
            //for iphone
            scalingFactor.x=(320/masterViewSize.width)*320;
            scalingFactor.y=(480/masterViewSize.height)*480;
            NSLog(@"iphone3");
            break;
        case 1:
            //for iphone
            scalingFactor.x=(640/masterViewSize.width)*640;
            scalingFactor.y=(960/masterViewSize.height)*960;
            NSLog(@"iphone4");
            break;
        case 2:
            //for iphone
            scalingFactor.x=640/masterViewSize.width;
            scalingFactor.y=1136/masterViewSize.height;
            NSLog(@"iphone5");
            break;
        case 3:
            //for ipad
            scalingFactor.x=1024/masterViewSize.width;
            scalingFactor.y=768/masterViewSize.height;
            NSLog(@"ipad2");
            break;
        case 4:
            //for ipad
            scalingFactor.x=2048/masterViewSize.width;
            scalingFactor.y=1536/masterViewSize.height;
            NSLog(@"ipad3");
            break;
        default:
            scalingFactor.x=480/masterViewSize.width;
            scalingFactor.y=320/masterViewSize.height;
            break;
    }

    

}


- (IBAction)checkBox:(id)sender
{
    if (checkBoxshow.state = 0)
    {
        NSLog(@"Hello");
    }
    else
    {
        NSLog(@"Hello");
    }
}

- (IBAction)newFile:(id)sender
{
    
}

- (IBAction)openFile:(id)sender
{
//    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
//    
//    if ([openPanel runModal] == NSOKButton)
//    {
//        NSString *selectedFileName = [openPanel filename];
//    }
//    
    
//    NSOpenPanel *panel = [[NSOpenPanel openPanel] retain];
//    
//    // Configure your panel the way you want it
//    [panel setCanChooseFiles:YES];
//    [panel setCanChooseDirectories:NO];
//    [panel setAllowsMultipleSelection:YES];
//    [panel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
//    
//    [panel beginWithCompletionHandler:^(NSInteger result){
//        if (result == NSFileHandlingPanelOKButton) {
//            
//            for (NSURL *fileURL in [panel URLs]) {
//                // Do what you want with fileURL
//                // ...
//            }
//        }
//        
//        [panel release];
//    }];
    
    
//    NSArray* path = fetchFiles();
//    if (path)
//	{
//                
//		[NSThread detachNewThreadSelector:@selector(fetchedFiles:) toTarget:self withObject:path];
//	}
    
    
    [object openData];
}

- (IBAction)saveFile:(id)sender
{
    [object saveData];
}


- (IBAction)tabView:(id)sender
{

}

- (IBAction)collision:(id)sender
{
    if (!object.isCollision)
    {
        object.isCollision =YES;
        [object setCollision];
    }
    else 
    {
        object.isCollision =NO;
        [object setCollision];
    }

    
}


#pragma mark -
#pragma mark IKImageBrowserDataSource

// Implement the image browser  data source protocol . The data source representation is a simple mutable array.

- (NSUInteger)numberOfItemsInImageBrowser:(IKImageBrowserView*)view
{
	// The item count to display is the datadsource item count.
    return [images count];
}

//	imageBrowser:view:index:
- (id)imageBrowser:(IKImageBrowserView *) view itemAtIndex:(NSUInteger) index
{
    return [images objectAtIndex:index];
}


// optional methods of the image browser  datasource protocol to allow for removing and reodering items.

//	removeItemsAtIndexes:	The user wants to delete images, so remove these entries from the data source.

- (void)imageBrowser:(IKImageBrowserView*)view removeItemsAtIndexes: (NSIndexSet*)indexes
{
	[images removeObjectsAtIndexes:indexes];
}

//	moveItemsAtIndexes:	The user wants to reorder images, update the datadsource and the browser	will reflect our changes.

- (BOOL)imageBrowser:(IKImageBrowserView*)view moveItemsAtIndexes: (NSIndexSet*)indexes toIndex:(unsigned int)destinationIndex
{
	NSInteger		index;
	NSMutableArray*	temporaryArray;
    
	temporaryArray = [[[NSMutableArray alloc] init] autorelease];
    
	// First remove items from the data source and keep them in a temporary array.
	for (index = [indexes lastIndex]; index != NSNotFound; index = [indexes indexLessThanIndex:index])
	{
		if (index < destinationIndex)
            destinationIndex --;
        
		id obj = [images objectAtIndex:index];
		[temporaryArray addObject:obj];
		[images removeObjectAtIndex:index];
	}
    
	// Then insert the removed items at the appropriate location.
	NSInteger n = [temporaryArray count];
	for (index = 0; index < n; index++)
	{
		[images insertObject:[temporaryArray objectAtIndex:index] atIndex:destinationIndex];
	}
    
	return YES;
}


#pragma mark -
#pragma mark tabview


- (void)tabView:(NSTabView *)tabView1 didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    NSTabViewItem* item = [tabView1 selectedTabViewItem];
    
    switch ([[item identifier] intValue])
    {
        case 0:
            NSLog(@"Tab 1");
            selectedTab =1;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"props"] == nil)
            {
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"props"]);
                [images removeAllObjects];
                [imageBrowser reloadData];

            }
            else
            {
                [images removeAllObjects];
                [NSThread detachNewThreadSelector:@selector(addImagesWithPaths:) toTarget:self withObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"props"]];
            }
            break;
        case 1:
            NSLog(@"Tab 2");
            selectedTab =2;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"layers"]== nil)
            {
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"layers"]);
                [images removeAllObjects];
                [imageBrowser reloadData];

            }
            else
            {
                [images removeAllObjects];
                [NSThread detachNewThreadSelector:@selector(addImagesWithPaths:) toTarget:self withObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"layers"]];
            }
            break;
        case 2:
            selectedTab =3;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tiles"] == nil)
            {
                [images removeAllObjects];
                [imageBrowser reloadData];
            }
            else
            {
                [images removeAllObjects];
                [NSThread detachNewThreadSelector:@selector(addImagesWithPaths:) toTarget:self withObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"tiles"]];
            }

            break;
        default:
            break;

    }
    [[NSUserDefaults standardUserDefaults] setInteger:selectedTab forKey:@"selectedIndex"];
}

#pragma mark -
#pragma mark drag n drop

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingEntered   ");
    
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingExited    ");
    [sender draggedImageLocation];
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingEnded   %lf ",[sender draggedImageLocation].x);
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    
    NSData*			data = nil;
    NSPasteboard*	pasteboard = [sender draggingPasteboard];
    
	// Look for paths on the pasteboard.
    if ([[pasteboard types] containsObject:NSFilenamesPboardType])
        data = [pasteboard dataForType:NSFilenamesPboardType];
    
    if (data)
	{
		NSString* errorDescription;
		
		// Retrieve  paths.
        NSArray* filenames = [NSPropertyListSerialization propertyListFromData:data
                                                              mutabilityOption:kCFPropertyListImmutable
                                                                        format:nil
                                                              errorDescription:&errorDescription];
        
		// Add paths to the data source.
		[self addImagesWithPaths:filenames];
		
		// Make the image browser reload the data source.
        [self updateDatasource];
    }
    
	// Accept the drag operation.
	return YES;
}

- (void)doStuff:(NSEvent *)event
{
    xPositionField.stringValue = [NSString stringWithFormat:@"%f",object.imagePoints.x];
    yPositionField.stringValue = [NSString stringWithFormat:@"%f",object.frame.size.height-object.imagePoints.y-object.object_LD.height];
}



@end
