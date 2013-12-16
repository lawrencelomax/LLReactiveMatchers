#import "EXPMatchers+haveIdenticalErrors.h"

#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

EXPMatcherImplementationBegin(haveIdenticalErrors, (RACSignal *expected))

__block LLSignalTestRecorder *actualRecorder;
__block LLSignalTestRecorder *expectedRecorder;

void (^subscribe)() = ^(){
    if(!actualRecorder) {
        actualRecorder = LLRMRecorderForObject(actual);
    }
    if(!expectedRecorder) {
        expectedRecorder = LLRMRecorderForObject(expected);
    }
};

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual);
});

match(^BOOL{
    subscribe();
    
    return LLRMIdenticalErrors(actualRecorder.error, expectedRecorder.error) && actualRecorder.hasErrored && expectedRecorder.hasErrored;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!(actualRecorder.hasErrored || actualRecorder.hasCompleted)) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!(expectedRecorder.hasErrored || expectedRecorder.hasCompleted)) {
        return [LLReactiveMatchersMessages expectedNotFinished:expected];
    }
    
    return [NSString stringWithFormat:@"Actual error in Signal %@ not the same as expected error in Signal %@", LLDescribeSignal(actual), LLDescribeSignal(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return @"Signals have the same errors";
});

EXPMatcherImplementationEnd
