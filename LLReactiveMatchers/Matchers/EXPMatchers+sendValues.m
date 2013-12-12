#import "EXPMatchers+sendValues.h"

EXPMatcherImplementationBegin(sendValues, (NSArray *expected))

BOOL expectedClassCorrect = [expected isKindOfClass:NSArray.class] || expected == nil;
BOOL actualClassCorrect = [actual isKindOfClass:RACSignal.class];
BOOL classesAreCorrect = expectedClassCorrect && actualClassCorrect;

__block LLSignalTestProxy *actualProxy;

prerequisite(^BOOL{
    if(classesAreCorrect) {
        actualProxy = [LLSignalTestProxy testProxyWithSignal:actual];
        return YES;
    }
    
    return NO;
});

match(^BOOL{
    return containsAllValuesUnordered(actualProxy, expected);
});

failureMessageForTo(^NSString *{
    return @"Did not contain all values";
});

failureMessageForNotTo(^NSString *{
    return @"Contained all values";
});

EXPMatcherImplementationEnd
