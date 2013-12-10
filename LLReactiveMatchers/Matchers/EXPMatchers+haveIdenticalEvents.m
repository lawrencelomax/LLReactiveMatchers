#import "EXPMatchers+haveIdenticalEvents.h"

EXPMatcherImplementationBegin(haveIdenticalEvents, (RACSignal *expected))

BOOL correctClasses = ([expected isKindOfClass:RACSignal.class] && [actual isKindOfClass:RACSignal.class]);

__block LLSignalTestProxy *leftProxy;
__block LLSignalTestProxy *rightProxy;

prerequisite(^BOOL{
    if(correctClasses) {
        leftProxy = [actual testProxy];
        rightProxy = [expected testProxy];
    }
    
    return correctClasses;
});

match(^BOOL{
    if(!leftProxy.hasFinished || !rightProxy.hasFinished) {
        return NO;
    }
    
    return identicalValues(leftProxy, rightProxy) && identicalFinishingStatus(leftProxy, rightProxy) && identicalErrors(leftProxy, rightProxy);
});

failureMessageForTo(^NSString *{
    if( !identicalValues(leftProxy, rightProxy) ) {
        return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
    } else if( !identicalFinishingStatus(leftProxy, rightProxy) ) {
        return @"Signals do not end the same";
    } else {
        return @"Signals do not have the same errors";
    }
});

failureMessageForNotTo(^NSString *{
    if( !identicalValues(leftProxy, rightProxy) ) {
        return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
    } else if( !identicalFinishingStatus(leftProxy, rightProxy) ) {
        return @"Signals end the same";
    } else {
        return @"Signals have the same errors";
    }
});

EXPMatcherImplementationEnd