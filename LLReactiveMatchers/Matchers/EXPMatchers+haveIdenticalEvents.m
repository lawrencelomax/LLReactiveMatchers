#import "EXPMatchers+haveIdenticalEvents.h"

static BOOL identicalEvents(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    return [leftProxy.values isEqualToArray:rightProxy.values];
}

static BOOL finishedTheSame(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    return (leftProxy.hasCompleted == rightProxy.hasCompleted) && (leftProxy.hasErrored == rightProxy.hasErrored);
}

static BOOL errorIsTheSame(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    if(leftProxy.error == rightProxy.error) {
        return YES;
    }
    return [leftProxy.error isEqual:rightProxy.error];
}

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
    
    return identicalEvents(leftProxy, rightProxy) && finishedTheSame(leftProxy, rightProxy) && errorIsTheSame(leftProxy, rightProxy);
});

failureMessageForTo(^NSString *{
    if( !identicalEvents(leftProxy, rightProxy) ) {
        return [NSString stringWithFormat:@"Events %@ are not the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
    } else if( !finishedTheSame(leftProxy, rightProxy) ) {
        return @"Signals did not end the same";
    } else {
        return @"Signals did not have the same errors";
    }
});

failureMessageForNotTo(^NSString *{
    if( !identicalEvents(leftProxy, rightProxy) ) {
        return [NSString stringWithFormat:@"Events %@ are the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
    } else if( !finishedTheSame(leftProxy, rightProxy) ) {
        return @"Signals end the same";
    } else {
        return @"Signals have the same errors";
    }
});

EXPMatcherImplementationEnd