#import "EXPMatchers+sendError.h"

@interface EXPMatchers_sendErrorTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendErrorTests

- (void) test_endsInCompletion {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@1, @2, @3]];
    NSError *error = nil;
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).sendError(error), @"Signal did not finish in error");
}

- (void) test_endsInSameError {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]];
    NSError *error = MI9SpecError;
    
    assertPass(test_expect(signal).to.sendError(error));
    assertFail(test_expect(signal).toNot.sendError(error), @"Errors are the same");
}

- (void) test_endsInDifferentError {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]];
    NSError *error = [NSError errorWithDomain:@"foo" code:1 userInfo:@{}];
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).to.sendError(error), @"Errors are not the same");
}

- (void) test_notYetCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSError *error = MI9SpecError;
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).to.sendError(error), @"Actual foo has not finished");
}

@end
