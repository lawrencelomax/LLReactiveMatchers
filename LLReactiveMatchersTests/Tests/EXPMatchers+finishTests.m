#import "EXPMatchers+finish.h"

@interface EXPMatchers_finishTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_finishTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(actual).to.finish(), failureString);
    assertFail(test_expect(actual).toNot.finish(), failureString);
}

- (void) test_completion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not finish, got: finished with completion";
    
    assertPass(test_expect(signal).to.finish());
    assertFail(test_expect(signal).toNot.finish(), failureString);
 
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).to.finish());
    assertFail(test_expect(recorder).toNot.finish(), failureString);
}

- (void) test_error {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not finish, got: finished with error";
    
    assertPass(test_expect(signal).to.finish());
    assertFail(test_expect(signal).toNot.finish(), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).to.finish());
    assertFail(test_expect(recorder).toNot.finish(), failureString);
}

- (void) test_nonCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to finish";
    
    assertPass(test_expect(signal).toNot.finish());
    assertFail(test_expect(signal).to.finish(), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.finish());
    assertFail(test_expect(recorder).to.finish(), failureString);
}

@end
