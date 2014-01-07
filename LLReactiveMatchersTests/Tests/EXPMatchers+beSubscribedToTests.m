#import "EXPMatchers+beSubscribedTo.h"

@interface EXPMatchers_beSubscribedToTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_beSubscribedToTests

- (void) test_noExternalSubscription {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).to.beSubscribedTo(0));
    assertFail(test_expect(signal).toNot.beSubscribedTo(0), @"expected: actual foo to not be subscribed to 0 times");
}

- (void) test_MultipleSubscriptions {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).will.beSubscribedTo(3));
    
    [signal subscribeCompleted:^{}];
    [signal subscribeCompleted:^{}];
    [signal subscribeCompleted:^{}];
}

@end
