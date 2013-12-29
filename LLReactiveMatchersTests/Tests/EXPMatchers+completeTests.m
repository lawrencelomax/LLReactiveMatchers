#import "EXPMatchers+complete.h"

@interface EXPMatchers_completeTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_completeTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(actual).to.complete(), failureString);
    assertFail(test_expect(actual).toNot.complete(), failureString);
}

- (void) test_actualDidNotComplete {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to finish";
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.complete());
    assertFail(test_expect(recorder).to.complete(), failureString);
}

- (void) test_endsInCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not complete, got: completed";
    
    assertPass(test_expect(signal).to.complete());
    assertFail(test_expect(signal).toNot.complete(), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).to.complete());
    assertFail(test_expect(recorder).toNot.complete(), failureString);
}

- (void) test_endsInError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to complete, got: error instead of completion";
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.complete());
    assertFail(test_expect(recorder).to.complete(), failureString);
}


@end
