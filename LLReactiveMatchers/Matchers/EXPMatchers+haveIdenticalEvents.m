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
    if( !identicalFinishingStatus(actualProxy, expectedProxy) ) {
        return @"Signals do not end the same";
    }
    
    return @"Signals do not have the same errors";
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!identicalValues(actualProxy, expectedProxy) ) {
        return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(actualProxy.values), EXPDescribeObject(expectedProxy.values)];
    }
    if( !identicalFinishingStatus(actualProxy, expectedProxy) ) {
        return @"Signals end the same";
    }
    
    return @"Signals have the same errors";
});

EXPMatcherImplementationEnd