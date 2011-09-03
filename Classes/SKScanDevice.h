//
//  SKScanDevice.h
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct SaneHandle;

@interface SKScanDevice : NSObject {
    NSString* name;
    NSString* vendor;
    NSString* model;
    NSString* type;
    struct SaneHandle* handle;
}

-(id) initWithName:(NSString*) aName vendor:(NSString*) aVendor model:(NSString*) aModel type:(NSString*) aType;
-(void) dealloc;
-(NSString*) description;

-(BOOL) open;
-(void) close;

@end
