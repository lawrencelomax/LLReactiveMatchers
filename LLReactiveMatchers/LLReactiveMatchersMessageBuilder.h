//
//  LLReactiveMatchersMessages.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 12/12/2013.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

extern NSString *LLReactiveMatchersDescribeObject(id object);

@interface LLReactiveMatchersMessageBuilder : NSObject

+ (instancetype) messageWithActual:(id)actual;
+ (instancetype) messageWithActual:(id)actual expected:(id)expected;

- (instancetype) expectedBehaviour:(NSString *)behaviour;
- (instancetype) actualBehaviour:(NSString *)behaviour;

- (NSString *) build;

+ (NSString *) actualNotSignal:(id)actual;
+ (NSString *) actualNotFinished:(RACSignal *)actual;
+ (NSString *) expectedNotFinished:(RACSignal *)actual;

@end
