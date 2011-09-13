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
        readOnly = NO;
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


/**
 * Set the unitString member to the value provided by parameter aUnit.
 */
-(void) setUnitString:(NSString*) aUnit
{
	if (!aUnit)
        return;
    if (unitString && NSOrderedSame == [unitString compare: aUnit])
        return;
    [unitString release];
    unitString = [aUnit retain];
}


/**
 * @return NSString instance containing the textual description of the options unit
 */
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


/**
 * Set the explanation member to the value provided by the parameter theExplanation.
 */
-(void) setExplanation:(NSString*) theExplanation
{
	if (!theExplanation)
        return;
    if (explanation && NSOrderedSame == [explanation compare: theExplanation])
        return;
    [explanation release];
    explanation = [theExplanation retain];
}


/**
 * @return NSString instance containing a more detailed explanation of the option ("\n" should be treated as paragraph delimiter)
 */
-(NSString*) explanation
{
	return explanation;
}


/**
 * This method returns a void pointer to the value stored for the option.
 * It can be used to set the value with sane_control_option().
 */
-(void*) value
{
    NSException* exception = [NSException exceptionWithName: @"SubclassResponsibility"
                                                     reason: @"Method should be implemented by subclass"
                                                   userInfo: nil];
    [exception raise];
    return NULL;
}


/**
 * @return the index number of the option as provided by the SANE backend
 */
-(NSInteger) index
{
	return index;
}


/**
 * @return YES if the option stores a BOOL
 */
-(BOOL) isBool
{
	return NO;
}


/**
 * @return YES if option stores an Int
 */
-(BOOL) isInt
{
	return NO;
}


/**
 * @return YES if option stores a string
 */
-(BOOL) isString
{
	return NO;
}


/**
 * Set member readOnly to value of parameter aBool.
 *
 * @warning This method should not be used by the user of SaneKit
 */
-(void) setReadOnly: (BOOL) aBool
{
	readOnly = aBool;
}


/**
 * @return YES if the option provides read only values
 */
-(BOOL) isReadOnly
{
	return readOnly;
}

@end
