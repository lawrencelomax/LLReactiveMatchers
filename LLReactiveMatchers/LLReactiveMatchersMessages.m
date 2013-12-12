//
//  LLReactiveMatchersMessages.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 12/12/2013.
//
//

#import "LLReactiveMatchersMessages.h"

extern NSString *LLDescribeSignal(RACSignal *signal) {
    return [signal name];
}

#import <Expecta/Expecta.h>

@implementation LLReactiveMatchersMessages

+ (NSString *) actualNotSignal:(id)actual {
    return [NSString stringWithFormat:@"Actual %@ is not a Signal", EXPDescribeObject(actual)];
}

+ (NSString *) actualNotFinished:(RACSignal *)actual {
    return [NSString stringWithFormat:@"Actual %@ has not finished", LLDescribeSignal(actual)];
}

+ (NSString *) expectedNotFinished:(RACSignal *)actual {
    return [NSString stringWithFormat:@"Expected %@ has not finished", LLDescribeSignal(actual)];
}

@end
