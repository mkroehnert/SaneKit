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
static SANE_Status SKSaneStatus = 0;
static SANE_Bool SKOmitNetworkDevices = SANE_TRUE;

@implementation SaneKit

/**
 * This method is called the first time before the class is used.
 * It initializes the Sane library before it gets used.
 */
+(void) initSane
{
    SANE_Auth_Callback saneAuthCallback = NULL;
    SKSaneStatus = sane_init(&SKSaneVersionCode, saneAuthCallback);
}


/**
 * This method does a cleanup of the Sane library structures before shutting down
 * the program.
 */
+(void) exitSane
{
	sane_exit();
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
	SKOmitNetworkDevices = (YES == aBool) ? SANE_FALSE : SANE_TRUE;
}


/**
 * This method probes for scan devices, creates an array of SKScanDevice objects
 * and returns this array.
 *
 * @return NSArray containing SKScanDevice objects
 */
+(NSArray*) scanForDevices
{
    SANE_Status scanDeviceStatus;
    const SANE_Device** device_list;
    NSMutableArray* deviceArray = [NSMutableArray arrayWithCapacity:1];
    
    scanDeviceStatus = sane_get_devices(&device_list, SKOmitNetworkDevices);

    if (SANE_STATUS_GOOD != scanDeviceStatus)
    {
        NSLog(@"Sane Status: %s\n", sane_strstatus(scanDeviceStatus));
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
    return deviceArray;
}

@end
