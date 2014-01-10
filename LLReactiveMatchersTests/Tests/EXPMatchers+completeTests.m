#import "EXPMatchers+complete.h"

@interface EXPMatchers_completeTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_completeTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.complete(), failureString);
    assertFail(test_expect(signal).toNot.complete(), failureString);
}

- (void) test_noResubscriptionForTestSubscriber {
    __block NSUInteger subscriptionCount = 0;
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] initially:^{
        subscriptionCount++;
    }] testRecorder];
    
    assertPass(test_expect(signal).to.complete());
    expect(subscriptionCount).to.equal(1);
}

- (void) test_actualDidNotComplete {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to finish";
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).willNot.complete());
    assertFail(test_expect(signal).will.complete(), failureString);
    
    assertPass(test_expect(signal).willNotContinueTo.complete());
    assertFail(test_expect(signal).willContinueTo.complete(), failureString);
}

- (void) test_endsInCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not complete, got: completed";
    
    assertPass(test_expect(signal).to.complete());
    assertFail(test_expect(signal).toNot.complete(), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).will.complete());
    assertPass(test_expect(signal).willNot.complete());
    
    assertPass(test_expect(signal).willContinueTo.complete());
    assertFail(test_expect(signal).willNotContinueTo.complete(), failureString);
}

- (void) test_endsInError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:LLSpecError]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to complete, got: error instead of completion";
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).willNot.complete());
    assertFail(test_expect(signal).will.complete(), failureString);
    
    assertPass(test_expect(signal).willNotContinueTo.complete());
    assertFail(test_expect(signal).willContinueTo.complete(), failureString);
}


@end
