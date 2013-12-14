#import "EXPMatchers+finish.h"

EXPMatcherImplementationBegin(finish, (void))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];
__block BOOL hasSubscribed = NO;
__block BOOL hasErrored = NO;
__block BOOL hasCompleted = NO;

void (^subscribe)(void) = ^{
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
    return correctClasses;
});

match(^BOOL{
    subscribe();
    
    return hasCompleted || hasErrored;
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [LLReactiveMatchersMessages actualNotFinished:actual];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(hasErrored) {
        return [NSString stringWithFormat:@"Signal %@ finished in error instead of not finishing", LLDescribeSignal(actual)];
    }
    
    return [NSString stringWithFormat:@"Signal %@ finished in completion instead of not finishing", LLDescribeSignal(actual)];
});

EXPMatcherImplementationEnd
