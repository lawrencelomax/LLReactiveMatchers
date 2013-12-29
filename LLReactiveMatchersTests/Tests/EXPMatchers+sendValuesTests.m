#import "EXPMatchers+sendValues.h"

@interface EXPMatchers_sendValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendValuesTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSArray *expected = @[@1, @2];
    
    assertFail(test_expect(actual).to.sendValues(expected), @"expected: actual to be a signal or recorder");
    assertFail(test_expect(actual).toNot.sendValues(expected), @"expected: actual to be a signal or recorder");
}

- (void) test_empty {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[];
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), @"expected: actual foo to send values (), got: (1, 2, 3) values sent");
}

- (void) test_allWrongOrder {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @3, @2];
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), @"expected: actual foo to send values (1, 3, 2), got: (1, 2, 3) values sent");
}

- (void) test_allCorrectOrder {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @2, @3];
    
    assertPass(test_expect(signal).to.sendValues(expected));
    assertFail(test_expect(signal).toNot.sendValues(expected), @"expected: actual foo to not send values (1, 2, 3), got: (1, 2, 3) values sent");
}

- (void) test_someAllExpected {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @2];
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), @"expected: actual foo to send values (1, 2), got: (1, 2, 3) values sent");
}

- (void) test_subRange {
    RACSignal *actual = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@0, @1, @2];
    
    assertPass(test_expect(actual).toNot.sendValues(expected));
    assertFail(test_expect(actual).to.sendValues(expected), @"expected: actual foo to send values (0, 1, 2), got: (0, 1, 2, 3) values sent");
}

- (void) test_none {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@10, @20];
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), @"expected: actual foo to send values (10, 20), got: (1, 2, 3) values sent");
}

@end
