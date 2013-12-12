#import "EXPMatchers+haveIdenticalErrors.h"

EXPMatcherImplementationBegin(haveIdenticalErrors, (RACSignal *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestProxy *leftProxy;
__block LLSignalTestProxy *rightProxy;
__block BOOL bothFinished = NO;

prerequisite(^BOOL{
    if(correctClasses) {
        leftProxy = [LLSignalTestProxy testProxyWithSignal:actual];
        rightProxy = [LLSignalTestProxy testProxyWithSignal:expected];
    }
    
    return correctClasses;
});

match(^BOOL{
    if(!leftProxy.hasFinished && !rightProxy.hasFinished) {
        return NO;
    }
    
    bothFinished = YES;
    return identicalErrors(leftProxy, rightProxy) && leftProxy.hasErrored && rightProxy.hasErrored;
});

failureMessageForTo(^NSString *{
    if (!bothFinished) {
        return @"Both Signals have not finished";
    } else if(identicalErrors(leftProxy, rightProxy)) {
        return @"Both signals did not error";
    }
    
    return @"Signals have different errors";
});

failureMessageForNotTo(^NSString *{
    if(!identicalErrors(leftProxy, rightProxy)) {
        return @"Both signals did not error";
    }
    
    return @"Signals have the same errors";
});

EXPMatcherImplementationEnd
