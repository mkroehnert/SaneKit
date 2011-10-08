/*
 This file is licensed under the FreeBSD-License.
 For details see https://www.gnu.org/licenses/license-list.html#FreeBSD
 
 Copyright 2011 Manfred Kroehnert. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are
 permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of
 conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list
 of conditions and the following disclaimer in the documentation and/or other materials
 provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY <COPYRIGHT HOLDER> ''AS IS'' AND ANY EXPRESS OR IMPLIED
 WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those of the
 authors and should not be interpreted as representing official policies, either expressed
 or implied, of Manfred Kroehnert.
 */

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


-(double) min
{
	return minimum;
}


-(double) max
{
	return maximum;
}


-(NSString*) description
{
	return [NSString stringWithFormat: @"SKRange with Min: %f, Max: %f, Quantisation: %f", minimum, maximum, quantisation];
}

@end
