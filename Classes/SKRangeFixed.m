//
//  SKRangeFixed.m
//  SaneKit
//
//  Created by MK on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKRangeFixed.h"

#define EPSILON 0.0001

@implementation SKRangeFixed

/**
 * Initialise the range with @p theMinimum and @p theMaximum and set quantisation to 0.
 */
-(id) initWithDoubleMinimum:(double) theMinimum maximum:(double) theMaximum
{
    return [self initWithDoubleMinimum: theMaximum maximum: theMaximum quantisation: 0.0];
}


/**
 * Initialise the range with @p theMinimum, @p theMaximum and @p theQuantisation.
 */
-(id) initWithDoubleMinimum:(double) theMinimum maximum:(double) theMaximum quantisation:(double) theQuantisation
{
	self = [super init];
    if (self)
    {
        minimum = theMinimum;
        maximum = theMaximum;
        quantisation = theQuantisation;
    }
    return self;
}


-(BOOL) isIntegerInRange:(NSInteger) anInteger
{
	[NSException raise:@"Wrong method" format:@"This method can not be called on an SKRange instance"];
    return NO;
}


/**
 * First @p anInteger is checked against minimum and maximum.
 * If both comparisons hold and quantisation is not equal to 0 it is also checked if
 * the difference between @p anInteger and minimum is a multiple of quantisation.
 *
 * @return YES if @p anInteger lies in the current objects range
 */
-(BOOL) isDoubleInRange:(double) aDouble
{
	if (aDouble < minimum)
        return NO;
    
    if (aDouble > maximum)
        return NO;
    
    // float safe comparison for (quantisation == 0)
    if (fabs(quantisation) < EPSILON)
    {
        return YES;
    }
    else
    {
        // difference between anInteger and minimum must be a multiple of quantisation
        // float safe comparison for ( ((aDouble - minimum) % quantisation) == 0)
        return (fabs(fmod((aDouble - minimum), quantisation)) < EPSILON);
    }
}


-(NSString*) description
{
	return [NSString stringWithFormat: @"SKRange with Min: %f, Max: %f, Quantisation: %f", minimum, maximum, quantisation];
}

@end
