#import "EXPMatchers+sendError.h"

EXPMatcherImplementationBegin(sendError, (NSError *expected))

BOOL classesAreCorrect = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestProxy *actualProxy;
__block BOOL actualFinished = NO;

prerequisite(^BOOL{
    if(classesAreCorrect) {
        actualProxy = [LLSignalTestProxy testProxyWithSignal:actual];
        return YES;
    }
    
    return NO;
});

match(^BOOL{
    if(!actualProxy.hasFinished) {
        return NO;
    }
    
    actualFinished = YES;
    return identicalErrors(actualProxy.error, expected) && actualProxy.hasErrored;
});

failureMessageForTo(^NSString *{
    if(!classesAreCorrect) {
        return @"Matcher not provided with correct classes";
    }
    if(!actualFinished) {
        return @"Signal has not finished";
    }
    if(!actualProxy.hasErrored) {
        return @"Signal did not finish in error";
    }
    
    return [NSString stringWithFormat:@"Errors are not the same"];
});

failureMessageForNotTo(^NSString *{
    if(!classesAreCorrect) {
        return @"Matcher not provided with correct classes";
    }
    if(!actualFinished) {
        return @"Signal has not finished";
    }
    
    return [NSString stringWithFormat:@"Errors are the same"];
});

EXPMatcherImplementationEnd
