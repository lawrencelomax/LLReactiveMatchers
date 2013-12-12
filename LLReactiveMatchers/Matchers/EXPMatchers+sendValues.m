#import "EXPMatchers+sendValues.h"

EXPMatcherImplementationBegin(sendValues, (NSArray *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];
__block LLSignalTestProxy *actualProxy = nil;

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    if(!actualProxy) {
        actualProxy = [LLSignalTestProxy testProxyWithSignal:actual];
    }
    
    return containsAllValuesUnordered(actualProxy, expected);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ does not contain all values %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ contains all values %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

EXPMatcherImplementationEnd
