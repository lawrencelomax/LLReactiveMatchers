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
    
    if(!(actualRecorder.hasFinished && expectedRecorder.hasFinished)) {
        return NO;
    }
    
    return LLRMIdenticalValues(actualRecorder, expectedRecorder) && LLRMIdenticalFinishingStatus(actualRecorder, expectedRecorder) && LLRMIdenticalErrors(actualRecorder, expectedRecorder);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    if(!actualRecorder.hasFinished) {
        return [LLReactiveMatchersMessageBuilder actualNotFinished:actualRecorder];
    }
    if(!expectedRecorder.hasFinished) {
        return [LLReactiveMatchersMessageBuilder expectedNotFinished:expectedRecorder];
    }
    if(!LLRMIdenticalValues(actualRecorder, expectedRecorder)) {
        return [[[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] renderActualValues] expected:expectedRecorder] renderExpectedValues] build];
    }
    
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:@"finish in the same way as"] expected:expectedRecorder] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:@"not have events that are identical to"] expected:expectedRecorder] build];
});

EXPMatcherImplementationEnd
