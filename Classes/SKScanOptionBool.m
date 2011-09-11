//
//  SKScanOptionBool.m
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOptionBool.h"

#include <sane/sane.h>


@implementation SKScanOptionBool

-(id) initWithBoolValue:(BOOL) aBool optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	self = [super initWithName: theName andIndex: theIndex];
    if (self)
    {
    	value = [[NSNumber numberWithBool: aBool] retain];
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
	return [NSString stringWithFormat:@"Option: %@, Value: %@", name, value];
}


-(void*) value
{
	boolValue = (YES == [(NSNumber*) value boolValue]) ? SANE_TRUE : SANE_FALSE;
    return &boolValue;
}


-(BOOL) isBool
{
	return YES;
}

@end
