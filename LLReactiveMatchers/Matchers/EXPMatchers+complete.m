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
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    @synchronized(actual) {
        if(!(actualRecorder.hasCompleted || actualRecorder.hasErrored)) {
            return [LLReactiveMatchersMessageBuilder actualNotFinished:actual];
        }
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:@"completion"] expectedBehaviour:@"to complete"] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:@"error"] expectedBehaviour:@"to error"] build];
});

EXPMatcherImplementationEnd
