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
    
    return [NSString stringWithFormat:@"Actual %@ sent %ld next events instead of %ld", LLDescribeSignal(actual), (long)receivedCount, (long)expected];
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    return [NSString stringWithFormat:@"Actual %@ sent %ld next events", LLDescribeSignal(actual), (long)expected];
});

EXPMatcherImplementationEnd
