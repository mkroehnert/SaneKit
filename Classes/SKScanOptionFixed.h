//
//  SKScanOptionFixed.h
//  SaneKit
//
//  Created by MK on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOption.h"

@protocol SKRange;

@interface SKScanOptionFixed : SKScanOption
{
    NSNumber* value;
	NSInteger fixedValue;
    NSArray* numericConstraints;
    id<SKRange> rangeConstraint;
}

-(id) initWithFixedValue:(NSInteger) aFixed optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(void) dealloc;

-(NSString*) description;

-(void*) value;

-(void) setRangeConstraint:(id<SKRange>) aRange;
-(id<SKRange>) rangeConstraint;

-(void) setNumericConstraints:(NSArray*) anArray;
-(NSArray*) numericConstraints;

-(BOOL) isDouble;

-(void) setDoubleValue:(double) aDouble;

@end
