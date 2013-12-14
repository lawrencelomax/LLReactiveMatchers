#import "EXPMatchers+haveIdenticalValues.h"

#import "LLSignalTestRecorder.h"
#import "LLReactiveMatchersMessages.h"
#import "LLReactiveMatchersHelpers.h"

EXPMatcherImplementationBegin(haveIdenticalValues, (RACSignal *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestRecorder *actualRecorder = nil;
__block LLSignalTestRecorder *expectedRecorder = nil;

void (^subscribe)(void) = ^{
    if(!actualRecorder) {
        actualRecorder = [LLSignalTestRecorder recordWithSignal:actual];
    }
    if(!expectedRecorder) {
        expectedRecorder = [LLSignalTestRecorder recordWithSignal:expected];
    }
};

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    subscribe();
    
    if(!actualRecorder.hasFinished || !expectedRecorder.hasFinished) {
        return NO;
    }
    
    return identicalValues(actualRecorder, expectedRecorder);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    if(!actualRecorder.hasFinished) {
        return [LLReactiveMatchersMessages actualNotFinished:actual];
    }
    if(!expectedRecorder.hasFinished) {
        return [LLReactiveMatchersMessages expectedNotFinished:expected];
    }
    
    return [NSString stringWithFormat:@"Values %@ are not the same as %@", EXPDescribeObject(actualRecorder.values), EXPDescribeObject(expectedRecorder.values)];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return [NSString stringWithFormat:@"Values %@ are the same as %@", EXPDescribeObject(actualRecorder.values), EXPDescribeObject(expectedRecorder.values)];
});

EXPMatcherImplementationEnd
