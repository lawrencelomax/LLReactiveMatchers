#import "EXPMatchers+sendValuesWithCount.h"

@interface EXPMatchers_sendValuesWithCountTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendValuesWithCountTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSArray *expected = @[@1, @2];
    
    assertFail(test_expect(actual).to.sendValues(expected), @"expected: actual to be a signal or recorder");
    assertFail(test_expect(actual).toNot.sendValues(expected), @"expected: actual to be a signal or recorder");
}

- (void) test_noValuesCorrect {
    RACSignal *actual = [RACSignal.empty setNameWithFormat:@"foo"];
    
    assertPass(test_expect(actual).to.sendValuesWithCount(0));
    assertFail(test_expect(actual).toNot.sendValuesWithCount(0), @"expected: actual foo to not send 0 events, got: 0 events sent");
}

- (void) test_noValuesIncorrect {
    RACSignal *actual = [RACSignal.empty setNameWithFormat:@"foo"];
    
    assertPass(test_expect(actual).toNot.sendValuesWithCount(5));
    assertFail(test_expect(actual).to.sendValuesWithCount(5), @"expected: actual foo to send 5 events, got: 0 events sent");
}

- (void) test_10ValuesCorrect {
    RACSignal *actual = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(actual).to.sendValuesWithCount(10));
    assertFail(test_expect(actual).toNot.sendValuesWithCount(10), @"expected: actual foo to not send 10 events, got: 10 events sent");
}

- (void) test_10ValuesIncorrect {
    RACSignal *actual = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9]] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(actual).toNot.sendValuesWithCount(5));
    assertFail(test_expect(actual).to.sendValuesWithCount(5), @"expected: actual foo to send 5 events, got: 10 events sent");
}

@end
