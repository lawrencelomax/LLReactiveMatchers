#import "EXPMatchers+finish.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

EXPMatcherImplementationBegin(finish, (void))

__block LLSignalTestRecorder *actualRecorder;

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
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [LLReactiveMatchersMessages actualNotFinished:actual];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(actualRecorder.hasErrored) {
        return [NSString stringWithFormat:@"Signal %@ finished in error instead of not finishing", LLDescribeSignal(actual)];
    }
    
    return [NSString stringWithFormat:@"Signal %@ finished in completion instead of not finishing", LLDescribeSignal(actual)];
});

EXPMatcherImplementationEnd
