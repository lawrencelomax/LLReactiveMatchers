#import "EXPMatchers+sendValues.h"

@interface EXPMatchers_sendValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendValuesTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSArray *expected = @[@1, @2];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.sendValues(expected), failureString);
    assertFail(test_expect(signal).toNot.sendValues(expected), failureString);
}

- (void) test_empty {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[];
    NSString *failureString = @"expected: actual foo to send values (), got: (1, 2, 3) values sent";
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.sendValues(expected));
    assertFail(test_expect(recorder).to.sendValues(expected), failureString);
}

- (void) test_allWrongOrder {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @3, @2];
    NSString *failureString = @"expected: actual foo to send values (1, 3, 2), got: (1, 2, 3) values sent";
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.sendValues(expected));
    assertFail(test_expect(recorder).to.sendValues(expected), failureString);
}

- (void) test_allCorrectOrder {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @2, @3];
    NSString *failureString = @"expected: actual foo to not send values (1, 2, 3), got: (1, 2, 3) values sent";
    
    assertPass(test_expect(signal).to.sendValues(expected));
    assertFail(test_expect(signal).toNot.sendValues(expected), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).to.sendValues(expected));
    assertFail(test_expect(recorder).toNot.sendValues(expected), failureString);
}

- (void) test_someAllExpected {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@1, @2];
    NSString *failureString = @"expected: actual foo to send values (1, 2), got: (1, 2, 3) values sent";
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.sendValues(expected));
    assertFail(test_expect(recorder).to.sendValues(expected), failureString);
}

- (void) test_subRange {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@0, @1, @2];
    NSString *failureString = @"expected: actual foo to send values (0, 1, 2), got: (0, 1, 2, 3) values sent";
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.sendValues(expected));
    assertFail(test_expect(recorder).to.sendValues(expected), failureString);
}

- (void) test_none {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@1, @2, @3]] setNameWithFormat:@"foo"];
    NSArray *expected = @[@10, @20];
    NSString *failureString = @"expected: actual foo to send values (10, 20), got: (1, 2, 3) values sent";
    
    assertPass(test_expect(signal).toNot.sendValues(expected));
    assertFail(test_expect(signal).to.sendValues(expected), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
    assertPass(test_expect(recorder).toNot.sendValues(expected));
    assertFail(test_expect(recorder).to.sendValues(expected), failureString);
}

@end
