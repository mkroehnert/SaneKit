//
//  scantool.m
//  SaneKit
//
//  Created by MK on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <SaneKit/SaneKit.h>

int main(int argc, char* argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    [SaneKit initSane];
    
    NSArray* deviceList = [SaneKit scanForDevices];
    NSLog(@"Devices:\n%@", deviceList);
    
    [SaneKit exitSane];
    
    [pool drain];
    return 0;
}