//
//  SKScanOptionInt.m
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOptionInt.h"


@implementation SKScanOptionInt

-(id) initWithIntValue:(NSInteger) anInt optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	self = [super initWithName: theName andIndex: theIndex];
    if (self)
    {
    	value = [[NSNumber numberWithInt: anInt] retain];
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
    intValue = [(NSNumber*)value intValue];
    return &intValue;
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


-(BOOL) isInteger
{
	return YES;
}


-(void) setIntegerValue:(NSInteger) anInteger
{
    NSNumber* parameter = [NSNumber numberWithInt: anInteger];
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
