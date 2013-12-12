#import "EXPMatchers+finish.h"

@interface EXPMatchers_finishTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_finishTests

- (void) test_completion {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    
    assertPass(test_expect(signal).to.finish());
    assertFail(test_expect(signal).toNot.finish(), @"Signal completed");
}

- (void) test_error {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).to.finish());
    assertFail(test_expect(signal).toNot.finish(), @"Signal errored");
}

- (void) test_nonCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.finish());
    assertFail(test_expect(signal).to.finish(), @"Actual foo has not finished");
}

@end
