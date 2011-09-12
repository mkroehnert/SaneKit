//
//  SaneKit.h
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SaneKit : NSObject {

}

+(void) initSane;
+(void) exitSane;
+(BOOL) isInitialized;
+(void) setScanNetwork:(BOOL) aBool;
+(NSArray*) scanForDevices;

@end
