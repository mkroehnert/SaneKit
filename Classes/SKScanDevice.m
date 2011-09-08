//
//  SKScanDevice.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanDevice.h"
#import "SKScanParameters.h"
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
-(void) scanOptions
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
        int hundredPercent = [parameters totalBytes];

        SANE_Int readBytes = 0;
        // TODO: correct for (lines < 0)
        const SANE_Int maxBufferSize = hundredPercent * sizeof(SANE_Byte);
        SANE_Byte* buffer = malloc(maxBufferSize);
        memset(buffer, 0, maxBufferSize);
        SANE_Word totalBytesRead = 0;

        do
        {
            scanStatus = sane_read(handle->deviceHandle, (buffer + totalBytesRead ), (maxBufferSize - totalBytesRead - 1), &readBytes);
            totalBytesRead += (SANE_Word)readBytes;
            double progr = ((totalBytesRead * 100.0) / (double) hundredPercent);
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
