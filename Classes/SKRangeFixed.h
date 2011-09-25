//
//  SKRangeFixed.h
//  SaneKit
//
//  Created by MK on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKRange_Protocol.h"

#import <Foundation/Foundation.h>


@interface SKRangeFixed : NSObject <SKRange> {
    double minimum;
    double maximum;
    double quantisation;
}

-(id) initWithDoubleMinimum:(double) theMinimum maximum:(double) theMaximum;
-(id) initWithDoubleMinimum:(double) theMinimum maximum:(double) theMaximum quantisation:(double) theQuantisation;

-(BOOL) isIntegerInRange:(NSInteger) anInteger;
-(BOOL) isDoubleInRange:(double) aDouble;

-(NSString*) description;

@end
