#import "EXPMatchers+sendError.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessageBuilder.h"
#import "LLReactiveMatchersHelpers.h"

EXPMatcherImplementationBegin(sendError, (id expected))

__block LLSignalTestRecorder *actualRecorder = nil;
__block LLSignalTestRecorder *expectedRecorder = nil;

void (^subscribe)() = ^{
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
    return actualRecorder.hasErrored && LLRMIdenticalErrors(actualRecorder, expectedRecorder);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    if(!(actualRecorder.hasCompleted || actualRecorder.hasErrored)) {
        return [LLReactiveMatchersMessageBuilder actualNotFinished:actual];
    }
    if(!actualRecorder.hasErrored) {
        return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:expected] expectedBehaviour:@"to finish in error"] build];
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:expected] expectedBehaviour:@"to have the same error as"] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:expected] expectedBehaviour:@"to not have the same error as"] build];
});

EXPMatcherImplementationEnd
