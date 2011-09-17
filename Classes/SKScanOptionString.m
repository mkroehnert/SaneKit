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
    if (value)
    {
        [value release];
        value = nil;
    }
    if (stringConstraints)
    {
        [stringConstraints release];
        stringConstraints = nil;
    }

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
            [NSException raise: @"WrongArgumentType"
                        format: @"This method needs an array of String values as parameter"];
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
    if (readOnly || inactive)
    {
        NSLog(@"Trying to set readonly/inactive option %@", title);
        return;
    }
    
    if (stringConstraints && ![stringConstraints containsObject: aString])
    {
        [NSException raise: @"WrongArgument"
                    format: @"The parameter needs to be one of %@ but is (%@)", stringConstraints, aString];
    }
    if (value)
        [value release];
	value = [aString retain];
}

@end
