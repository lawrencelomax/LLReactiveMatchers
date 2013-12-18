#import "EXPMatchers+matchValue.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

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
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(notRecievedCount) {
        return [NSString stringWithFormat:@"Could not match value at index %lu, as only %lu values sent", (unsigned long)valueIndex, (unsigned long)actualRecorder.valuesSentCount];
    }
    
    return [NSString stringWithFormat:@"Match failed at index %lu", (unsigned long)valueIndex];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Match succeeded at index %lu", (unsigned long)valueIndex];
});

EXPMatcherImplementationEnd
