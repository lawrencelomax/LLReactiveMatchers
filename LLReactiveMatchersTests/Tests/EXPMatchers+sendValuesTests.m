#import "EXPMatchers+sendValues.h"

@interface EXPMatchers_sendValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendValuesTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSArray *expected = @[@1, @2];
    
    assertFail(test_expect(actual).to.sendValues(expected), @"Actual (1, 2, 3) is not a Signal");
    assertFail(test_expect(actual).toNot.sendValues(expected), @"Actual (1, 2, 3) is not a Signal");
}

- (void) test_empty {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @3, @2];
    
    assertPass(test_expect(signal).to.sendValues(expected));
    assertFail(test_expect(signal).toNot.sendValues(expected), @"Signal foo contains all values (1, 3, 2)");
}

- (void) test_all {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @3, @2];
    
    assertPass(test_expect(signal).to.sendValues(expected));
    assertFail(test_expect(signal).toNot.sendValues(expected), @"Signal foo contains all values (1, 3, 2)");
}

- (void) test_someAllExpected {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @2];
    
    assertPass(test_expect(signal).to.sendValues(expected));
    assertFail(test_expect(signal).toNot.sendValues(expected), @"Signal foo contains all values (1, 2)");
}

- (void) test_someNotAllExpected {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @2, @20];
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), @"Signal foo does not contain all values (1, 2, 20)");
}

- (void) test_none {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@10, @20];
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), @"Signal foo does not contain all values (10, 20)");
}

@end
