//
//  SKScanOptionString.m
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOptionString.h"


@implementation SKScanOptionString

-(void*) value
{
	stringValue = [(NSString*)value UTF8String];
    return (void*)stringValue;
}


-(BOOL) isString
{
	return YES;
}

@end
