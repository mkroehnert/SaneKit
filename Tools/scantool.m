//
//  scantool.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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


int main(int argc, char* argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSUserDefaults* arguments = [NSUserDefaults standardUserDefaults];
    
    [SaneKit initSane];
    
    NSArray* deviceList = [SaneKit scanForDevices];
    NSLog(@"Devices:\n%@", deviceList);
    
    if (0 < [deviceList count])
    {
        SKScanDevice* device = [deviceList lastObject];
        BOOL success = [device open];
        if (success)
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

            if (0 < [images count])
            {
                NSDictionary* imageProperties = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
                NSData* bitmapData = [[images lastObject] representationUsingType: NSPNGFileType properties: imageProperties];
                [bitmapData writeToFile: @"test.png" atomically: NO];
            }
            
            [device close];
        }
    }
    
    [SaneKit exitSane];
    
    [pool drain];
    return 0;
}
