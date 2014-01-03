//
//  LLReactiveMatchersFixtures.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

extern NSString *const LLReactiveMatcherFixtureErrorDomain;
extern NSError * LLReactiveMatchersFixtureError();

#define LLSpecError LLReactiveMatchersFixtureError()

@interface LLReactiveMatchersFixtures : NSObject

/// Values are sent synchronously then signal completes all synchronously
+ (RACSignal *) values:(NSArray *)values;

+ (RACSignal *) valuesAsynchronously:(NSArray *)values;

@end

@interface RACSignal (LLRMTestHelpers)

// Delays events a little by sending them on a background scheduler
- (RACSignal *) asyncySignal;

@end
