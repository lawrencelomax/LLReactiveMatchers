#import "EXPMatchers+matchValues.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessageBuilder.h"

EXPMatcherImplementationBegin(matchValues, (BOOL(^matchBlock)(NSUInteger index, id value) ) )

__block LLSignalTestRecorder *actualRecorder;
__block id failingValue;
__block NSUInteger failingIndex;

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
    
    __block BOOL passed = YES;
    [actualRecorder.values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL pass = matchBlock(idx, obj);
        if(!pass) {
            *stop = YES;
            passed = NO;
            failingValue = obj;
            failingIndex = idx;
        }
    }];
    
    return passed && actualRecorder.hasFinished;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    if(!actualRecorder.hasFinished) {
        return [LLReactiveMatchersMessageBuilder actualNotFinished:actualRecorder];
    }
    
    NSString *expectedBehaviour = [NSString stringWithFormat:@"match value %@ at index %@", failingValue, @(failingIndex)];
    return [[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:expectedBehaviour] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    if(!actualRecorder.hasFinished) {
        return [LLReactiveMatchersMessageBuilder actualNotFinished:actualRecorder];
    }
    
    NSString *expectedBehaviour = @"not match all values";
    return [[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] expectedBehaviour:expectedBehaviour] build];
});

EXPMatcherImplementationEnd
