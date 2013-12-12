#import "EXPMatchers+haveIdenticalValues.h"

@interface EXPMatchers_haveIdenticalValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_haveIdenticalValuesTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    RACSignal *expected = [RACSignal return:@1];
    
    assertFail(test_expect(actual).to.haveIdenticalValues(expected), @"Actual (1, 2, 3) is not a Signal");
    assertFail(test_expect(actual).toNot.haveIdenticalValues(expected), @"Actual (1, 2, 3) is not a Signal");
}

- (void) test_identicalValues {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    
    assertPass(test_expect(signal).haveIdenticalValues(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalValues(expected), @"Values (1, 0, 5) are the same as (1, 0, 5)");
}

- (void) test_identicalValuesDifferentCompletion {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).haveIdenticalValues(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalValues(expected), @"Values (1, 0, 5) are the same as (1, 0, 5)");
}

- (void) test_differentValues {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [LLReactiveMatchersFixtures values:@[@YES, @NO, @1]];
    
    assertPass(test_expect(signal).toNot.haveIdenticalValues(expected));
    assertFail(test_expect(signal).haveIdenticalValues(expected), @"Values (1, 0, 5) are not the same as (1, 0, 1)");
}

- (void) test_differentValuesDifferentCompletion {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @1]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).toNot.haveIdenticalValues(expected));
    assertFail(test_expect(signal).haveIdenticalValues(expected), @"Values (1, 0, 5) are not the same as (1, 0, 1)");
}

- (void) test_identicalValuesOneDidNotComplete {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"foo"];

    assertPass(test_expect(signal).toNot.haveIdenticalValues(expected));
    assertFail(test_expect(signal).haveIdenticalValues(expected), @"Expected foo has not finished");
}

@end
