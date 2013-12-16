#import "EXPMatchers+complete.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessages.h"

EXPMatcherImplementationBegin(complete, (void))

__block BOOL hasSubscribed = NO;
__block BOOL hasCompleted = NO;
__block BOOL hasErrored = NO;

void (^subscribe)() = ^{
    if(!hasSubscribed) {
        [self.rac_deallocDisposable addDisposable:
         [actual subscribeError:^(NSError *error) {
            @synchronized(actual) {
                hasErrored = YES;
            }
        } completed:^{
            @synchronized(actual) {
                hasCompleted = YES;
            }
        }]];
        hasSubscribed = YES;
    }
};

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual);
});

match(^BOOL{
    subscribe();
    
    return hasCompleted;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    @synchronized(actual) {
        if(!(hasCompleted || hasErrored)) {
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
