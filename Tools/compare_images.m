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

#include <Cocoa/Cocoa.h>

int main(int argc, char* argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSBitmapImageRep* correct = [NSBitmapImageRep imageRepWithContentsOfFile: @"test1.tiff"];
    NSBitmapImageRep* mine = [NSBitmapImageRep imageRepWithContentsOfFile: @"test2.tiff"];
    
    int c = 0;
    int m = 0;
    for (int i = 0; i < 20; ++i) {
        c = [correct bitmapData][i];
        m = [mine bitmapData][i];
        printf("c: %d, m: %d, diff: %d\n", c, m, (c - m));
    }

    printf("\n\n");
    
    for (int i = 202 - 20; i < 202; ++i) {
        c = [correct bitmapData][i];
        m = [mine bitmapData][i];
        printf("c: %d, m: %d, diff: %d\n", c, m, (c - m));
    }

    printf("\n\n");
    
    for (int i = 202; i < 222; ++i) {
        c = [correct bitmapData][i];
        m = [mine bitmapData][i];
        printf("c: %d, m: %d, diff: %d\n", c, m, (c - m));
    }
    
    
    printf("bitmapFormat %d <=> %d\n", [correct bitmapFormat], [mine bitmapFormat]);
    printf("bitsPerPixel %d <=> %d\n", [correct bitsPerPixel], [mine bitsPerPixel]);
    printf("bytesPerPlane %d <=> %d\n", [correct bytesPerPlane], [mine bytesPerPlane]);
    printf("bytesPerRow %d <=> %d\n", [correct bytesPerRow], [mine bytesPerRow]);
    printf("isPlanar %d <=> %d\n", [correct isPlanar], [mine isPlanar]);
    printf("numberOfPlanes %d <=> %d\n", [correct numberOfPlanes], [mine numberOfPlanes]);
    printf("samplesPerPixel %d <=> %d\n", [correct samplesPerPixel], [mine samplesPerPixel]);
//    printf(" %d <=> %d\n", [correct ], [mine ]);
//    printf(" %d <=> %d\n", [correct ], [mine ]);
    
    [pool drain];
    return 0;
}
