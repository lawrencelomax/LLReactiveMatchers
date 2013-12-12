#import "EXPMatchers+finish.h"

EXPMatcherImplementationBegin(finish, (void))

BOOL actualClassCorrect = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestProxy *actualProxy;

prerequisite(^BOOL{
    if(actualClassCorrect) {
        actualProxy = [actual testProxy];
        return YES;
    }
    
    return NO;
});

match(^BOOL{
    return actualProxy.hasFinished;
});

failureMessageForTo(^NSString *{
    if(!actualClassCorrect) {
        return @"Matcher not provided with correct classes";
    }
    
    return @"Signal has not finished";
});

failureMessageForNotTo(^NSString *{
    if(!actualClassCorrect) {
        return @"Matcher not provided with correct classes";
    }
    
    if(actualProxy.hasErrored) {
        return @"Signal errored";
    }
    
    return @"Signal completed";
});

EXPMatcherImplementationEnd
