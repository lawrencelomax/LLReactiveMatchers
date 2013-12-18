#import "EXPMatchers+matchValues.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLReactiveMatchersMessages.h"

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
    
    return passed;
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Failed to match value %@ at index %ld", failingValue, (long)failingIndex];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return @"Signal matched all available values";
});

EXPMatcherImplementationEnd
