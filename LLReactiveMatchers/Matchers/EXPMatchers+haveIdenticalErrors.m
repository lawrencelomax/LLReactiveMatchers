#import "EXPMatchers+haveIdenticalErrors.h"

EXPMatcherImplementationBegin(haveIdenticalErrors, (RACSignal *expected))

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
    if(!actualProxy.hasFinished && !expectedProxy.hasFinished) {
        return NO;
    }
    
    return identicalErrors(actualProxy, expectedProxy) && actualProxy.hasErrored && expectedProxy.hasErrored;
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
    else if(identicalErrors(actualProxy, expectedProxy)) {
        return @"Both signals did not error";
    }
    
    return @"Signals have different errors";
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!identicalErrors(actualProxy, expectedProxy)) {
        return @"Both signals did not error";
    }
    
    return @"Signals have the same errors";
});

EXPMatcherImplementationEnd
