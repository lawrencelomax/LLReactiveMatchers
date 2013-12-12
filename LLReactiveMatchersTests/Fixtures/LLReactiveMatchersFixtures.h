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

#define MI9SpecError LLReactiveMatchersFixtureError()

@interface LLReactiveMatchersFixtures : NSObject

/// Values are sent synchronously then signal completes all synchronously
+ (RACSignal *) values:(NSArray *)values;

+ (RACSignal *) valuesAsynchronously:(NSArray *)values;

@end
