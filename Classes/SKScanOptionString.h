//
//  SKScanOptionString.h
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOption.h"


@interface SKScanOptionString : SKScanOption
{
    const char* stringValue;
}

-(void*) value;

-(BOOL) isString;

@end
