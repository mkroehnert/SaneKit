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

#import <Foundation/Foundation.h>

/**
 * This enum corresponds to the SANE_Format enum.
 */
typedef enum
{
    eGRAY = 0,
    eRGB,
    eRED,
    eGREEN,
    eBLUE
} SKFrame;

@class SKScanDevice;

@interface SKScanParameters : NSObject
{
    SKFrame format;
    BOOL lastFrame;
    NSInteger bytesPerLine;
    NSInteger pixelsPerLine;
    NSInteger lines;
    NSInteger depth;
}

-(id) initWithFormat:(SKFrame) aFrame
           lastFrame:(BOOL) isLastFrame
        bytesPerLine:(NSInteger) theBytesPerLine
        pixelsPerLine:(NSInteger) thePixelsPerLine
               lines:(NSInteger) theLines
               depth:(NSInteger) theDepth;

-(void) updateFormat:(SKFrame) aFrame
         lastFrame:(BOOL) isLastFrame
      bytesPerLine:(NSInteger) theBytesPerLine
     pixelsPerLine:(NSInteger) thePixelsPerLine
             lines:(NSInteger) theLines
             depth:(NSInteger) theDepth;

-(BOOL) checkParameters;
-(BOOL) isLastFrame;
-(NSInteger) totalBytes;
-(NSInteger) widthPixel;
-(NSInteger) heightPixel;
-(NSInteger) bitsPerPixel;
-(NSInteger) samplesPerPixel;
-(NSInteger) bytesPerRow;
-(NSString*) colorSpaceName;
-(NSInteger) depth;

-(NSString*) description;

@end
