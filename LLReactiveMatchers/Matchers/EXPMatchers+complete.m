#import "EXPMatchers+complete.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessageBuilder.h"

EXPMatcherImplementationBegin(complete, (void))

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
    
    return actualRecorder.hasCompleted;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    if(!(actualRecorder.hasCompleted || actualRecorder.hasErrored)) {
        return [LLReactiveMatchersMessageBuilder actualNotFinished:actualRecorder];
    }
    
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:@"complete"] actualBehaviour:@"error instead of completion"] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:@"not complete"] actualBehaviour:@"completed"] build];
});

EXPMatcherImplementationEnd
