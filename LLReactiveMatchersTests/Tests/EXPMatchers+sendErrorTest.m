#import "EXPMatchers+sendError.h"

@interface EXPMatchers_sendErrorTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendErrorTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSError *expected = MI9SpecError;
    
    assertFail(test_expect(actual).to.sendError(expected), @"expected: actual (1, 2, 3) to be a signal or recorder");
    assertFail(test_expect(actual).toNot.sendError(expected), @"expected: actual (1, 2, 3) to be a signal or recorder");
}

- (void) test_endsInCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSError *error = nil;
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).sendError(error), @"Signal foo did not finish in error");
}

- (void) test_endsInSameError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    NSError *error = MI9SpecError;
    
    assertPass(test_expect(signal).to.sendError(error));
    assertFail(test_expect(signal).toNot.sendError(error), @"Actual foo has the same error as Error Domain=com.github.lawrencelomax.llreactivematchers.fixture Code=0 \"The operation couldn’t be completed. (com.github.lawrencelomax.llreactivematchers.fixture error 0.)\"");
}

- (void) test_endsInDifferentError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    NSError *error = [NSError errorWithDomain:@"foo" code:1 userInfo:@{}];
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).to.sendError(error), @"Actual foo does not have the same error as Error Domain=foo Code=1 \"The operation couldn’t be completed. (foo error 1.)\"");
}

- (void) test_notYetCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSError *error = MI9SpecError;
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).to.sendError(error), @"Actual foo has not finished");
}

@end
