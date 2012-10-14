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
#import "SKApplicationModel.h"

#import <SaneKit/SaneKit.h>
#import <SaneKit/SKScanDevice.h>
#import <SaneKit/SKScanOption.h>
#import <SaneKit/NSBitmapImageRep_WriteToFile.h>


@implementation SKApplicationController

-(id) init
{
    self = [super init];
    if (self)
    {
        model = [[SKApplicationModel alloc] init];
        isDeviceOpen = NO;
    }
    return self;
}

-(void) dealloc
{
    [currentRep release];
    [model release];
    [super dealloc];
}


-(void) setUserDefaultsForDevice: (SKScanDevice*) aScanDevice
{
    if (nil == aScanDevice)
        return;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [aScanDevice toUserDefaultsDict] forKey: @"device"];
/*
    [defaults setObject: scanMode forKey:@"mode"];
    [defaults setInteger: scanResolution forKey:@"resolution"];
    [defaults setInteger: scanDepth forKey:@"depth"];
    [defaults setBool: scanPreview forKey:@"preview"];
*/
    [defaults synchronize];
}


-(NSDictionary*) userDefaultsForDevice
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* deviceDict = [defaults dictionaryForKey:@"device"];
/*
    if ([defaults objectForKey:@"mode"])
        scanMode = [defaults stringForKey:@"mode"];
    
    if ([defaults objectForKey:@"resolution"])
        scanResolution = [defaults integerForKey:@"resolution"];
    
    if ([defaults objectForKey:@"depth"])
        scanDepth = [defaults integerForKey:@"depth"];
    
    if ([defaults objectForKey:@"preview"])
        scanPreview = [defaults boolForKey:@"preview"];
*/
    return [deviceDict autorelease];
}


-(BOOL) openScanDevice
{
    BOOL deviceOpen = [[model scanDevice] open];
    if (!deviceOpen)
    {
        NSLog(@"Scanning for devices");
        NSArray* deviceList = [SaneKit scanForDevices];
        NSLog(@"Available Devices:\n%@", deviceList);
        if (0 < [deviceList count])
        {
            [model setScanDevice: [[[deviceList lastObject] retain] autorelease]];
            
            deviceOpen = [[model scanDevice] open];
            if (deviceOpen)
            {
                // if new device could be opened successfully store it to the userdefaults
                [self setUserDefaultsForDevice: [model scanDevice]];
                NSLog(@"New Device:\n %@", [model scanDevice]);
            }
        }
    }
    else
        NSLog(@"Using Device:\n %@", [model scanDevice]);

    return deviceOpen;
}

-(IBAction) scan:(id)sender
{
    [self performSelectorInBackground:@selector(performScan) withObject:nil];
}


-(void) performScan
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (isDeviceOpen)
    {
        NSLog(@"Device successfully opened");
        [[model scanDevice] setScanRect: [[model scanDevice] maxScanRect]];

        NSArray* images = [[model scanDevice] doScan];
        
        if (0 < [images count])
        {
            NSImage* currentImage = [[[NSImage alloc] init] autorelease];
            [currentRep release];
            currentRep = [[images lastObject] retain];
            [currentImage addRepresentation: currentRep];
            [imageView setImage: currentImage];
        }
    }
    [pool release];
}

-(IBAction) saveToFile:(id) sender
{
    [currentRep writeToFile: [NSHomeDirectory() stringByAppendingPathComponent: @"/Desktop/Scan"] imageFormat: @"tiff"];
}

-(void) setMaximumScanProgress:(NSInteger) aScanProgress
{
    NSLog(@"Max Scan Size: %d", aScanProgress);
}

-(void) setCurrentScanProgress:(NSInteger) aScanProgress
{
    NSLog(@"Current Scan Size: %d", aScanProgress);
}

-(void) scanStarted
{
    NSLog(@"Scan Start");
}

-(void) scanCancelled
{
    NSLog(@"Scan Cancel");
}

-(void) scanFinished
{
    NSLog(@"Scan Finish");
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
 * Create SKScanDevice instance.
 */
-(void) applicationDidFinishLaunching:(NSNotification*) aNotification
{
    [model setScanDevice: [[SKScanDevice alloc] initWithDictionary: [self userDefaultsForDevice]]];
    isDeviceOpen = [self openScanDevice];
    [[model scanDevice] setDelegate: self];
}


/**
 * Tear down Sane.
 */
-(void) applicationWillTerminate:(NSNotification *) aNotification
{
    [[model scanDevice] close];
    [SaneKit exitSane];
}

@end

