//
//  SKScanDevice.h
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

struct SaneHandle;
@class SKScanParameters;
@class SKScanOption;

@interface SKScanDevice : NSObject {
    NSString* name;
    NSString* vendor;
    NSString* model;
    NSString* type;
    struct SaneHandle* handle;
    NSMutableDictionary* options;
}

-(id) initWithName:(NSString*) aName vendor:(NSString*) aVendor model:(NSString*) aModel type:(NSString*) aType;
-(void) dealloc;
-(NSString*) description;

-(BOOL) open;
-(void) close;

-(NSArray*) doScan;

-(SKScanParameters*) scanParameters;
-(NSArray*) scanOptions;
-(BOOL) setScanOption:(SKScanOption*) theOption;

-(BOOL) setMode:(NSString*) theMode;
-(BOOL) setDepth:(NSInteger) theDepth;
-(BOOL) setResolution:(NSInteger) theResolution;
-(BOOL) setPreview:(BOOL) doPreview;
-(BOOL) setScanRect:(NSRect) scanRect;
-(NSRect) maxScanRect;

@end
