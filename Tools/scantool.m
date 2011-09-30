//
//  scantool.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import <SaneKit/SaneKit.h>
#import <SaneKit/SKScanDevice.h>
#import <SaneKit/SKScanOption.h>

@interface SKOutputType : NSObject
{
@public
    NSBitmapImageFileType fileType;
    NSString* fileExtension;
}
@end

@implementation SKOutputType
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


static NSDictionary* fileTypes = nil;


void writeImageToFile(NSBitmapImageRep* imageRep, SKOutputType* fileType)
{
    
    NSDictionary* imageProperties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    NSData* bitmapData = [imageRep representationUsingType: fileType->fileType properties: imageProperties];
    [bitmapData writeToFile: [NSString stringWithFormat: @"%@%@", @"test", fileType->fileExtension] atomically: NO];
}


int main(int argc, char* argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    fileTypes = [NSDictionary dictionaryWithObjectsAndKeys:
     [[SKOutputType alloc] initWithFileType: NSTIFFFileType andExtension: @".tiff"], @"tiff",
     [[SKOutputType alloc] initWithFileType: NSBMPFileType andExtension: @".bmp"], @"bmp",
     [[SKOutputType alloc] initWithFileType: NSGIFFileType andExtension: @".gif"], @"gif",
     [[SKOutputType alloc] initWithFileType: NSJPEGFileType andExtension: @".jpeg"], @"jpeg",
     [[SKOutputType alloc] initWithFileType: NSPNGFileType andExtension: @".png"], @"png",
     [[SKOutputType alloc] initWithFileType: NSJPEG2000FileType andExtension: @".j2k"], @"jpeg2000",
     nil
    ];

    NSUserDefaults* arguments = [NSUserDefaults standardUserDefaults];
    
    [SaneKit initSane];
    
    NSDictionary* deviceDict = [arguments dictionaryForKey:@"device"];
    SKScanDevice* device = [[[SKScanDevice alloc] initWithDictionary: deviceDict] autorelease];

    BOOL deviceOpen = [device open];
    if (!deviceOpen)
    {
        NSLog(@"Scanning for devices");
        NSArray* deviceList = [SaneKit scanForDevices];
        NSLog(@"Available Devices:\n%@", [SaneKit scanForDevices]);
        if (0 < [deviceList count])
        {
            // TODO select device on commandline
            device = [[[deviceList lastObject] retain] autorelease];
            
            deviceOpen = [device open];
            if (deviceOpen)
            {
                // if new device could be opened successfully store it to the userdefaults
                [arguments setObject: [device toUserDefaultsDict] forKey: @"device"];
                [arguments synchronize];
                NSLog(@"New Device:\n %@", device);
            }
        }
    }
    else
        NSLog(@"Using Device:\n %@", device);
    
    if (deviceOpen)
    {
        if ([arguments objectForKey:@"mode"])
            [device setMode: [arguments stringForKey:@"mode"]];
        
        if ([arguments objectForKey:@"resolution"])
            [device setResolution: [arguments integerForKey:@"resolution"]];
        
        if ([arguments objectForKey:@"depth"])
            [device setDepth: [arguments integerForKey:@"depth"]];
        
        if ([arguments objectForKey:@"preview"])
            [device setPreview: [arguments boolForKey:@"preview"]];
                
        NSArray* options = [device scanOptions];
        NSLog(@"Options:\n%@", options);
        
        NSArray* images = [device doScan];
        
        NSString* imageType = @"png";
        if ([arguments objectForKey:@"imagetype"])
            imageType = [[arguments stringForKey:@"imagetype"] lowercaseString];
        SKOutputType* fileType = [fileTypes objectForKey: imageType];
        if (0 < [images count] && nil != fileType)
        {
            writeImageToFile([images lastObject], fileType);
        }
        
        [device close];
    }

    [SaneKit exitSane];
    
    [pool drain];
    return 0;
}
