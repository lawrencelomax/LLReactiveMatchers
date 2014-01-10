#import "EXPMatchers+sendValuesWithCount.h"

@interface EXPMatchers_sendValuesWithCountTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendValuesWithCountTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSArray *expected = @[@1, @2];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.sendValues(expected), failureString);
    assertFail(test_expect(signal).toNot.sendValues(expected), failureString);
}

- (void) test_noValuesCorrect {
    RACSignal *signal = [RACSignal.empty setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not send 0 events, got: 0 events sent";
    
    assertPass(test_expect(signal).to.sendValuesWithCount(0));
    assertFail(test_expect(signal).toNot.sendValuesWithCount(0), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).will.sendValuesWithCount(0));
    assertFail(test_expect(signal).willNot.sendValuesWithCount(0), failureString);
    
    assertPass(test_expect(signal).willContinueTo.sendValuesWithCount(0));
    assertFail(test_expect(signal).willNotContinueTo.sendValuesWithCount(0), failureString);
}

- (void) test_noValuesIncorrect {
    RACSignal *signal = [RACSignal.empty setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to send 5 events, got: 0 events sent";
    
    assertPass(test_expect(signal).toNot.sendValuesWithCount(5));
    assertFail(test_expect(signal).to.sendValuesWithCount(5), failureString);
    
    signal = [signal asyncySignal];
    assertFail(test_expect(signal).willContinueTo.sendValuesWithCount(5), failureString);
    assertPass(test_expect(signal).willNotContinueTo.sendValuesWithCount(5));
    
    failureString = @"expected: actual foo to send 5 events, got: 0 events sent";
    assertFail(test_expect(signal).will.sendValuesWithCount(5), failureString);
    assertPass(test_expect(signal).willNot.sendValuesWithCount(5));
}

- (void) test_10ValuesCorrect {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not send 10 events, got: 10 events sent";
    
    assertPass(test_expect(signal).to.sendValuesWithCount(10));
    assertFail(test_expect(signal).toNot.sendValuesWithCount(10), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).will.sendValuesWithCount(10));
    assertPass(test_expect(signal).willNot.sendValuesWithCount(10));
    
    assertPass(test_expect(signal).willContinueTo.sendValuesWithCount(10));
    assertFail(test_expect(signal).willNotContinueTo.sendValuesWithCount(10), failureString);
}

- (void) test_10ValuesIncorrect {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to send 5 events, got: 10 events sent";
    
    assertPass(test_expect(signal).toNot.sendValuesWithCount(5));
    assertFail(test_expect(signal).to.sendValuesWithCount(5), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).willNot.sendValuesWithCount(5));
    assertFail(test_expect(signal).will.sendValuesWithCount(5), failureString);
    
    assertPass(test_expect(signal).willNotContinueTo.sendValuesWithCount(5));
    assertFail(test_expect(signal).willContinueTo.sendValuesWithCount(5), failureString);
}

@end
