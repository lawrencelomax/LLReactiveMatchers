#import "EXPMatchers+complete.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessages.h"
#import "LLSignalTestRecorder.h"

EXPMatcherImplementationBegin(complete, (void))

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
    
    return actualRecorder.hasCompleted;
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
   
    return [NSString stringWithFormat:@"Signal %@ finished in error instead of completion", LLDescribeSignal(actual)];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Signal %@ finished in completion instead of not completing", LLDescribeSignal(actual)];
});

EXPMatcherImplementationEnd
