#import "EXPMatchers+finish.h"

@interface EXPMatchers_finishTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_finishTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.finish(), failureString);
    assertFail(test_expect(signal).toNot.finish(), failureString);
}

- (void) test_completion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not finish, got: finished with completion";
    
    assertPass(test_expect(signal).to.finish());
    assertFail(test_expect(signal).toNot.finish(), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).will.finish());
    assertPass(test_expect(signal).willNot.finish());
}

- (void) test_error {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:LLSpecError]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not finish, got: finished with error";
    
    assertPass(test_expect(signal).to.finish());
    assertFail(test_expect(signal).toNot.finish(), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).will.finish());
    assertPass(test_expect(signal).willNot.finish());
}

- (void) test_nonCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to finish";
    
    assertPass(test_expect(signal).toNot.finish());
    assertFail(test_expect(signal).to.finish(), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).willNot.finish());
    assertFail(test_expect(signal).will.finish(), failureString);
}

@end
