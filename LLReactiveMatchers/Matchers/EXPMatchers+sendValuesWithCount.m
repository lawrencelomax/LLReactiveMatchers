#import "EXPMatchers+sendValuesWithCount.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessages.h"
#import "LLReactiveMatchersHelpers.h"

EXPMatcherImplementationBegin(sendValuesWithCount, (NSInteger expected))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];
__block BOOL hasSubscribed = NO;
__block NSInteger receivedCount = 0;

void (^subscribe)(void) = ^{
    if(!hasSubscribed) {
        [self.rac_deallocDisposable addDisposable:
          [actual subscribeNext:^(id x) {
            @synchronized(actual) {
                receivedCount++;
            }
          }]
        ];
        hasSubscribed = YES;
    }
};

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    subscribe();
    return (receivedCount == expected);
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Actual %@ sent %d next events instead of %d", LLDescribeSignal(actual), receivedCount, expected];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Actual %@ sent %d next events", LLDescribeSignal(actual), expected];
});

EXPMatcherImplementationEnd
