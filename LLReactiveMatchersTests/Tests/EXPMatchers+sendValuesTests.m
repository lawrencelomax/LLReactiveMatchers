#import "EXPMatchers+sendValues.h"

@interface EXPMatchers_sendValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendValuesTests

- (void) test_empty {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@1, @2, @3]];
    NSArray *expected = @[@1, @3, @2];
    
    assertPass(test_expect(signal).to.sendValues(expected));
    assertFail(test_expect(signal).toNot.sendValues(expected), @"Contained all values");
}

- (void) test_all {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@1, @2, @3]];
    NSArray *expected = @[@1, @3, @2];
    
    assertPass(test_expect(signal).to.sendValues(expected));
    assertFail(test_expect(signal).toNot.sendValues(expected), @"Contained all values");
}

- (void) test_someAllExpected {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@1, @2, @3]];
    NSArray *expected = @[@1, @2];
    
    assertPass(test_expect(signal).to.sendValues(expected));
    assertFail(test_expect(signal).toNot.sendValues(expected), @"Contained all values");
}

- (void) test_someNotAllExpected {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@1, @2, @3]];
    NSArray *expected = @[@1, @2, @20];
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), @"Did not contain all values");
}

- (void) test_none {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@1, @2, @3]];
    NSArray *expected = @[@10, @20];
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), @"Did not contain all values");
}

@end
