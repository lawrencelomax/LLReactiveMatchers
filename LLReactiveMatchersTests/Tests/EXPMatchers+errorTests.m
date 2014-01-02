#import "EXPMatchers+error.h"

@interface EXPMatchers_errorTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_errorTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.error(), failureString);
    assertFail(test_expect(signal).toNot.error(), failureString);
}

- (void) test_endsInError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:LLSpecError]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not error, got: errored";
    
    assertPass(test_expect(signal).to.error());
    assertFail(test_expect(signal).toNot.error(), failureString);
}

- (void) test_endsInCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to error, got: completed";
    
    assertPass(test_expect(signal).toNot.error());
    assertFail(test_expect(signal).to.error(), failureString);
}

- (void) test_notYetCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to finish";
    
    assertPass(test_expect(signal).toNot.error());
    assertFail(test_expect(signal).to.error(), failureString);
}

@end
