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

#import "SKScanOptionFixed.h"
#import "SKRange_Protocol.h"

#include <sane/sane.h>


@implementation SKScanOptionFixed

-(id) initWithFixedValue:(NSInteger) aFixed optionName:(NSString*) theName optionIndex:(NSInteger) theIndex
{
	self = [super initWithName: theName andIndex: theIndex];
    if (self)
    {
    	value = [[NSNumber numberWithDouble: SANE_UNFIX(aFixed)] retain];
        numericConstraints = nil;
        rangeConstraint = nil;
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
    if (numericConstraints)
    {
        [numericConstraints release];
        numericConstraints = nil;
    }
    if (rangeConstraint)
    {
        [rangeConstraint release];
        rangeConstraint = nil;
    }
    
    [super dealloc];
}



-(NSString*) description
{
    id constraint = (nil == numericConstraints) ? (id)rangeConstraint : (id)numericConstraints;
	return [NSString stringWithFormat:@"Option: %@, Value: %@[%@] <%@>", name, value, unitString, constraint];
}


-(void*) value
{
    fixedValue = SANE_FIX([(NSNumber*)value doubleValue]);
    return &fixedValue;
}


-(void) setRangeConstraint:(id<SKRange>) aRange
{
    if (numericConstraints)
    {
    	[numericConstraints release];
        numericConstraints = nil;
    }
    if (rangeConstraint)
        [rangeConstraint release];
    rangeConstraint = [aRange retain];
}


-(id<SKRange>) rangeConstraint
{
    return [[rangeConstraint retain] autorelease];
}


-(void) setNumericConstraints:(NSArray*) anArray
{
    NSEnumerator* anEnumerator = [anArray objectEnumerator];
    id anObject = nil;
    while (anObject = [anEnumerator nextObject]) {
        if (! [anObject isKindOfClass: [NSNumber class]] )
        {
            [NSException raise: @"WrongArgumentType"
                        format: @"This method needs an array of NSNumber values as parameter"];
        }
    }

    if (rangeConstraint)
    {
    	[rangeConstraint release];
        rangeConstraint = nil;
    }
    if (numericConstraints)
        [numericConstraints release];
    numericConstraints = [anArray retain];
}


-(NSArray*) numericConstraints
{
    return [[numericConstraints retain] autorelease];
}


-(BOOL) isDouble
{
	return YES;
}


-(void) setDoubleValue:(double) aDouble
{
    if (readOnly || inactive)
    {
        NSLog(@"Trying to set readonly/inactive option %@", title);
        return;
    }
    
    if (rangeConstraint && ![rangeConstraint isDoubleInRange: aDouble])
    {
        [NSException raise: @"WrongArgument"
                    format: @"The parameter needs to be in the Range %@ but is (%f)", rangeConstraint, aDouble];
    }
    
    NSNumber* parameter = [NSNumber numberWithDouble: aDouble];
    if (numericConstraints && ![numericConstraints containsObject: parameter])
    {
        [NSException raise: @"WrongArgument"
                    format: @"The parameter needs to be one of %@ but is (%@)", numericConstraints, parameter];
    }
    if (value)
        [value release];
    value = [parameter retain];
}

@end
