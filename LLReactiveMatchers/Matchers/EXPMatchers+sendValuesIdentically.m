#import "EXPMatchers+sendValuesIdentically.h"

#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

EXPMatcherImplementationBegin(sendValuesIdentically, (NSArray *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestRecorder *actualRecorder = nil;

void (^subscribe)(void) = ^{
    if(!actualRecorder) {
        actualRecorder = [LLSignalTestRecorder recordWithSignal:actual];
    }
};

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    subscribe();
    return LLRMIdenticalValues(actualRecorder.values, expected);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ does not have identical values to %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Signal %@ has identical values to %@", LLDescribeSignal(actual), EXPDescribeObject(expected)];
});

EXPMatcherImplementationEnd
