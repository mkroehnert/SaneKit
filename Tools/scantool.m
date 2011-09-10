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
            
            // resolution is the 5th parameter for my scanner
            SKScanOption* resolution = [options objectAtIndex: 4];
            [resolution setValue: [NSNumber numberWithInt: 300] forKey: @"value"];
            
            [device setScanOption: resolution];
            
            options = [device scanOptions];
            NSLog(@"Options:\n%@", options);
            
            // also call sane_get_parameters to get an idea of the image parameters
            NSLog(@"%@", [device scanParameters]);
            
            [device doScan];
            [device close];
        }
    }
    
    [SaneKit exitSane];
    
    [pool drain];
    return 0;
}
