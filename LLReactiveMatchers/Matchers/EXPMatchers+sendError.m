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
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    if(!(actualRecorder.hasCompleted || actualRecorder.hasErrored)) {
        return [LLReactiveMatchersMessageBuilder actualNotFinished:actualRecorder];
    }
    if(!actualRecorder.hasErrored) {
        return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:@"error"] actualBehaviour:@"completed"] build];
    }
    if(!expectedRecorder.hasErrored) {
        return [[[[[LLReactiveMatchersMessageBuilder message] expected:expectedRecorder] expectedBehaviour:@"error"] actualBehaviour:@"completed"] build];
    }
    
    return [[[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expected:expectedRecorder] renderExpectedError] actualBehaviour:@"different errors"] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    return [[[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expected:expectedRecorder] renderExpectedError] actualBehaviour:@"the same error"] build];
});

EXPMatcherImplementationEnd
