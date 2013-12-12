#import "EXPMatchers+haveIdenticalEvents.h"

EXPMatcherImplementationBegin(haveIdenticalEvents, (RACSignal *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestProxy *actualProxy;
__block LLSignalTestProxy *expectedProxy;

prerequisite(^BOOL{
    if(correctClasses) {
        actualProxy = [LLSignalTestProxy testProxyWithSignal:actual];
        expectedProxy = [LLSignalTestProxy testProxyWithSignal:expected];
    }
    
    return correctClasses;
});

match(^BOOL{
    if(!actualProxy.hasFinished || !expectedProxy.hasFinished) {
        return NO;
    }
    
    return identicalValues(actualProxy, expectedProxy) && identicalFinishingStatus(actualProxy, expectedProxy) && identicalErrors(actualProxy, expectedProxy);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!actualProxy.hasFinished) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!expectedProxy.hasFinished) {
        return [LLReactiveMatchersMessages expectedNotFinished:expected];
    }
    if( !identicalValues(actualProxy, expectedProxy) ) {
        return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(actualProxy.values), EXPDescribeObject(expectedProxy.values)];
    }
    return [NSString stringWithFormat:@"Actual %@ does not have the same finishing event as %@", LLDescribeSignal(actual), LLDescribeSignal(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!identicalValues(actualProxy, expectedProxy) ) {
        return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(actualProxy.values), EXPDescribeObject(expectedProxy.values)];
    }
    return [NSString stringWithFormat:@"Actual %@ has the same finishing event as %@", LLDescribeSignal(actual), LLDescribeSignal(expected)];
});

EXPMatcherImplementationEnd