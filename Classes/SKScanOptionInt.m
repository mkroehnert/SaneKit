//
//  SKScanOptionInt.m
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOptionInt.h"


@implementation SKScanOptionInt

-(void*) value
{
    intValue = [(NSNumber*)value intValue];
    return &intValue;
}

-(BOOL) isInt
{
	return YES;
}


@end
