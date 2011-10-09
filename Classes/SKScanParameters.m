/*
 This file is licensed under the FreeBSD-License.
 For details see https://www.gnu.org/licenses/license-list.html#FreeBSD
 
 Copyright 2011 Manfred Kroehnert. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are
 permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of
 conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list
 of conditions and the following disclaimer in the documentation and/or other materials
 provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY <COPYRIGHT HOLDER> ''AS IS'' AND ANY EXPRESS OR IMPLIED
 WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those of the
 authors and should not be interpreted as representing official policies, either expressed
 or implied, of Manfred Kroehnert.
 */

#import "SKScanParameters.h"
#include <sane/sane.h>
#include <AppKit/NSGraphics.h>

@implementation SKScanParameters

-(id) initWithFormat:(SKFrame) aFrame
           lastFrame:(BOOL) isLastFrame
        bytesPerLine:(NSInteger) theBytesPerLine
        pixelsPerLine:(NSInteger) thePixelsPerLine
               lines:(NSInteger) theLines
               depth:(NSInteger) theDepth;
{
	self = [super init];
    if (self)
    {
        [self updateFormat: aFrame
                 lastFrame: isLastFrame
              bytesPerLine: theBytesPerLine
             pixelsPerLine: thePixelsPerLine
                     lines: theLines
                     depth: theDepth];
    }
    return self;
}


-(void) updateFormat:(SKFrame) aFrame
           lastFrame:(BOOL) isLastFrame
        bytesPerLine:(NSInteger) theBytesPerLine
       pixelsPerLine:(NSInteger) thePixelsPerLine
               lines:(NSInteger) theLines
               depth:(NSInteger) theDepth
{
    format = aFrame;
    lastFrame = isLastFrame;
    bytesPerLine = theBytesPerLine;
    pixelsPerLine = thePixelsPerLine;
    lines = theLines;
    depth = theDepth;
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
    NSInteger totalBytes = [self bytesPerRow] * [self heightPixel];
    
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
    return depth * [self samplesPerPixel];
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
	return [self widthPixel] * ([self bitsPerPixel] / 8);
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
 * @return depth parameter used for current scan in bits.
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
    if (0 == pixelsPerLine)
        return @"Scanning image with 0 pixelsPerLine";
    
    if (lines >= 0)
        descriptionString = [NSString stringWithFormat:
                             @"Scanning image of size %dx%d pixels at %d bits/pixel\nFormat: %d\nDepth: %d",
                             pixelsPerLine,
                             lines,
                             [self bitsPerPixel],
                             format,
                             depth
                             ];
    else
        descriptionString = [NSString stringWithFormat:
                             @"Scanning image %d pixels wide (variable length) at %d bits/pixel\nFormat: %d\nDepth: %d",
                             pixelsPerLine,
                             [self bitsPerPixel],
                             format,
                             depth
                             ];
    return descriptionString;
}


@end
