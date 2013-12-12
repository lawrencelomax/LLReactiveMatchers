#import "EXPMatchers+haveIdenticalValues.h"

EXPMatcherImplementationBegin(haveIdenticalValues, (RACSignal *expected))

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
    return identicalValues(leftProxy, rightProxy);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!bothFinished) {
        return @"Both Signals have not finished";
    }
    
    return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
});

EXPMatcherImplementationEnd
