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
#import "SKScanProgressProtocol.h"

struct SaneHandle;
@class SKScanParameters;
@class SKScanOption;

@interface SKScanDevice : NSObject {
    NSString* name;
    NSString* vendor;
    NSString* model;
    NSString* type;
    struct SaneHandle* handle;
    NSMutableDictionary* options;
    SKScanParameters* parameters;
    
    id<SKScanProgress> delegate;
}

-(id) initWithName:(NSString*) aName vendor:(NSString*) aVendor model:(NSString*) aModel type:(NSString*) aType;
-(id) initWithDictionary:(NSDictionary*) aDictionary;
-(void) dealloc;
-(void) setDelegate:(id<SKScanProgress>) aDelegate;

-(NSDictionary*) toUserDefaultsDict;
-(NSString*) description;

-(BOOL) open;
-(void) close;

-(NSArray*) doScan;
-(void) cancelScan;

-(void) reloadScanParameters;
-(SKScanParameters*) scanParameters;

-(void) reloadScanOptions;
-(NSArray*) scanOptions;
-(BOOL) setScanOption:(SKScanOption*) theOption;

-(NSString*) mode;
-(BOOL) setMode:(NSString*) theMode;
-(NSInteger) depth;
-(BOOL) setDepth:(NSInteger) theDepth;
-(NSInteger) resolution;
-(BOOL) setResolution:(NSInteger) theResolution;
-(BOOL) preview;
-(BOOL) setPreview:(BOOL) doPreview;
-(NSRect) scanRect;
-(BOOL) setScanRect:(NSRect) scanRect;
-(NSRect) maxScanRect;

@end
