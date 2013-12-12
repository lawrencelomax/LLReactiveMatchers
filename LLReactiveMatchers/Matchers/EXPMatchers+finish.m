#import "EXPMatchers+finish.h"

EXPMatcherImplementationBegin(finish, (void))

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
    return actualProxy.hasFinished;
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
    if(actualProxy.hasErrored) {
        return @"Signal errored";
    }
    
    return @"Signal completed";
});

EXPMatcherImplementationEnd
