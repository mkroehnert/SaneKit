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
	return [NSString stringWithFormat:@"Option: %@, Value: %@[%@]", name, value, unitString];
}


-(void*) value
{
    intValue = [(NSNumber*)value intValue];
    return &intValue;
}


-(BOOL) isInt
{
	return YES;
}


@end
