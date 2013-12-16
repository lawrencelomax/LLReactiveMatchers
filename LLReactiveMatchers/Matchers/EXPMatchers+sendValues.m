#import "EXPMatchers+sendValues.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessages.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLSignalTestRecorder.h"

EXPMatcherImplementationBegin(sendValues, (NSArray *expected))

__block LLSignalTestRecorder *actualRecorder = nil;

void (^subscribe)(void) = ^{
    if(!actualRecorder) {
        actualRecorder = LLRMRecorderForObject(actual);
    }
};

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual);
});

match(^BOOL{
    subscribe();
    return LLRMContainsAllValuesUnordered(actualRecorder, expected);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ does not contain all values %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ contains all values %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

EXPMatcherImplementationEnd
