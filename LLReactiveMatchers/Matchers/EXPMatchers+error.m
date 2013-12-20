#import "EXPMatchers+error.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

EXPMatcherImplementationBegin(error, (void))

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
    
    return actualRecorder.hasErrored;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    @synchronized(actual) {
        if(!(actualRecorder.hasCompleted || actualRecorder.hasErrored)) {
            return [LLReactiveMatchersMessages actualNotFinished:actual];
        }
    }
    
    return [NSString stringWithFormat:@"Signal %@ finished in completion instead of error", LLDescribeSignal(actual)];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Signal %@ finished in error instead of not erroring", LLDescribeSignal(actual)];
});

EXPMatcherImplementationEnd
