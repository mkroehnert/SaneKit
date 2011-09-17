//
//  scantool.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SaneKit/SaneKit.h>
#import <SaneKit/SKScanDevice.h>
#import <SaneKit/SKScanOption.h>

int main(int argc, char* argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [SaneKit initSane];
    
    NSArray* deviceList = [SaneKit scanForDevices];
    NSLog(@"Devices:\n%@", deviceList);
    
    if (0 < [deviceList count])
    {
        SKScanDevice* device = [deviceList lastObject];
        BOOL success = [device open];
        if (success)
        {
            NSArray* options = [device scanOptions];
            NSLog(@"Options:\n%@", options);
            
            options = [device scanOptions];
            NSLog(@"Options:\n%@", options);
            [device setMode: @"Gray"];
            [device setResolution: 300];

            
            // also call sane_get_parameters to get an idea of the image parameters
            NSLog(@"%@", [device scanParameters]);
            
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
