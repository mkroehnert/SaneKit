//
//  SKScanParameters.m
//  SaneKit
//
//  Created by MK on 04.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKScanParameters.h"
#include <sane/sane.h>
#include <AppKit/NSGraphics.h>

@implementation SKScanParameters

-(id) initWithFormat:(SKFrame) aFrame
           lastFrame:(BOOL) isLastFrame
        bytesPerLine:(NSInteger) theBytesPerLine
        pixelsPerLin:(NSInteger) thePixelsPerLine
               lines:(NSInteger) theLines
               depth:(NSInteger) theDepth;
{
	self = [super init];
    if (self)
    {
    	format = aFrame;
        lastFrame = isLastFrame;
        bytesPerLine = theBytesPerLine;
        pixelsPerLine = thePixelsPerLine;
        lines = theLines;
        depth = theDepth;
    }
    return self;
}


/**
 * This method checks if the parameters are suitable for a scan
 */
-(BOOL) checkParameters
{
    BOOL parametersOK = NO;
    switch (format)
    {
        case eRED:
        case eGREEN:
        case eBLUE:
            if (depth == 8)
                parametersOK = YES;
            break;
            
        case eGRAY:
            if ((depth == 1)
                || (depth == 8)
                || (depth == 16))
                parametersOK = YES;
        case eRGB:
            if ((depth == 8)
                || (depth == 16))
                parametersOK = YES;
            break;
            
        default:
            break;
    }
    return parametersOK;
}


/**
 * @return YES if this is the last frame to be scanned
 */
-(BOOL) isLastFrame
{
	return lastFrame;
}


/**
 * @return the total number of bytes which will be read during the scan
 */
-(NSInteger) totalBytes
{
    const int SCALE_FACTOR = ((format == eRGB || format == eGRAY) ? 1:3);
    NSInteger totalBytes = bytesPerLine * lines * SCALE_FACTOR;
    
    return totalBytes;
}


/**
 * @return the width of the image to be scanned in pixels
 */
-(NSInteger) widthPixel
{
	return pixelsPerLine;
}


/**
 * @return the height of the image to be scanned in pixels
 */
-(NSInteger) heightPixel
{
	return lines;
}


/**
 * @return the number of bits of one pixel of the image to be scanned
 */
-(NSInteger) bitsPerPixel
{
    return depth * bytesPerLine / pixelsPerLine;
}


/**
 * @return the number of samples needed for each scanned pixel
 */
-(NSInteger) samplesPerPixel
{
    // RGB uses 3 bytes per pixel
    // Gray or single channel only use one
	return (eRGB == format) ? 3 : 1;
}


/**
 * @return number of bytes each row of the scanned image will consume
 */
-(NSInteger) bytesPerRow
{
	return [self widthPixel] * [self samplesPerPixel];
}


/**
 * @return NSBitmapFormat specification needed to create an NSBitmapImageRep
 */
-(NSString*) colorSpaceName
{
	if (eGRAY == format)
        return NSDeviceWhiteColorSpace;
    else if (eRGB == format)
        return NSDeviceRGBColorSpace;
    else
        return NSDeviceRGBColorSpace;
    // TODO: is the else branch correct?
}


/**
 * @return depth parameter used for current scan (numbers of bits per pixel)
 */
-(NSInteger) depth
{
	return depth;
}


/**
 * @return a string describing the current instance
 */
-(NSString*) description
{
    NSString* descriptionString = @"";
    if (lines >= 0)
        descriptionString = [NSString stringWithFormat:
                             @"Scanning image of size %dx%d pixels at %d bits/pixel\nFormat: %d\nDepth: %d",
                             pixelsPerLine,
                             lines,
                             depth * bytesPerLine / pixelsPerLine,
                             format,
                             depth
                             ];
    else
        descriptionString = [NSString stringWithFormat:
                             @"Scanning image %d pixels wide (variable length) at %d bits/pixel\nFormat: %d\nDepth: %d",
                             pixelsPerLine,
                             depth * bytesPerLine / pixelsPerLine,
                             format,
                             depth
                             ];
    return descriptionString;
}


@end
