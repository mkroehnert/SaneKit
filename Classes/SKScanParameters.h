//
//  SKScanParameters.h
//  SaneKit
//
//  Created by MK on 04.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
