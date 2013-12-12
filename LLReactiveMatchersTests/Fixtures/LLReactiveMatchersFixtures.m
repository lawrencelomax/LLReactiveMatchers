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

+ (RACSignal *) valuesAsynchronously:(NSArray *)values {
    return [[[values.rac_sequence signalWithScheduler:RACScheduler.scheduler] delay:0.1] setNameWithFormat:@"values %@", EXPDescribeObject(values)];
}

@end