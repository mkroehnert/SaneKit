//
//  SKRange.m
//  SaneKit
//
//  Created by MK on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKRange.h"


@implementation SKRange

/**
 * Initialise the range with @p theMinimum and @p theMaximum and set quantisation to 0.
 */
-(id) initWithMinimum:(NSInteger) theMinimum maximum:(NSInteger) theMaximum
{
    return [self initWithMinimum: theMaximum maximum: theMaximum quantisation: 0];
}


/**
 * Initialise the range with @p theMinimum, @p theMaximum and @p theQuantisation.
 */
-(id) initWithMinimum:(NSInteger) theMinimum maximum:(NSInteger) theMaximum quantisation:(NSInteger) theQuantisation
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


/**
 * First @p anInteger is checked against minimum and maximum.
 * If both comparisons hold and quantisation is not equal to 0 it is also checked if
 * the difference between @p anInteger and minimum is a multiple of quantisation.
 *
 * @return YES if @p anInteger lies in the current objects range
 */
-(BOOL) isIntegerInRange:(NSInteger) anInteger
{
	if (anInteger < minimum)
        return NO;
    
    if (anInteger > maximum)
        return NO;
    
    if (0 == quantisation)
    {
        return YES;
    }
    else
    {
        // difference between anInteger and minimum must be a multiple of quantisation
        return (0 == ((anInteger - minimum) % quantisation));
    }
}


-(BOOL) isDoubleInRange:(double) aDouble
{
	[NSException raise:@"Wrong method" format:@"This method can not be called on an SKRangeFixed instance"];
    return NO;
}



-(NSString*) description
{
	return [NSString stringWithFormat: @"SKRange with Min: %d, Max: %d, Quantisation: %d", minimum, maximum, quantisation];
}

@end
