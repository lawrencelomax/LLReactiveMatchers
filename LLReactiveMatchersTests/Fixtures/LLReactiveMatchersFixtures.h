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

@interface LLReactiveMatchersFixtures : NSObject

+ (RACSignal *) signalThatSendsValuesThenErrors;
+ (RACSignal *) signalThatSendsValuesThenCompletes;

@end
