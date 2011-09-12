//
//  SKScanOption.h
//  SaneKit
//
//  Created by MK on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKScanOption : NSObject {
    NSString* name;
    NSString* unitString;
    NSInteger index;
}

-(id) initWithName:(NSString*) aName andIndex:(NSInteger) anIndex;
-(void) dealloc;

// Class cluster methods
-(id) initWithIntValue:(NSInteger) anInt optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(id) initWithBoolValue:(BOOL) aBool optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(id) initWithCStringValue:(const char*) aCString optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(id) initWithStringValue:(NSString*) aString optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;

-(void) setUnitString:(NSString*) aUnit;
-(NSString*) unitString;

-(void*) value;
-(NSInteger) index;

-(BOOL) isBool;
-(BOOL) isInt;
-(BOOL) isString;

@end
