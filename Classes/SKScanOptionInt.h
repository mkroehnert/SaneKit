//
//  SKScanOptionInt.h
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOption.h"

@class SKRange;

@interface SKScanOptionInt : SKScanOption
{
    NSNumber* value;
	NSInteger intValue;
    NSArray* numericConstraints;
    SKRange* rangeConstraint;
}

-(id) initWithIntValue:(NSInteger) anInt optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(void) dealloc;

-(NSString*) description;

-(void*) value;

-(void) setRangeConstraint:(SKRange*) aRange;
-(SKRange*) rangeConstraint;

-(void) setNumericConstraints:(NSArray*) anArray;
-(NSArray*) numericConstraints;

-(BOOL) isInteger;

-(void) setIntegerValue:(NSInteger) anInteger;

@end
