//
//  SKScanOptionInt.h
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOption.h"

@protocol SKRange;

@interface SKScanOptionInt : SKScanOption
{
    NSNumber* value;
	NSInteger intValue;
    NSArray* numericConstraints;
    id<SKRange> rangeConstraint;
}

-(id) initWithIntValue:(NSInteger) anInt optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(void) dealloc;

-(NSString*) description;

-(void*) value;

-(void) setRangeConstraint:(id<SKRange>) aRange;
-(id<SKRange>) rangeConstraint;

-(void) setNumericConstraints:(NSArray*) anArray;
-(NSArray*) numericConstraints;

-(BOOL) isInteger;

-(void) setIntegerValue:(NSInteger) anInteger;

@end
