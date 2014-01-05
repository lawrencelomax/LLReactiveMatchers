#import "EXPMatchers+beSubscribedTo.h"

@interface EXPMatchers_beSubscribedToTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_beSubscribedToTests

- (void) test_noExternalSubscription {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).to.beSubscribedTo(0));
    assertFail(test_expect(signal).toNot.beSubscribedTo(0), @"Signal foo subscribed to 0 times");
}

- (void) testMultipleSubscriptions {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).will.beSubscribedTo(3));
    
    [signal subscribeCompleted:^{}];
    [signal subscribeCompleted:^{}];
    [signal subscribeCompleted:^{}];
}

@end
