#import "EXPMatchers+complete.h"

EXPMatcherImplementationBegin(complete, (void))

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
    if(!actualProxy.hasFinished)  {
        return NO;
    }
    
    return actualProxy.hasCompleted;
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!actualProxy.hasFinished) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }

    return @"Signal finished with error";
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return @"Matcher not provided with correct classes";
    }
    
    return @"Signal completed";
});

EXPMatcherImplementationEnd
