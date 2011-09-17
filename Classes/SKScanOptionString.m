//
//  SKScanOptionString.m
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOptionString.h"


@implementation SKScanOptionString

-(id) initWithStringValue:(NSString*) aString optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	self = [super initWithName: theName andIndex: theIndex];
    if (self)
    {
    	value = [aString retain];
        stringConstraints = nil;
    }
    return self;
}


-(void) dealloc
{
	[value release];
    if (stringConstraints)
        [stringConstraints release];

    [super dealloc];
}


-(NSString*) description
{
	return [NSString stringWithFormat:@"Option: %@, Value: %@[%@]: %@", name, value, unitString, stringConstraints];
}


-(void*) value
{
	stringValue = [(NSString*)value UTF8String];
    return (void*)stringValue;
}


-(void) setStringConstraints:(NSArray*) anArray
{
    NSEnumerator* anEnumerator = [anArray objectEnumerator];
    id anObject = nil;
    while (anObject = [anEnumerator nextObject]) {
        if (! [anObject isKindOfClass: [NSString class]] )
        {
            NSException* exception = [NSException exceptionWithName: @"WrongArgumentType"
                                                             reason: @"This method needs an array of String values as parameter"
                                                           userInfo: nil];
            [exception raise];
        }
    }

    if (stringConstraints)
        [stringConstraints release];
    stringConstraints = [anArray retain];
}


-(NSArray*) stringConstraints
{
    return [[stringConstraints retain] autorelease];
}


-(BOOL) isString
{
	return YES;
}


-(void) setStringValue:(NSString*) aString
{
    if (value)
        [value release];
	value = [aString retain];
}

@end
