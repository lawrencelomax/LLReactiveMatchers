#import "EXPMatchers+sendError.h"

EXPMatcherImplementationBegin(sendError, (NSError *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestProxy *actualProxy;

prerequisite(^BOOL{
    if(correctClasses) {
        actualProxy = [LLSignalTestProxy testProxyWithSignal:actual];
        return YES;
    }
    
    return NO;
});

match(^BOOL{
    if(!actualProxy.hasFinished) {
        return NO;
    }
    
    return identicalErrors(actualProxy.error, expected) && actualProxy.hasErrored;
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!actualProxy.hasFinished) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!actualProxy.hasErrored) {
        return @"Signal did not finish in error";
    }
    
    return [NSString stringWithFormat:@"Errors are not the same"];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Errors are the same"];
});

EXPMatcherImplementationEnd
