//
//  SKScanOptionString.h
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOption.h"


@interface SKScanOptionString : SKScanOption
{
    NSString* value;
    const char* stringValue;
    NSArray* stringConstraints;
}

-(id) initWithStringValue:(NSString*) aString optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(void) dealloc;

-(NSString*) description;

-(void*) value;

-(void) setStringConstraints:(NSArray*) anArray;
-(NSArray*) stringConstraints;

-(BOOL) isString;

@end
