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

#import "SKApplicationController.h"

#import <SaneKit/SaneKit.h>
#import <SaneKit/SKScanDevice.h>
#import <SaneKit/SKScanOption.h>
#import <SaneKit/NSBitmapImageRep_WriteToFile.h>


@implementation SKApplicationController

-(IBAction) scan:(id)sender
{
    NSUserDefaults* arguments = [NSUserDefaults standardUserDefaults];
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
        NSLog(@"Device successfully opened");
        [device setScanRect: [device maxScanRect]];

        NSArray* images = [(SKScanDevice*)device doScan];
        
        if (0 < [images count])
        {
            NSImage* currentImage = [[[NSImage alloc] init] autorelease];
            [currentRep release];
            currentRep = [[images lastObject] retain];
            [currentImage addRepresentation: currentRep];
            [imageView setImage: currentImage];
        }
        
        [device close];
    }    
}

-(IBAction) saveToFile:(id) sender
{
    [currentRep writeToFile: [NSHomeDirectory() stringByAppendingPathComponent: @"/Desktop/Scan"] imageFormat: @"tiff"];
}

-(void) dealloc
{
    [currentRep release];
    [super dealloc];
}

@end

@implementation SKApplicationController (ApplicationDelegate)

/**
 * Setup Sane.
 */
-(void) applicationWillFinishLaunching:(NSNotification*) aNotification
{
    [SaneKit initSane];
}


/**
 * Tear down Sane.
 */
-(void) applicationWillTerminate:(NSNotification *) aNotification
{
    [SaneKit exitSane];
}

@end

