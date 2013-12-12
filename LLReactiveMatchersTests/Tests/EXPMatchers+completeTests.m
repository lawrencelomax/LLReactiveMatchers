#import "EXPMatchers+complete.h"

@interface EXPMatchers_completeTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_completeTests

- (void) test_endsInCompletion {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@1, @2, @3]];
    
    assertPass(test_expect(signal).to.complete());
    assertFail(test_expect(signal).toNot.complete(), @"Signal completed");
}

- (void) test_endsInError {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), @"Signal finished with error");
}

- (void) test_notYetCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), @"Actual foo has not finished");
}

@end
