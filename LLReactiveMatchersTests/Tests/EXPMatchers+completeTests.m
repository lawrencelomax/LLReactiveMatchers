#import "EXPMatchers+complete.h"

@interface EXPMatchers_completeTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_completeTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    
    assertFail(test_expect(actual).to.complete(), @"expected: actual to be a signal or recorder");
    assertFail(test_expect(actual).toNot.complete(), @"expected: actual to be a signal or recorder");
}

- (void) test_actualDidNotComplete {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), @"expected: actual foo to finish");
}

- (void) test_endsInCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).to.complete());
    assertFail(test_expect(signal).toNot.complete(), @"expected: actual foo to not complete, got: completed");
}

- (void) test_endsInError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), @"expected: actual foo to complete, got: error instead of completion");
}


@end
