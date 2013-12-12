#import "EXPMatchers+haveIdenticalValues.h"

EXPMatcherImplementationBegin(haveIdenticalValues, (RACSignal *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestProxy *actualProxy = nil;
__block LLSignalTestProxy *expectedProxy = nil;

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    if(!actualProxy) {
        actualProxy = [LLSignalTestProxy testProxyWithSignal:actual];
    }
    if(!expectedProxy) {
        expectedProxy = [LLSignalTestProxy testProxyWithSignal:expected];
    }
    
    if(!actualProxy.hasFinished || !expectedProxy.hasFinished) {
        return NO;
    }
    
    return identicalValues(actualProxy, expectedProxy);
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
    
    return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(actualProxy.values), EXPDescribeObject(expectedProxy.values)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(actualProxy.values), EXPDescribeObject(expectedProxy.values)];
});

EXPMatcherImplementationEnd
