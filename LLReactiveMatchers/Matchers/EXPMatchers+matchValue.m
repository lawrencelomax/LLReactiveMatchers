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
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    if(notRecievedCount) {
        NSString *expectedBehaviour = [NSString stringWithFormat:@"to match value at index %@", @(valueIndex)];
        NSString *actualBehaviour = [NSString stringWithFormat:@"only %@ values sent", @(actualRecorder.valuesSentCount)];
        return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:expectedBehaviour] actualBehaviour:actualBehaviour] build];
    }
    
    NSString *expectedBehaviour = [NSString stringWithFormat:@"to match value at index %@", @(valueIndex)];
    NSString *actualBehaviour = [NSString stringWithFormat:@"did not match value at index %@", @(valueIndex)];
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:expectedBehaviour] actualBehaviour:actualBehaviour] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    NSString *expectedBehaviour = [NSString stringWithFormat:@"to not match value at index %@", @(valueIndex)];
    NSString *actualBehaviour = [NSString stringWithFormat:@"matched value at index %@", @(valueIndex)];
    return [[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:expectedBehaviour] actualBehaviour:actualBehaviour] build];
});

EXPMatcherImplementationEnd
