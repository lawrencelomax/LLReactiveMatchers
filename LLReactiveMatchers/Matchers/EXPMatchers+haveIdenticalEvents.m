#import "EXPMatchers+haveIdenticalEvents.h"

EXPMatcherImplementationBegin(haveIdenticalEvents, (RACSignal *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestRecorder *actualRecorder = nil;
__block LLSignalTestRecorder *expectedRecorder = nil;

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    if(!actualRecorder) {
        actualRecorder = [LLSignalTestRecorder recordWithSignal:actual];
    }
    if(!expectedRecorder) {
        expectedRecorder = [LLSignalTestRecorder recordWithSignal:expected];
    }
    
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
    if( !identicalValues(actualRecorder, expectedRecorder) ) {
        return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(actualRecorder.values), EXPDescribeObject(expectedRecorder.values)];
    }
    return [NSString stringWithFormat:@"Actual %@ does not have the same finishing event as %@", LLDescribeSignal(actual), LLDescribeSignal(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!identicalValues(actualRecorder, expectedRecorder) ) {
        return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(actualRecorder.values), EXPDescribeObject(expectedRecorder.values)];
    }
    return [NSString stringWithFormat:@"Actual %@ has the same finishing event as %@", LLDescribeSignal(actual), LLDescribeSignal(expected)];
});

EXPMatcherImplementationEnd