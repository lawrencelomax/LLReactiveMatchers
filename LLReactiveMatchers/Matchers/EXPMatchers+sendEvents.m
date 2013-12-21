#import "EXPMatchers+sendEvents.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessageBuilder.h"

EXPMatcherImplementationBegin(sendEvents, (id expected))

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
    
    return LLRMIdenticalValues(actualRecorder, expectedRecorder) && LLRMIdenticalFinishingStatus(actualRecorder, expectedRecorder) && LLRMIdenticalErrors(actualRecorder, expectedRecorder);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    if(!actualRecorder.hasFinished) {
        return [LLReactiveMatchersMessageBuilder actualNotFinished:actual];
    }
    if(!expectedRecorder.hasFinished) {
        return [LLReactiveMatchersMessageBuilder expectedNotFinished:expected];
    }
    if(!LLRMIdenticalValues(actualRecorder, expectedRecorder)) {
        return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(actualRecorder.values), EXPDescribeObject(expectedRecorder.values)];
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:expected] expectedBehaviour:@"to have the same finishing event as"] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:expected] expectedBehaviour:@"to have identical events as"] build];
});

EXPMatcherImplementationEnd
