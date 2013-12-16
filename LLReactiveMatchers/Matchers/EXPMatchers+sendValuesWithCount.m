#import "EXPMatchers+sendValuesWithCount.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessages.h"
#import "LLReactiveMatchersHelpers.h"

EXPMatcherImplementationBegin(sendValuesWithCount, (NSInteger expected))

__block LLSignalTestRecorder *actualRecorder;

void (^subscribe)() = ^{
    if(!actualRecorder) {
        actualRecorder = LLRMRecorderForObject(actual);
    }
};

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual);
});

match(^BOOL{
    subscribe();
    return (actualRecorder.valuesSentCount == expected);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Actual %@ sent %ld next events instead of %ld", LLDescribeSignal(actual), (long)actualRecorder.valuesSentCount, (long)expected];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Actual %@ sent %ld next events", LLDescribeSignal(actual), (long)expected];
});

EXPMatcherImplementationEnd
