#import "EXPMatchers+haveIdenticalErrors.h"

#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

EXPMatcherImplementationBegin(haveIdenticalErrors, (RACSignal *expected))

__block BOOL hasSubscribed = NO;
__block BOOL actualHasErrored = NO;
__block BOOL actualHasCompleted = NO;
__block BOOL expectedHasErrored = NO;
__block BOOL expectedHasCompleted = NO;
__block NSError *actualError = nil;
__block NSError *expectedError = nil;

void (^subscribe)() = ^(){
    if(!hasSubscribed) {
        [self.rac_deallocDisposable addDisposable:
         [actual subscribeError:^(NSError *error) {
            @synchronized(actual) {
                actualHasErrored = YES;
                actualError = error;
            }
        } completed:^{
            @synchronized(actual) {
                actualHasCompleted = YES;
            }
        }]];
        
        [self.rac_deallocDisposable addDisposable:
         [expected subscribeError:^(NSError *error) {
            @synchronized(actual) {
                expectedHasErrored = YES;
                expectedError = error;
            }
        } completed:^{
            @synchronized(actual) {
                expectedHasCompleted = YES;
            }
        }]];
    }
    
    hasSubscribed = YES;
};

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual);
});

match(^BOOL{
    subscribe();
    
    return LLRMIdenticalErrors(actualError, expectedError) && actualHasErrored && expectedHasErrored;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!(actualHasErrored || actualHasCompleted)) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!(expectedHasErrored || expectedHasCompleted)) {
        return [LLReactiveMatchersMessages expectedNotFinished:expected];
    }
    
    return [NSString stringWithFormat:@"Actual error in Signal %@ not the same as expected error in Signal %@", LLDescribeSignal(actual), LLDescribeSignal(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return @"Signals have the same errors";
});

EXPMatcherImplementationEnd
