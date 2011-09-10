//
//  SKScanDevice.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanDevice.h"
#import "SKScanParameters.h"
#import "SKScanOption.h"
#import "SKStructs.h"

#include <sane/sane.h>
#include <math.h>

#import <AppKit/AppKit.h>

@interface SKScanDevice (private)
@end


@implementation SKScanDevice (private)
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
        handle = calloc(1, sizeof(handle));
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
 * This method reads the current scan parameters from the current SANE_Handle and creates
 * an SKScanParameters instance from them.
 *
 * @return a fully initialized SKScanParameters instance
 */
-(SKScanParameters*) scanParameters
{
    SANE_Status parameterStatus;
    SANE_Parameters scanParameters;
    parameterStatus = sane_get_parameters(handle->deviceHandle, &scanParameters);
    if (SANE_STATUS_GOOD != parameterStatus)
    {
        NSLog(@"Sane get parameters error: %s", sane_strstatus(parameterStatus));
        return nil;
    }
    
    SKScanParameters* parameters = [[SKScanParameters alloc] initWithFormat: scanParameters.format
                                                                  lastFrame: scanParameters.last_frame
                                                               bytesPerLine: scanParameters.bytes_per_line
                                                               pixelsPerLin: scanParameters.pixels_per_line
                                                                      lines: scanParameters.lines
                                                                      depth: scanParameters.depth];
    
    return [parameters autorelease];
}

/**
 * Prints all options available from the current device.
 */
-(NSArray*) scanOptions
{
    SANE_Int numOptions = 0;
    SANE_Status optionStatus = 0;
    const SANE_Option_Descriptor* optionDescr;
    
    optionDescr = sane_get_option_descriptor(handle->deviceHandle, 0);
    if (!optionDescr)
    {
    	NSLog(@"Unable to retrieve options");
        return nil;
    }
    
    optionStatus = sane_control_option(handle->deviceHandle, 0, SANE_ACTION_GET_VALUE, &numOptions, 0);
    if (SANE_STATUS_GOOD != optionStatus)
    {
    	NSLog(@"Error retrieving number of available options");
        return nil;
    }

    NSMutableArray* optionsArray = [NSMutableArray arrayWithCapacity: numOptions];
    
    for (int i = 0; i < numOptions; ++i)
    {
        optionDescr = sane_get_option_descriptor(handle->deviceHandle, i);
        if (!optionDescr || !optionDescr->name || !optionDescr->type)
            continue;
        NSLog(@"Option #%d <%d>: %s,", i, optionDescr->type, optionDescr->name);
        id objcValue = nil;

        if ( (SANE_TYPE_FIXED == optionDescr->type || SANE_TYPE_INT == optionDescr->type)
             && (sizeof(SANE_Int) == optionDescr->size))
        {
            SANE_Int value = 0;
            optionStatus = sane_control_option(handle->deviceHandle, i, SANE_ACTION_GET_VALUE, &value, NULL);

            if (SANE_STATUS_GOOD != optionStatus)
                continue;
            
            objcValue = [NSNumber numberWithInt: value];
        }
        else if (SANE_TYPE_STRING == optionDescr->type && 0 < optionDescr->size)
        {
            SANE_String value = calloc(optionDescr->size + 1, sizeof(SANE_Char));
            optionStatus = sane_control_option(handle->deviceHandle, i, SANE_ACTION_GET_VALUE, value, NULL);
            
            if (SANE_STATUS_GOOD != optionStatus)
                continue;

            objcValue = [NSString stringWithCString: value];
            free(value);
        }
        else if (SANE_TYPE_BOOL == optionDescr->type
                 && (sizeof(SANE_Word) == optionDescr->size))
        {
            SANE_Bool value = SANE_FALSE;
            optionStatus = sane_control_option(handle->deviceHandle, i, SANE_ACTION_GET_VALUE, &value, NULL);

            if (SANE_STATUS_GOOD != optionStatus)
                continue;

            objcValue = [NSNumber numberWithBool: ((SANE_TRUE == value) ? YES : NO)];
        }
        else
        {
            objcValue = [NSString stringWithFormat: @"Type: %d", optionDescr->type];
        }
 
        
        SKScanOption* option = [[SKScanOption alloc] initWithName: [NSString stringWithCString: optionDescr->name]
                                           andIndex: i
                                           andValue: objcValue];
        [option autorelease];
        [optionsArray addObject: option];
    }

    // turn mutable array into non mutable array
    return [NSArray arrayWithArray: optionsArray];
}


/**
 * This method does a basic scan but currently doesn't do anything with the read data.
 */
-(BOOL) doScan
{
	SANE_Status scanStatus = 0;
    SANE_Parameters scanParameters;
    
    scanStatus = sane_start (handle->deviceHandle);
    if (SANE_STATUS_GOOD != scanStatus)
    {
        NSLog(@"Sane start error: %s", sane_strstatus(scanStatus));
        return NO;
    }
    
    do
    {
        SKScanParameters* parameters = [self scanParameters];
        if (![parameters checkParameters])
            continue;

        NSLog(@"Scan parameters:\n%@\n", parameters);
        int totalBytesToRead = [parameters totalBytes];
        NSLog(@"100%% = %d", totalBytesToRead);

        SANE_Int readBytes = 0;
        // TODO: correct for (lines < 0)
        const SANE_Int maxBufferSize = totalBytesToRead * sizeof(SANE_Byte);
        SANE_Byte* buffer = calloc(totalBytesToRead, sizeof(SANE_Byte));
        SANE_Word totalBytesRead = 0;

        do
        {
            scanStatus = sane_read(handle->deviceHandle, (buffer + totalBytesRead ), (maxBufferSize - totalBytesRead - 1), &readBytes);
            totalBytesRead += (SANE_Word)readBytes;
            double progr = ((totalBytesRead * 100.0) / (double) totalBytesToRead);
            progr = fminl(progr, 100.0);
            NSLog(@"Progress: %3.1f%%, total bytes: %d\n", progr, totalBytesRead);
        }
        while (SANE_STATUS_GOOD == scanStatus || SANE_STATUS_EOF != scanStatus);
        NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc]
                                    initWithBitmapDataPlanes: &buffer
                                    pixelsWide: [parameters widthPixel]
                                    pixelsHigh: [parameters heightPixel]
                                    bitsPerSample: 8
                                    samplesPerPixel: 3  // or 4 with alpha
                                    hasAlpha: NO
                                    isPlanar: NO // only use the first element of buffer
                                    colorSpaceName: NSDeviceRGBColorSpace
                                    bitmapFormat: 0
                                    bytesPerRow: [parameters widthPixel] * 3  // 0 == determine automatically
                                    bitsPerPixel: [parameters bitsPerPixel]];  // 0 == determine automatically
        
        if (nil != bitmap)
        {
            NSDictionary* imageProperties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
            NSData* bitmapData = [bitmap representationUsingType: NSTIFFFileType properties: imageProperties];
            [bitmapData writeToFile: @"test.tiff" atomically: NO];
        }
        free(buffer);
    }
    while (!scanParameters.last_frame);
    
    sane_cancel(handle->deviceHandle);
    
    return YES;
}


@end
