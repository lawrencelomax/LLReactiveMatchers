#import "EXPMatchers+haveIdenticalEvents.h"

EXPMatcherImplementationBegin(haveIdenticalEvents, (RACSignal *expected))

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
    if(!leftProxy.hasFinished || !rightProxy.hasFinished) {
        return NO;
    }
    
    bothFinished = YES;
    return identicalValues(leftProxy, rightProxy) && identicalFinishingStatus(leftProxy, rightProxy) && identicalErrors(leftProxy, rightProxy);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!bothFinished) {
        return @"Both Signals have not finished";
    } else if( !identicalValues(leftProxy, rightProxy) ) {
        return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
    } else if( !identicalFinishingStatus(leftProxy, rightProxy) ) {
        return @"Signals do not end the same";
    } else {
        return @"Signals do not have the same errors";
    }
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if( !identicalValues(leftProxy, rightProxy) ) {
        return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
    } else if( !identicalFinishingStatus(leftProxy, rightProxy) ) {
        return @"Signals end the same";
    } else {
        return @"Signals have the same errors";
    }
});

EXPMatcherImplementationEnd