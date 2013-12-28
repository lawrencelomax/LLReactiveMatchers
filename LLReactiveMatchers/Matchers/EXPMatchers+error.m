#import "EXPMatchers+error.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessageBuilder.h"

EXPMatcherImplementationBegin(error, (void))

__block LLSignalTestRecorder *actualRecorder = nil;

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
    
    return actualRecorder.hasErrored;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    if(!(actualRecorder.hasCompleted || actualRecorder.hasErrored)) {
        return [LLReactiveMatchersMessageBuilder actualNotFinished:actualRecorder];
    }
    
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:@"error"] actualBehaviour:@"completed"] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:@"not error"] actualBehaviour:@"errored"] build];
});

EXPMatcherImplementationEnd
