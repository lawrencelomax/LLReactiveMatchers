#import "EXPMatchers+complete.h"

@interface EXPMatchers_completeTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_completeTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    
    assertFail(test_expect(actual).to.complete(), @"expected: actual (1, 2, 3) to be a signal or recorder");
    assertFail(test_expect(actual).toNot.complete(), @"expected: actual (1, 2, 3) to be a signal or recorder");
}

- (void) test_endsInCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).to.complete());
    assertFail(test_expect(signal).toNot.complete(), @"Signal foo finished in completion instead of not completing");
}

- (void) test_endsInError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), @"Signal foo finished in error instead of completion");
}

- (void) test_notYetCompleted {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.complete());
    assertFail(test_expect(signal).to.complete(), @"Actual foo has not finished");
}

@end
