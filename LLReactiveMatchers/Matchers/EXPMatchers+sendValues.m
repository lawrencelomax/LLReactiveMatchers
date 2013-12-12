#import "EXPMatchers+sendValues.h"

EXPMatcherImplementationBegin(sendValues, (NSArray *expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

__block LLSignalTestProxy *actualProxy;

prerequisite(^BOOL{
    if(correctClasses) {
        actualProxy = [LLSignalTestProxy testProxyWithSignal:actual];
        return YES;
    }
    
    return NO;
});

match(^BOOL{
    return containsAllValuesUnordered(actualProxy, expected);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return @"Did not contain all values";
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    return @"Contained all values";
});

EXPMatcherImplementationEnd
