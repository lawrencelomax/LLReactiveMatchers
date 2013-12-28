#import "EXPMatchers+finish.h"

@interface EXPMatchers_finishTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_finishTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    
    assertFail(test_expect(actual).to.finish(), @"expected: actual to be a signal or recorder");
    assertFail(test_expect(actual).toNot.finish(), @"expected: actual to be a signal or recorder");
}

- (void) test_completion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).to.finish());
    assertFail(test_expect(signal).toNot.finish(), @"expected: actual foo to not finish, got: finished with completion");
}

- (void) test_error {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).to.finish());
    assertFail(test_expect(signal).toNot.finish(), @"expected: actual foo to not finish, got: finished with error");
}

- (void) test_nonCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.finish());
    assertFail(test_expect(signal).to.finish(), @"expected: actual foo to finish");
}

@end
