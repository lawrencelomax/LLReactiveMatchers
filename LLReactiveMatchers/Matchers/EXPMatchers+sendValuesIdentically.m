#import "EXPMatchers+sendValuesIdentically.h"

#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

EXPMatcherImplementationBegin(sendValuesIdentically, (NSArray *expected))

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
    return LLRMIdenticalValues(actualRecorder.values, expected);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ does not have identical values to %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ has identical values to %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

EXPMatcherImplementationEnd
