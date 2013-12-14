#import "EXPMatchers+sendValues.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessages.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLSignalTestRecorder.h"

EXPMatcherImplementationBegin(sendValues, (NSArray *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];
__block LLSignalTestRecorder *actualRecorder = nil;

void (^subscribe)(void) = ^{
    if(!actualRecorder) {
        actualRecorder = [LLSignalTestRecorder recordWithSignal:actual];
    }
};

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    subscribe();
    return containsAllValuesUnordered(actualRecorder, expected);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ does not contain all values %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ contains all values %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

EXPMatcherImplementationEnd
