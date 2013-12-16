#import "EXPMatchers+sendError.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessages.h"
#import "LLReactiveMatchersHelpers.h"

EXPMatcherImplementationBegin(sendError, (NSError *expected))

__block LLSignalTestRecorder *actualRecorder;

void (^subscribe)() = ^{
    if(!actualRecorder) {
        actualRecorder = LLRMRecorderForObject(actual);
    }
};

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual);
});

match(^BOOL{
    subscribe();
    return actualRecorder.hasErrored && LLRMIdenticalErrors(actualRecorder, expected);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!(actualRecorder.hasCompleted || actualRecorder.hasErrored)) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!actualRecorder.hasErrored) {
        return [NSString stringWithFormat:@"Signal %@ did not finish in error", LLDescribeSignal(actual)];
    }
    
    return [NSString stringWithFormat:@"Actual %@ does not have the same error as %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Actual %@ has the same error as %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

EXPMatcherImplementationEnd
