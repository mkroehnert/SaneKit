//
//  scantool.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SaneKit/SaneKit.h>
#import <SaneKit/SKScanDevice.h>

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
            [device printOptions];
            [device printParameters];
            [device doScan];
        }
        
        [device close];
    }
    
    [SaneKit exitSane];
    
    [pool drain];
    return 0;
}
