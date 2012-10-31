//
//  TSController.h
//  ToolSample
//
//  Created by prashant shukla on 19/10/12.
//  Copyright (c) 2012 prashant shukla. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>

@protocol MyViewDelegate
- (void)doStuff:(NSEvent *)event;
@end


@class masterView;
@interface TSController : NSObject <MyViewDelegate>

{
    //IbOutlet
    IBOutlet IKImageBrowserView                 	*imageBrowser;
    IBOutlet NSWindow                               *popupWindow;
    IBOutlet NSComboBox                             *dropDownList;
    IBOutlet NSButton                            	*checkBoxshow;
    IBOutlet NSButton                            	*checkBoxCollision;
    IBOutlet NSButton                            	*imageButton;
    IBOutlet NSTabView                            	*tabView;
    IBOutlet NSTextField                            *xPositionField;
    IBOutlet NSTextField                            *yPositionField;

    
    //Array
    NSMutableArray                  				*images;
    NSMutableArray                                  *importedImages;
    
    //
    masterView                                      *object;
    NSPoint                                         scalingFactor;
    int                                             check;
    NSInteger                                       selectedTab;
}

@property (assign) IBOutlet NSWindow                *window;
@property (assign) IBOutlet masterView              *object;
@property (nonatomic,retain) IBOutlet NSTabView     *tabView;
@property (nonatomic,assign) NSInteger              selectedTab;

//other methods
- (void)fetchedFiles:(NSArray*)path;


//action
- (IBAction)collision:(id)sender;
- (IBAction)addImageButtonClicked:(id)sender;
- (IBAction)segmentSwitch:(id)sender;
- (IBAction)placeImages:(id)sender;
- (IBAction)comboBox:(id)sender;
- (IBAction)checkBox:(id)sender;
- (IBAction)newFile:(id)sender;
- (IBAction)openFile:(id)sender;
- (IBAction)saveFile:(id)sender;
- (IBAction)tabView:(id)sender;



- (void)doStuff:(NSEvent *)event;
@end
