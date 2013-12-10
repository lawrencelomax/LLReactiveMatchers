#import "EXPMatchers+haveIdenticalValues.h"

EXPMatcherImplementationBegin(haveIdenticalValues, (RACSignal *expected))

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
    
    return identicalValues(leftProxy, rightProxy);
});

failureMessageForTo(^NSString *{
    return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
});

failureMessageForNotTo(^NSString *{
    return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(leftProxy.values), EXPDescribeObject(rightProxy.values)];
});

EXPMatcherImplementationEnd
