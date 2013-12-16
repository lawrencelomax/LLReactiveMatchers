#import "EXPMatchers+haveIdenticalValues.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersMessages.h"
#import "LLReactiveMatchersHelpers.h"

EXPMatcherImplementationBegin(haveIdenticalValues, (RACSignal *expected))

__block LLSignalTestRecorder *actualRecorder = nil;
__block LLSignalTestRecorder *expectedRecorder = nil;

void (^subscribe)(void) = ^{
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
    
    if(!actualRecorder.hasFinished || !expectedRecorder.hasFinished) {
        return NO;
    }
    
    return LLRMIdenticalValues(actualRecorder, expectedRecorder);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!actualRecorder.hasFinished) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!expectedRecorder.hasFinished) {
        return [LLReactiveMatchersMessages expectedNotFinished:expected];
    }
    
    return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(actualRecorder.values), EXPDescribeObject(expectedRecorder.values)];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(actualRecorder.values), EXPDescribeObject(expectedRecorder.values)];
});

EXPMatcherImplementationEnd
