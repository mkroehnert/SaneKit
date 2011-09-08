//
//  SKScanOption.h
//  SaneKit
//
//  Created by MK on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SKScanOption : NSObject {
    NSString* name;
    NSInteger index;
    id value;
}

-(id) initWithName:(NSString*) aName andIndex:(NSInteger) anIndex andValue:(id) aValue;
-(void) dealloc;

-(NSString*) description;

@end
