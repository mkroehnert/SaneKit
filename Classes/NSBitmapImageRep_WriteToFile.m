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

#import "NSBitmapImageRep_WriteToFile.h"


@interface SKImageTypeMapping : NSObject
{
@public
    NSBitmapImageFileType fileType;
    NSString* fileExtension;
}
-(id) initWithFileType:(NSBitmapImageFileType) aFileType andExtension:(NSString*) anExtension;
@end

@implementation SKImageTypeMapping
-(id) initWithFileType:(NSBitmapImageFileType) aFileType andExtension:(NSString*) anExtension
{
	self = [super init];
    if (self)
    {
    	fileType = aFileType;
        fileExtension = anExtension;
    }
    return self;
}
@end


static NSDictionary* imageFormatsDict = nil;

/**
 * Setup the imageFormatsDict with all available image formats
 */
void setupImageFormatsDictionary()
{
    imageFormatsDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [[SKImageTypeMapping alloc] initWithFileType: NSTIFFFileType andExtension: @".tiff"], @"tiff",
                        [[SKImageTypeMapping alloc] initWithFileType: NSBMPFileType andExtension: @".bmp"], @"bmp",
                        [[SKImageTypeMapping alloc] initWithFileType: NSGIFFileType andExtension: @".gif"], @"gif",
                        [[SKImageTypeMapping alloc] initWithFileType: NSJPEGFileType andExtension: @".jpeg"], @"jpeg",
                        [[SKImageTypeMapping alloc] initWithFileType: NSPNGFileType andExtension: @".png"], @"png",
                        [[SKImageTypeMapping alloc] initWithFileType: NSJPEG2000FileType andExtension: @".j2k"], @"jpeg2000",
                        nil
                        ];
}


@implementation NSBitmapImageRep (WriteToFile)

/**
 * \return an NSArray of NSString objects which are a textual representation of the supported image formats
 */
-(NSArray*) imageFormats
{
    if (!imageFormatsDict)
        setupImageFormatsDictionary();
    return [imageFormatsDict allKeys];
}


/**
 * Write the NSBitmapImageRep to the file given by \p filename and use the format given by
 * \p imageFormat.
 * The appropriate file suffix is appended automatically.
 */
-(BOOL) writeToFile:(NSString*) filename imageFormat:(NSString*) imageFormat
{
    if (!imageFormatsDict)
        setupImageFormatsDictionary();
    SKImageTypeMapping* fileType = [imageFormatsDict objectForKey: imageFormat];
    if (nil == fileType)
        return NO;
    // compression properties
    NSDictionary* imageProperties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    // create an NSData object from the representation using the given image type
    NSData* bitmapData = [self representationUsingType: fileType->fileType properties: imageProperties];
    // write the NSData object to the file given by \p filename
    [bitmapData writeToFile: [NSString stringWithFormat: @"%@%@", filename, fileType->fileExtension] atomically: NO];
    return YES;
}

@end
