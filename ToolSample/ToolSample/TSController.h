//
//  TSController.h
//  ToolSample
//
//  Created by prashant shukla on 19/10/12.
//  Copyright (c) 2012 prashant shukla. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <Cocoa/Cocoa.h>

// ###### Custom Protocol #######
@protocol MyViewDelegate
- (void)doStuff:(NSEvent *)event;


@end

// ###### Forward Class Declaration ########
@class MasterView;


@interface TSController : NSObject <MyViewDelegate,NSAlertDelegate>
{
    //IBOutlet
    IBOutlet IKImageBrowserView                 	*imageBrowser;
    IBOutlet NSScrollView                 	        *scrollView;
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
    MasterView                                      *masterView_object;
    NSPoint                                         scalingFactor;
    NSInteger                                       selectedTab;
    NSTimer                                         *t_AnimationTimer;
}

@property (assign) IBOutlet NSWindow                *window;
@property (assign) IBOutlet MasterView              *masterView_object;
@property (nonatomic,retain) IBOutlet NSTabView     *tabView;
@property (nonatomic,retain) IBOutlet NSScrollView  *scrollView;
@property (nonatomic,assign) NSInteger              selectedTab;

// ######## Supporting Methods !!
- (void)fetchedFiles:(NSArray*)path;


// ########  Actions Events !!
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


// ####### Protocol Methods !!
- (void)doStuff:(NSEvent *)event;


@end
