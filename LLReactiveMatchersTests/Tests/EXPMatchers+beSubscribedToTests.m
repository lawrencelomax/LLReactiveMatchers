#import "EXPMatchers+beSubscribedTo.h"

@interface EXPMatchers_beSubscribedToTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_beSubscribedToTests

- (void) test_noRecord {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    
    assertFail(test_expect(signal).to.beSubscribedTo(0), @"expected: actual foo to start recording subscriptions");
    assertPass(test_expect(signal).toNot.beSubscribedTo(0));
}

- (void) test_noSubscribe {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"] startCountingSubscriptions];
    
    assertPass(test_expect(signal).to.beSubscribedTo(0));
    assertFail(test_expect(signal).toNot.beSubscribedTo(0), @"expected: actual foo to not be subscribed to 0 times");
}

- (void) test_multipleSubscriptions {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"] startCountingSubscriptions];
    
    [signal subscribeCompleted:^{}];
    [signal subscribeCompleted:^{}];
    [signal subscribeCompleted:^{}];
    assertPass(test_expect(signal).to.beSubscribedTo(3));
    
    [signal stopCountingSubscriptions];
    [signal subscribeCompleted:^{}];
    [signal subscribeCompleted:^{}];
    assertPass(test_expect(signal).to.beSubscribedTo(3));
    
    [signal startCountingSubscriptions];
    [signal subscribeCompleted:^{}];
    assertPass(test_expect(signal).to.beSubscribedTo(4));
}

@end
