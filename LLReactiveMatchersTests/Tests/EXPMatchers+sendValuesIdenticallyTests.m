#import "EXPMatchers+sendValuesIdentically.h"

@interface EXPMatchers_sendValuesIdentically : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendValuesIdentically

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSArray *expected = @[@1, @2, @3];
    
    assertFail(test_expect(actual).to.sendValuesIdentically(expected), @"Actual (1, 2, 3) is not a Signal");
    assertFail(test_expect(actual).toNot.sendValuesIdentically(expected), @"Actual (1, 2, 3) is not a Signal");
}

- (void) test_empty {
    RACSignal *actual = [RACSignal.empty setNameWithFormat:@"foo"];
    NSArray *expected = @[];
    
    assertPass(test_expect(actual).to.sendValuesIdentically(expected));
    assertFail(test_expect(actual).toNot.sendValuesIdentically(expected), @"Signal foo has identical values to ()");
}

- (void) test_outOfOrder {
    RACSignal *actual = [LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]];
    NSArray *expected = @[@0, @1, @3, @2];
    
    assertPass(test_expect(actual).toNot.sendValuesIdentically(expected));
    assertFail(test_expect(actual).to.sendValuesIdentically(expected), @"Signal values (0, 1, 2, 3) does not have identical values to (0, 1, 3, 2)");
}

- (void) test_subRange {
    RACSignal *actual = [LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]];
    NSArray *expected = @[@0, @1, @2];
    
    assertPass(test_expect(actual).toNot.sendValuesIdentically(expected));
    assertFail(test_expect(actual).to.sendValuesIdentically(expected), @"Signal values (0, 1, 2, 3) does not have identical values to (0, 1, 2)");
}

- (void) test_exact {
    RACSignal *actual = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@0, @1, @2, @3];
    
    assertPass(test_expect(actual).to.sendValuesIdentically(expected));
    assertFail(test_expect(actual).toNot.sendValuesIdentically(expected), @"Signal foo has identical values to (0, 1, 2, 3)");
}

@end
