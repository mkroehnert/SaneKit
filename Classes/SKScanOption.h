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

@protocol SKRange;

@interface SKScanOption : NSObject {
    NSString* name;
    NSString* title;
    NSString* explanation;
    NSString* unitString;
    NSInteger index;
    BOOL readOnly;
    BOOL emulated;
    BOOL autoSelect;
    BOOL inactive;
    BOOL advanced;
}

-(id) initWithName:(NSString*) aName andIndex:(NSInteger) anIndex;
-(void) dealloc;

// Class cluster methods
-(id) initWithBoolValue:(BOOL) aBool optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(id) initWithIntValue:(NSInteger) anInt optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(id) initWithFixedValue:(NSInteger) aFixed optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(id) initWithCStringValue:(const char*) aCString optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;
-(id) initWithStringValue:(NSString*) aString optionName:(NSString*) theName optionIndex:(NSInteger) theIndex;

-(void) setUnitString:(NSString*) aUnit;
-(NSString*) unitString;

-(NSString*) name;

-(void) setTitle:(NSString*) theTitle;
-(NSString*) title;

-(void) setExplanation:(NSString*) theExplanation;
-(NSString*) explanation;

-(void*) value;
-(NSInteger) index;

-(void) setRangeConstraint:(id<SKRange>) aRange;
-(id<SKRange>) rangeConstraint;

-(void) setNumericConstraints:(NSArray*) anArray;
-(NSArray*) numericConstraints;

-(void) setStringConstraints:(NSArray*) anArray;
-(NSArray*) stringConstraints;

-(BOOL) isBool;
-(BOOL) isInteger;
-(BOOL) isDouble;
-(BOOL) isString;

-(void) setBoolValue:(BOOL) aBool;
-(void) setIntegerValue:(NSInteger) anInteger;
-(void) setDoubleValue:(double) aDouble;
-(void) setStringValue:(NSString*) aString;

-(void) setReadOnly:(BOOL) aBool;
-(BOOL) isReadOnly;

-(void) setEmulated:(BOOL) aBool;
-(BOOL) isEmulated;

-(void) setAutoSelect:(BOOL) aBool;
-(BOOL) isAutoSelect;

-(void) setInactive:(BOOL) aBool;
-(BOOL) isInactive;

-(void) setAdvanced:(BOOL) aBool;
-(BOOL) isAdvanced;

@end
