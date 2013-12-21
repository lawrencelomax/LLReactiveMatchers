#import "EXPMatchers+matchValue.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessageBuilder.h"

EXPMatcherImplementationBegin(matchValue, (NSUInteger valueIndex, BOOL(^matchBlock)(id value)) )

__block LLSignalTestRecorder *actualRecorder;
__block BOOL notRecievedCount;

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
    
    if(valueIndex < actualRecorder.valuesSentCount) {
        notRecievedCount = NO;
        BOOL matched = matchBlock(actualRecorder.values[valueIndex]);
        return matched;
    }
    
    notRecievedCount = YES;
    return NO;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    if(notRecievedCount) {
        return [[[[LLReactiveMatchersMessageBuilder messageWithActual:actual] expectedBehaviour:@"to match value at index %@"] actualBehaviour:@"too few values sent"] build];
    }
    
    return [NSString stringWithFormat:@"Match failed at index %lu", (unsigned long)valueIndex];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Match succeeded at index %lu", (unsigned long)valueIndex];
});

EXPMatcherImplementationEnd
