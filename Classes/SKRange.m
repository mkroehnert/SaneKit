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
	return [NSString stringWithFormat: @"SKRange with Min: %d, Max: %d, Quantisation: %d", minimum, maximum, quantisation];
}

@end
