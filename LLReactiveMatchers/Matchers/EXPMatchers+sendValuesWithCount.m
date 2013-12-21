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
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual] expectedBehaviour:[NSString stringWithFormat:@"to send %@ events", @(expected)]] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual] expectedBehaviour:[NSString stringWithFormat:@"to send %@ next events", @(expected)]] build];
});

EXPMatcherImplementationEnd
