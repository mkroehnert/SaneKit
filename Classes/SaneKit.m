//
//  SaneKit.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaneKit.h"
#include <sane/sane.h>

static SANE_Int saneVersionCode = 0;
static SANE_Status saneStatus = 0;

@implementation SaneKit

/**
 * This method is called the first time before the class is used.
 * It initializes the Sane library before it gets used.
 */
+(void) initSane
{
    SANE_Auth_Callback saneAuthCallback = NULL;
    saneStatus = sane_init(&saneVersionCode, saneAuthCallback);
}


/**
 * This method does a cleanup of the Sane library structures before shutting down
 * the program.
 */
+(void) exitSane
{
	sane_exit();
}

@end
