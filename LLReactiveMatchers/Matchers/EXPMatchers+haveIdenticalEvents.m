#import "EXPMatchers+haveIdenticalEvents.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

EXPMatcherImplementationBegin(haveIdenticalEvents, (RACSignal *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestRecorder *actualRecorder = nil;
__block LLSignalTestRecorder *expectedRecorder = nil;

void (^subscribe)(void) = ^{
    if(!actualRecorder) {
        actualRecorder = [LLSignalTestRecorder recordWithSignal:actual];
    }
    if(!expectedRecorder) {
        expectedRecorder = [LLSignalTestRecorder recordWithSignal:expected];
    }
};

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    subscribe();
    
    if(!actualRecorder.hasFinished || !expectedRecorder.hasFinished) {
        return NO;
    }
    
    return identicalValues(actualRecorder, expectedRecorder) && identicalFinishingStatus(actualRecorder, expectedRecorder) && identicalErrors(actualRecorder, expectedRecorder);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!actualRecorder.hasFinished) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!expectedRecorder.hasFinished) {
        return [LLReactiveMatchersMessages expectedNotFinished:expected];
    }
    if(!identicalValues(actualRecorder, expectedRecorder)) {
        return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(actualRecorder.values), EXPDescribeObject(expectedRecorder.values)];
    }
    return [NSString stringWithFormat:@"Actual %@ does not have the same finishing event as %@", LLDescribeSignal(actual), LLDescribeSignal(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Actual %@ has all the same events as %@", LLDescribeSignal(actual), LLDescribeSignal(expected)];
});

EXPMatcherImplementationEnd
