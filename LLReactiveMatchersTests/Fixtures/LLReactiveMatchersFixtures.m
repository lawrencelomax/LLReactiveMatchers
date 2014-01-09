//
//  LLReactiveMatchersFixtures.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "LLReactiveMatchersFixtures.h"

#define LLTestError LLReactiveMatchersFixtureError()

NSString *const LLReactiveMatcherFixtureErrorDomain = @"com.github.lawrencelomax.llreactivematchers.fixture";

extern NSError * LLReactiveMatchersFixtureError() {
    static NSError *error;
    if(!error) {
        error = [NSError errorWithDomain:LLReactiveMatcherFixtureErrorDomain code:0 userInfo:@{}];
    }
    return error;
}

@implementation LLReactiveMatchersFixtures

+ (RACSignal *) values:(NSArray *)values {
    return [[values.rac_sequence signalWithScheduler:RACScheduler.immediateScheduler] setNameWithFormat:@"values %@", EXPDescribeObject(values)];
}

@end

@implementation RACSignal (LLRMTestHelpers)

- (RACSignal *) asyncySignal {
    // Not a great place to set this globally, but as good as any
    [Expecta setAsynchronousTestTimeout:0.2];
    
    // -delay: will always immediately send errors, we want to avoid that
    return [[[[[self materialize] delay:0.01] dematerialize] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]]
        setNameWithFormat:@"%@", self.name];
}

@end