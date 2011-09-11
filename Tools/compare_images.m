//
//  compare_images.m
//  SaneKit
//
//  Created by MK on 05.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
