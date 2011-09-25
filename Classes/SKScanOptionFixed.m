//
//  SKScanOptionFixed.m
//  SaneKit
//
//  Created by MK on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOptionFixed.h"
#include <sane/sane.h>


@implementation SKScanOptionFixed

-(id) initWithFixedValue:(NSInteger) aFixed optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	self = [super initWithName: theName andIndex: theIndex];
    if (self)
    {
    	value = [[NSNumber numberWithDouble: SANE_UNFIX(aFixed)] retain];
    }
    return self;
}


-(void) dealloc
{
    if (value)
    {
        [value release];
        value = nil;
    }
    
    [super dealloc];
}



-(NSString*) description
{
	return [NSString stringWithFormat:@"Option: %@, Value: %@[%@]: %@", name, value, unitString, numericConstraints];
}


-(void*) value
{
    fixedValue = SANE_FIX([(NSNumber*)value doubleValue]);
    return &fixedValue;
}


-(void) setNumericConstraints:(NSArray*) anArray
{
    NSEnumerator* anEnumerator = [anArray objectEnumerator];
    id anObject = nil;
    while (anObject = [anEnumerator nextObject]) {
        if (! [anObject isKindOfClass: [NSNumber class]] )
        {
            [NSException raise: @"WrongArgumentType"
                        format: @"This method needs an array of NSNumber values as parameter"];
        }
    }

    if (numericConstraints)
        [numericConstraints release];
    numericConstraints = [anArray retain];
}


-(NSArray*) numericConstraints
{
    return [[numericConstraints retain] autorelease];
}


-(BOOL) isDouble
{
	return YES;
}


-(void) setDoubleValue:(double) aDouble
{
    if (readOnly || inactive)
    {
        NSLog(@"Trying to set readonly/inactive option %@", title);
        return;
    }
    
    NSNumber* parameter = [NSNumber numberWithDouble: aDouble];
    if (numericConstraints && ![numericConstraints containsObject: parameter])
    {
        [NSException raise: @"WrongArgument"
                    format: @"The parameter needs to be one of %@ but is (%@)", numericConstraints, parameter];
    }
    if (value)
        [value release];
    value = [parameter retain];
}

@end
