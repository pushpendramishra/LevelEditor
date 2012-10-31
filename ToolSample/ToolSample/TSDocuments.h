//
//  TSDocuments.h
//  ToolSample
//
//  Created by prashant shukla on 31/10/12.
//  Copyright (c) 2012 prashant shukla. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "masterView.h"

@interface TSDocuments : NSDocument

{
    masterView  *temp;
}

@property(nonatomic ,retain) masterView  *temp;

@end
