//
//  SaneKit.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaneKit.h"
#import "SKScanDevice.h"
#include <sane/sane.h>

static SANE_Int SKSaneVersionCode = 0;
static SANE_Status SKSaneStatus = -1; // status codes start at 0
static SANE_Bool SKSearchLocalOnlyScanners = SANE_TRUE;

@implementation SaneKit

/**
 * This method must be called the first time before the class is used.
 * It initializes the Sane library before it gets used.
 * If this method gets called twice it issues a warning message and returns
 * without doing anything.
 */
+(void) initSane
{
    if ([SaneKit isInitialized])
    {
    	NSLog(@"[SaneKit initSane] has already been called once! Check your code for duplicate initialization.");
        return;
    }
    /*
     TODO: auth callback
     
     The authentication function type has the following declaration:
     
     #define SANE_MAX_USERNAME_LEN   128
     #define SANE_MAX_PASSWORD_LEN   128
     
     typedef void (*SANE_Authorization_Callback)
     (SANE_String_Const resource,
     SANE_Char username[SANE_MAX_USERNAME_LEN],
     SANE_Char password[SANE_MAX_PASSWORD_LEN]);
     
     Three arguments are passed to the authorization function:
     - resource is a string specifying the name of the resource that requires authorization.
       A frontend should use this string to build a user-prompt requesting a username and a password.
     - username and password arguments are (pointers to) an array of
       SANE_MAX_USERNAME_LEN and SANE_MAX_PASSWORD_LEN characters, respectively.
       The authorization call should place the entered username and password in these arrays.
       The returned strings must be ASCII-NUL terminated.
     */
    SANE_Auth_Callback saneAuthCallback = NULL;
    SKSaneStatus = sane_init(&SKSaneVersionCode, saneAuthCallback);
}


/**
 * This method does a cleanup of the Sane library structures before shutting down
 * the program.
 * If [SaneKit initSane] was not called it prints an error message instead.
 */
+(void) exitSane
{
    if ([SaneKit isInitialized])
        sane_exit();
    else
        NSLog(@"[SaneKit exitSane] executed before [SaneKit initSane] was called");
}


/**
 * @return YES if SaneKit is initialized correctly, NO in every other case
 */
+(BOOL) isInitialized
{
    return (SANE_STATUS_GOOD == SKSaneStatus) ? YES : NO;
}


/**
 * If YES is passed to this method [SaneKit scanForDevices] will search for network attached
 * scanners. If the parameter is NO only scanners connected to the current computer will
 * be detected.
 *
 * Default is NO.
 *
 * @warning if scanning on the network is enable the call to [SaneKit scanForDevices] will probably take significantly longer
 */
+(void) setScanNetwork:(BOOL) aBool
{
	SKSearchLocalOnlyScanners = (YES == aBool) ? SANE_FALSE : SANE_TRUE;
}


/**
 * This method probes for scan devices, creates an array of SKScanDevice objects
 * and returns this array.
 * It raises an exception if it is called before [SaneKit initSane].
 *
 * @return NSArray containing SKScanDevice objects
 */
+(NSArray*) scanForDevices
{
    if (![SaneKit isInitialized])
    	[NSException raise: @"Initialization Error" format: @"[SaneKit initSane] must be called before [SaneKit scanForDevices]"];

    SANE_Status scanDeviceStatus;
    const SANE_Device** device_list;
    NSMutableArray* deviceArray = [NSMutableArray arrayWithCapacity:1];
    
    scanDeviceStatus = sane_get_devices(&device_list, SKSearchLocalOnlyScanners);

    if (SANE_STATUS_GOOD != scanDeviceStatus)
    {
        NSLog(@"[SaneKit scanForDevices] failed with status: %s\n", sane_strstatus(scanDeviceStatus));
        return deviceArray;
    }
    
    for (int i = 0; device_list[i]; ++i) {
        SKScanDevice* scanDevice =
            [[SKScanDevice alloc] initWithName:[NSString stringWithCString:device_list[i]->name]
                                        vendor:[NSString stringWithCString:device_list[i]->vendor]
                                         model:[NSString stringWithCString:device_list[i]->model]
                                          type:[NSString stringWithCString:device_list[i]->type]];
        [deviceArray addObject:scanDevice];
        [scanDevice release];
    }
    // return immutable copy
    return [NSArray arrayWithArray: deviceArray];
}

@end
