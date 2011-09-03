//
//  SaneKit.h
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SaneKit : NSObject {

}

+(void) initSane;
+(void) exitSane;
+(BOOL) isInitialized;
+(NSArray*) scanForDevices;

@end
