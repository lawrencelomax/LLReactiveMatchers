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
- (instancetype) renderActualError;
- (instancetype) actualBehaviour:(NSString *)behaviour;

- (instancetype) expected:(LLSignalTestRecorder *)actual;
- (instancetype) renderExpectedValues;
- (instancetype) renderExpectedError;
- (instancetype) renderExpectedNot;
- (instancetype) expectedBehaviour:(NSString *)behaviour;

- (NSString *) build;

+ (NSString *) actualNotCorrectClass:(id)actual;
+ (NSString *) expectedNotCorrectClass:(id)expected;

+ (NSString *) actualNotFinished:(LLSignalTestRecorder *)actual;
+ (NSString *) expectedNotFinished:(LLSignalTestRecorder *)expected;


+ (NSString *) expectedSignalDidNotRecordSubscriptions:(RACSignal *)signal;
+ (NSString *) expectedSignal:(RACSignal *)signal toBeSubscribedTo:(NSInteger)expected actual:(NSInteger)actual;
+ (NSString *) expectedSignal:(RACSignal *)signal toNotBeSubscribedTo:(NSInteger)expected;

@end
