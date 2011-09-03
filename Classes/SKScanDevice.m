//
//  SKScanDevice.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanDevice.h"
#import "SKStructs.h"
#include <sane/sane.h>
#include <math.h>
#include <assert.h>

@interface SKScanDevice (private)

+(void) checkParameters:(SANE_Parameters*) parameters;

@end


@implementation SKScanDevice (private)

+(void) checkParameters:(SANE_Parameters*) parameters
{
    if (!parameters || !parameters->format || !parameters->depth)
        return;
    
    // TODO: replace assert() calls
    switch (parameters->format)
    {
        case SANE_FRAME_RED:
        case SANE_FRAME_GREEN:
        case SANE_FRAME_BLUE:
            assert (parameters->depth == 8);
            break;
            
        case SANE_FRAME_GRAY:
            assert ((parameters->depth == 1)
                    || (parameters->depth == 8)
                    || (parameters->depth == 16));
        case SANE_FRAME_RGB:
            assert ((parameters->depth == 8)
                    || (parameters->depth == 16));
            break;
            
        default:
            break;
    }
}

@end


@implementation SKScanDevice

/**
 * Initialize the class.
 */
-(id) initWithName:(NSString*) aName vendor:(NSString*) aVendor model:(NSString*) aModel type:(NSString*) aType
{
    self = [super init];
    if (self)
    {
        name = [aName retain];
        vendor = [aVendor retain];
        model = [aModel retain];
        type = [aType retain];
        handle = malloc(sizeof(handle));
    }
    return self;
}


/**
 * Release all ressources
 */
-(void) dealloc
{
    [name release];
    [vendor release];
    [model release];
    [type release];
    free(handle);
    
    [super dealloc];
}


/**
 * Returns an NSString instance describing the SKScanDevice
 */
-(NSString*) description
{
    NSString* deviceDescription = [NSString stringWithFormat: @"ScanDevice:\n\tName: %@\n\tVendor: %@\n\tModel: %@\n\tType: %@\n", name, vendor, model, type];
    return deviceDescription;
}


/**
 * Open the scan device.
 *
 * @return YES if successful, NO otherwise
 */
-(BOOL) open
{
	SANE_Status openStatus = 0;
    openStatus = sane_open([name UTF8String], &(handle->deviceHandle));
    
    return (SANE_STATUS_GOOD == openStatus) ? YES : NO;
}


/**
 * Close the scan device.
 */
-(void) close
{
	sane_close(handle->deviceHandle);
}


/**
 * Prints all options available from the current device.
 */
-(void) printOptions
{
    SANE_Int numOptions = 0;
    SANE_Status optionStatus = 0;
    
    optionStatus = sane_control_option(handle->deviceHandle, 0, SANE_ACTION_GET_VALUE, &numOptions, 0);
    
    const SANE_Option_Descriptor* optionDescr;
    for (int i = 0; i < numOptions; ++i)
    {
        optionDescr = sane_get_option_descriptor(handle->deviceHandle, i);
        if (optionDescr && optionDescr->name)
            NSLog(@"Option #%d: %s", i, optionDescr->name);
    }
    
}


/**
 * Print the current parameters.
 */
-(void) printParameters
{
    SANE_Parameters parameters;
    SANE_Status status;
    status = sane_get_parameters(handle->deviceHandle, &parameters);
    NSLog(@"Parameters:\n\tFormat: %d\n\tLastFrame: %d\n\tBytes/Line: %d\n\tPixels/Line: %d\n\tLines: %d\n\tDepth: %d",
          parameters.format,
          parameters.last_frame,
          parameters.bytes_per_line,
          parameters.pixels_per_line,
          parameters.lines,
          parameters.depth
          );    
}


@end
