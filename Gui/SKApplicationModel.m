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

#import "SKApplicationModel.h"
#import <SaneKit/SKScanDevice.h>


@implementation SKApplicationModel

-(id) init
{
    self = [super init];
    if (self)
    {
        scanModes = [NSArray arrayWithObjects: @"Color", @"Gray", @"Lineart", nil];
        scanResolutions = [NSArray arrayWithObjects: [NSNumber numberWithInt:100], [NSNumber numberWithInt:200], [NSNumber numberWithInt:300], nil];
        scanDepths = [NSArray arrayWithObjects: [NSNumber numberWithInt:8], [NSNumber numberWithInt:16], nil];
    }
    return self;
}

-(void) dealloc
{
    [scanModes release];
    [scanResolutions release];
    [scanDepths release];
    if(scanDevice)
        [scanDevice release];
    [super dealloc];
}


-(SKScanDevice*) scanDevice
{
    return scanDevice;
}


-(void) setScanDevice:(SKScanDevice*) aScanDevice
{
    scanDevice = aScanDevice;
}



-(NSString*) mode
{
    return [scanDevice mode];
}


-(void) setMode:(NSString*) aMode
{
    [scanDevice setMode: aMode];
}


-(NSInteger) depth
{
    return [scanDevice depth];
}


-(void) setDepth:(NSInteger) aDepth
{
    [scanDevice setDepth: aDepth];
}


-(NSInteger) resolution
{
    return [scanDevice resolution];
}


-(void) setResolution:(NSInteger) aResolution
{
    [scanDevice setResolution: aResolution];
}


-(BOOL) preview
{
    return [scanDevice preview];
}


-(void) setPreview:(BOOL) doPreview
{
    [scanDevice setPreview: doPreview];
}


-(NSRect) scanRect
{
    return [scanDevice scanRect];
}


-(void) setScanRect:(NSRect) aScanRect
{
    [scanDevice setScanRect: [scanDevice maxScanRect]];
}

@end