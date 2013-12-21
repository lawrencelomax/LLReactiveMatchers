#import "EXPMatchers+finish.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessageBuilder.h"

EXPMatcherImplementationBegin(finish, (void))

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
    
    return actualRecorder.hasCompleted || actualRecorder.hasErrored;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    
    return [LLReactiveMatchersMessageBuilder actualNotFinished:actual];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    if(actualRecorder.hasErrored) {
        return [[[[LLReactiveMatchersMessageBuilder messageWithActual:actual] expectedBehaviour:@"to finish in error"] actualBehaviour:@"did not error"] build];
    }
    
    return [[[[LLReactiveMatchersMessageBuilder messageWithActual:actual] expectedBehaviour:@"to not complete"] actualBehaviour:@"did complete"] build];
});

EXPMatcherImplementationEnd
