#import "EXPMatchers+sendValues.h"

EXPMatcherImplementationBegin(sendValues, (NSArray *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];
__block LLSignalTestRecorder *actualRecorder = nil;

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    if(!actualRecorder) {
        actualRecorder = [LLSignalTestRecorder recordWithSignal:actual];
    }
    
    return containsAllValuesUnordered(actualRecorder, expected);
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
