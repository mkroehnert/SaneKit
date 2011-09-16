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
	[value release];
    
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
    if (value)
        [value release];
    value = [[NSNumber numberWithInt: anInteger] retain];
}

@end
