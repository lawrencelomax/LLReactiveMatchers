#import "EXPMatchers+complete.h"

EXPMatcherImplementationBegin(complete, (void))

BOOL actualClassCorrect = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestProxy *actualProxy;

prerequisite(^BOOL{
    if(actualClassCorrect) {
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
    if(!actualClassCorrect) {
        return @"Matcher not provided with correct classes";
    }
    if(!actualProxy.hasFinished) {
        return @"Signal has not finished";
    }

    return @"Signal finished with error";
});

failureMessageForNotTo(^NSString *{
    if(!actualClassCorrect) {
        return @"Matcher not provided with correct classes";
    }
    
    return @"Signal completed";
});

EXPMatcherImplementationEnd
