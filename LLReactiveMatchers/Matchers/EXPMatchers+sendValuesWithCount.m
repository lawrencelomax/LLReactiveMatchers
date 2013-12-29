#import "EXPMatchers+sendValuesWithCount.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessageBuilder.h"
#import "LLReactiveMatchersHelpers.h"

EXPMatcherImplementationBegin(sendValuesWithCount, (NSUInteger expected))

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
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    NSString *expectedBehaviour = [NSString stringWithFormat:@"send %@ events", @(expected)];
    NSString *actualBehaviour = [NSString stringWithFormat:@"%@ events sent", @(actualRecorder.valuesSentCount)];
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:expectedBehaviour] actualBehaviour:actualBehaviour] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    NSString *expectedBehaviour = [NSString stringWithFormat:@"not send %@ events", @(expected)];
    NSString *actualBehaviour = [NSString stringWithFormat:@"%@ events sent", @(actualRecorder.valuesSentCount)];
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:expectedBehaviour] actualBehaviour:actualBehaviour] build];
});

EXPMatcherImplementationEnd
