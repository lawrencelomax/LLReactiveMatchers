#import "EXPMatchers+sendError.h"

EXPMatcherImplementationBegin(sendError, (NSError *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];
__block BOOL hasErrored = NO;
__block BOOL hasCompleted = NO;
__block NSError *errorReceived = nil;

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    [self.rac_deallocDisposable addDisposable:
     [actual subscribeError:^(NSError *error) {
        @synchronized(actual) {
            hasErrored = YES;
            errorReceived = error;
        }
    } completed:^{
        @synchronized(actual) {
            hasCompleted = YES;
        }
    }]];
    
    return hasErrored && identicalErrors(errorReceived, expected);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!(hasCompleted || hasErrored)) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!hasErrored) {
        return [NSString stringWithFormat:@"Signal %@ did not finish in error", LLDescribeSignal(actual)];
    }
    
    return [NSString stringWithFormat:@"Actual %@ does not have the same error as %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Actual %@ has the same error as %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

EXPMatcherImplementationEnd
