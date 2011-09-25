//
//  SKRange_Protocol.h
//  SaneKit
//
//  Created by MK on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SKRange <NSObject>

-(BOOL) isIntegerInRange:(NSInteger) anInteger;
-(BOOL) isDoubleInRange:(double) aDouble;

@end
