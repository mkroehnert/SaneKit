//
//  SKRange.h
//  SaneKit
//
//  Created by MK on 25.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKRange : NSObject {
    NSInteger minimum;
    NSInteger maximum;
    NSInteger quantisation;
}

-(id) initWithMinimum:(NSInteger) theMinimum maximum:(NSInteger) theMaximum;
-(id) initWithMinimum:(NSInteger) theMinimum maximum:(NSInteger) theMaximum quantisation:(NSInteger) theQuantisation;

-(BOOL) isInRange:(NSInteger) anInteger;

-(NSString*) description;

@end
