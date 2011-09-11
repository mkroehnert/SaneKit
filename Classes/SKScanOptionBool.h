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
    NSNumber* value;
    NSInteger boolValue;
}

-(id) initWithBoolValue:(BOOL) aBool optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(void) dealloc;

-(NSString*) description;

-(void*) value;

-(BOOL) isBool;

@end
