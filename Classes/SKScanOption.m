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
        emulated = NO;
        autoSelect = NO;
        inactive = NO;
        advanced = NO;
    }
    return self;
}


-(void) dealloc
{
    if (name)
    {
        [name release];
        name = nil;
    }
    if (title)
    {
        [title release];
        title = nil;
    }
    if (explanation)
    {
        [explanation release];
        explanation = nil;
    }
    if (unitString)
    {
        [unitString release];
        unitString = nil;
    }
    
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
 * @return the option name (unique identifier)
 */
-(NSString*) name
{
	return name;
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
    [NSException raise: @"SubclassResponsibility"
                format: @"Method should be implemented by subclass"];
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
 * Set the value of the parameter aRange as the range constraint on this option.
 * Throws an exception if it is not supported by the current option type.
 */
-(void) setRangeConstraint:(id) aRange
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing Int/Fixed values"];
}


/**
 * @return range constraint of current option (throws exception if not supported by current option type)
 */
-(id) rangeConstraint
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing Int/Fixed values"];
    return nil;
}


/**
 * Set array containing numbers as the constraint values.
 * Throws an exception if it is not supported by the current option type.
 */
-(void) setNumericConstraints:(NSArray*) anArray
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing Int/Fixed values"];
}


/**
 * @return NSArray containing possible numeric values for this option (throws exception if not supported by current option type)
 */
-(NSArray*) numericConstraints
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing Int/Fixed values"];
    return nil;
}


/**
 * Set array containing strings as the constraint values.
 * Throws an exception if it is not supported by the current option type.
 */
-(void) setStringConstraints:(NSArray*) anArray
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing String values"];
}


/**
 * @return NSArray containing possible string values for this option (throws exception if not supported by current option type)
 */
-(NSArray*) stringConstraints
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing String values"];
    return nil;
}


/**
 * @return YES if the option stores a BOOL
 */
-(BOOL) isBool
{
	return NO;
}


/**
 * @return YES if option stores an Integer
 */
-(BOOL) isInteger
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
 * This method stores the parameter aBool as the option value if it can store BOOL values.
 * In any other case an exception is thrown.
 */
-(void) setBoolValue:(BOOL) aBool
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing Bool values"];
}


/**
 * This method stores the parameter anInt as the option value if it can store Integer values.
 * In any other case an exception is thrown.
 */
-(void) setIntegerValue:(NSInteger) anInteger
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing Integer values"];
}


/**
 * This method stores the parameter aString as the option value if it can store strings.
 * In any other case an exception is thrown.
 */
-(void) setStringValue:(NSString*) aString
{
    [NSException raise: @"WrongOptionType"
                format: @"This method can only be called on options storing String values"];
}


/**
 * Set member readOnly to value of parameter aBool.
 *
 * @warning This method should not be used by the user of SaneKit
 */
-(void) setReadOnly:(BOOL) aBool
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


/**
 * Set member emulated to value of parameter aBool.
 *
 * @warning This method should not be used by the user of SaneKit
 */
-(void) setEmulated:(BOOL) aBool
{
	emulated = aBool;
}


/**
 * @return YES if this option is emulated in software by the backend
 */
-(BOOL) isEmulated;
{
	return emulated;
}


/**
 * Set member autoSelect to value of parameter aBool.
 *
 * @warning This method should not be used by the user of SaneKit
 */
-(void) setAutoSelect:(BOOL) aBool
{
	autoSelect = aBool;
}


/**
 * @return YES if the device can automatically figure out a value for this option
 */
-(BOOL) isAutoSelect;
{
	return autoSelect;
}


/**
 * Set member inactive to value of parameter aBool.
 *
 * @warning This method should not be used by the user of SaneKit
 */
-(void) setInactive:(BOOL) aBool
{
	inactive = aBool;
}


/**
 * @return YES if option is currently marked inactive
 */
-(BOOL) isInactive;
{
	return inactive;
}


/**
 * Set member advanced to value of parameter aBool.
 *
 * @warning This method should not be used by the user of SaneKit
 */
-(void) setAdvanced:(BOOL) aBool
{
	advanced = aBool;
}


/**
 * @return YES if option is an advanced feature
 */
-(BOOL) isAdvanced;
{
	return advanced;
}

@end
