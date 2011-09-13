//
//  SKScanOption.m
//  SaneKit
//
//  Created by MK on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOption.h"
#import "SKScanOptionBool.h"
#import "SKScanOptionInt.h"
#import "SKScanOptionString.h"


@implementation SKScanOption

-(id) initWithName:(NSString*) aName andIndex:(NSInteger) anIndex
{
	self = [super init];
    if (self)
    {
    	name = [aName retain];
        title = @"";
        explanation = @"";
        index = anIndex;
        unitString = @"";
    }
    return self;
}


-(void) dealloc
{
	[name release];
	[title release];
	[explanation release];
    [unitString release];
    
    [super dealloc];
}


-(id) initWithIntValue:(NSInteger) anInt optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	[self release];
    return [[SKScanOptionInt alloc] initWithIntValue: anInt
                                          optionName: theName
                                         optionIndex: theIndex];
}


-(id) initWithBoolValue:(BOOL) aBool optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	[self release];
    return [[SKScanOptionBool alloc] initWithBoolValue: aBool
                                            optionName: theName
                                           optionIndex: theIndex];
}


-(id) initWithCStringValue:(const char*) aCString optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	[self release];
    return [[SKScanOptionString alloc] initWithStringValue: [NSString stringWithCString: aCString]
                                                optionName: theName
                                               optionIndex: theIndex];
}


-(id) initWithStringValue:(NSString*) aString optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	[self release];
    return [[SKScanOptionString alloc] initWithStringValue: aString
                                                optionName: theName
                                               optionIndex: theIndex];
}


-(void) setUnitString:(NSString*) aUnit
{
	if (!aUnit)
        return;
    if (unitString && NSOrderedSame == [unitString compare: aUnit])
        return;
    [unitString release];
    unitString = [aUnit retain];
}


-(NSString*) unitString
{
	return unitString;
}


/**
 * Set the title member to the value provided by the parameter theTitle.
 */
-(void) setTitle:(NSString*) theTitle
{
	if (!theTitle)
        return;
    if (title && NSOrderedSame == [title compare: theTitle])
        return;
    [title release];
    title = [theTitle retain];
}


/**
 * @return NSString instance containing the short title of the option
 */
-(NSString*) title;
{
	return title;
}


-(void*) value
{
    NSException* exception = [NSException exceptionWithName: @"SubclassResponsibility"
                                                     reason: @"Method should be implemented by subclass"
                                                   userInfo: nil];
    [exception raise];
    return NULL;
}


-(NSInteger) index
{
	return index;
}


-(BOOL) isBool
{
	return NO;
}


-(BOOL) isInt
{
	return NO;
}


-(BOOL) isString
{
	return NO;
}

@end
