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

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import <SaneKit/SaneKit.h>
#import <SaneKit/SKScanDevice.h>
#import <SaneKit/SKScanOption.h>
#import <SaneKit/NSBitmapImageRep_WriteToFile.h>


int main(int argc, char* argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
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
        [device setScanRect: [device maxScanRect]];
        
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

        NSString* imageFileName = @"scan";
        if ([arguments objectForKey:@"outputfile"])
            imageFileName = [arguments stringForKey:@"outputfile"];

        if (0 < [images count])
            [(NSBitmapImageRep*)[images lastObject] writeToFile: imageFileName imageFormat: imageType];
        
        [device close];
    }

    [SaneKit exitSane];
    
    [pool drain];
    return 0;
}
