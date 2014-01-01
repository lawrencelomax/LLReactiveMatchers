#import "EXPMatchers+sendError.h"

@interface EXPMatchers_sendErrorTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendErrorTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSError *expected = LLSpecError;
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.sendError(expected), failureString);
    assertFail(test_expect(signal).toNot.sendError(expected), failureString);
}

- (void) test_endsInCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSError *error = nil;
    NSString *failureString = @"expected: actual foo to error, got: completed";
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).sendError(error), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.sendError(error));
    assertFail(test_expect(recorder).sendError(error), failureString);
}

- (void) test_notYetCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSError *error = LLSpecError;
    NSString *failureString = @"expected: actual foo to finish";
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).to.sendError(error), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.sendError(error));
    assertFail(test_expect(recorder).to.sendError(error), failureString);
}

- (void) test_endsInSameError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:LLSpecError]] setNameWithFormat:@"foo"];
    NSError *error = LLSpecError;
    NSString *failureString = @"expected: actual foo to send error Error Domain=com.github.lawrencelomax.llreactivematchers.fixture Code=0 \"The operation couldn’t be completed. (com.github.lawrencelomax.llreactivematchers.fixture error 0.)\", got: the same error";
    
    assertPass(test_expect(signal).to.sendError(error));
    assertFail(test_expect(signal).toNot.sendError(error), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).to.sendError(error));
    assertFail(test_expect(recorder).toNot.sendError(error), failureString);
}

- (void) test_endsInDifferentError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:LLSpecError]] setNameWithFormat:@"foo"];
    NSError *error = [NSError errorWithDomain:@"foo" code:1 userInfo:@{}];
    NSString *failureString = @"expected: actual foo to send error Error Domain=foo Code=1 \"The operation couldn’t be completed. (foo error 1.)\", got: different errors";
    
    assertPass(test_expect(signal).toNot.sendError(error));
    assertFail(test_expect(signal).to.sendError(error), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.sendError(error));
    assertFail(test_expect(recorder).to.sendError(error), failureString);
}

@end
