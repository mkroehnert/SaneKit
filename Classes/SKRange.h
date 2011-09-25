//
//  SKRange.h
//  SaneKit
//
//  Created by MK on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKRange_Protocol.h"

#import <Foundation/Foundation.h>


@interface SKRange : NSObject <SKRange> {
    NSInteger minimum;
    NSInteger maximum;
    NSInteger quantisation;
}

-(id) initWithMinimum:(NSInteger) theMinimum maximum:(NSInteger) theMaximum;
-(id) initWithMinimum:(NSInteger) theMinimum maximum:(NSInteger) theMaximum quantisation:(NSInteger) theQuantisation;

-(BOOL) isIntegerInRange:(NSInteger) anInteger;
-(BOOL) isDoubleInRange:(double) aDouble;

-(NSString*) description;

@end
