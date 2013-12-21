#import "EXPMatchers+sendValues.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessageBuilder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLSignalTestRecorder.h"

EXPMatcherImplementationBegin(sendValues, (id expected))

__block LLSignalTestRecorder *actualRecorder = nil;
__block LLSignalTestRecorder *expectedRecorder = nil;

void (^subscribe)(void) = ^{
    if(!actualRecorder) {
        actualRecorder = LLRMRecorderForObject(actual);
    }
};

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual);
});

match(^BOOL{
    subscribe();
    return LLRMContainsAllValuesUnordered(actualRecorder, expected);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:expected] expectedBehaviour:@"to not contain all of the same values as"] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    return [[[LLReactiveMatchersMessageBuilder messageWithActual:actual expected:expected] expectedBehaviour:@"to contain all the values of"] build];
});

EXPMatcherImplementationEnd
