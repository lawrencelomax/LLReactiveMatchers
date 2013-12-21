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
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    @synchronized(actual) {
        if(!(actualRecorder.hasCompleted || actualRecorder.hasErrored)) {
            return [LLReactiveMatchersMessageBuilder actualNotFinished:actual];
        }
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual] expectedBehaviour:@"to finish in completion"] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual] expectedBehaviour:@"to finish in error"] build];
});

EXPMatcherImplementationEnd
