//
//  SKScanOptionBool.h
//  SaneKit
//
//  Created by MK on 10.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanOption.h"


@interface SKScanOptionBool : SKScanOption
{
    NSInteger boolValue;
}

-(void*) value;

-(BOOL) isBool;

@end
