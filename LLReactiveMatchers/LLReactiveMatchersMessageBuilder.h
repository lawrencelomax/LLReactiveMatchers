//
//  LLReactiveMatchersMessages.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 12/12/2013.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLSignalTestRecorder.h"

@interface LLReactiveMatchersMessageBuilder : NSObject

+ (instancetype) message;

- (instancetype) actual:(LLSignalTestRecorder *)actual;
- (instancetype) renderActualValues;
- (instancetype) renderActualErrors;
- (instancetype) actualBehaviour:(NSString *)behaviour;

- (instancetype) expected:(LLSignalTestRecorder *)actual;
- (instancetype) renderExpectedValues;
- (instancetype) renderExpectedErrors;
- (instancetype) expectedBehaviour:(NSString *)behaviour;

- (NSString *) build;

+ (NSString *) actualNotCorrectClass:(id)actual;
+ (NSString *) expectedNotCorrectClass:(id)expected;

+ (NSString *) actualNotFinished:(LLSignalTestRecorder *)actual;
+ (NSString *) expectedNotFinished:(LLSignalTestRecorder *)expected;

@end
