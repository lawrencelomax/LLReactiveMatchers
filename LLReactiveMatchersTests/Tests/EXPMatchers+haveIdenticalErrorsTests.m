#import "EXPMatchers+haveIdenticalErrors.h"

@interface EXPMatchers_haveIdenticalErrorsTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_haveIdenticalErrorsTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    RACSignal *expected = [RACSignal return:@1];
    
    assertFail(test_expect(actual).to.haveIdenticalErrors(expected), @"Actual (1, 2, 3) is not a Signal");
    assertFail(test_expect(actual).toNot.haveIdenticalErrors(expected), @"Actual (1, 2, 3) is not a Signal");
}

- (void) test_noErrors {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.haveIdenticalErrors(expected));
    assertFail(test_expect(signal).to.haveIdenticalErrors(expected), @"Actual error in Signal foo not the same as expected error in Signal bar");
}

- (void) test_oneError {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.haveIdenticalErrors(expected));
    assertFail(test_expect(signal).to.haveIdenticalErrors(expected), @"Actual error in Signal foo not the same as expected error in Signal bar");
}

- (void) test_identicalErrors {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).to.haveIdenticalErrors(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalErrors(expected), @"Signals have the same errors");
}

- (void) test_differentErrors {
    NSError *anotherError = [NSError errorWithDomain:@"foo" code:1 userInfo:@{}];
    
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:anotherError]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.haveIdenticalErrors(expected));
    assertFail(test_expect(signal).to.haveIdenticalErrors(expected), @"Actual error in Signal foo not the same as expected error in Signal bar");
}

@end
