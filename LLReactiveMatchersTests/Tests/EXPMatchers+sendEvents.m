#import "EXPMatchers+sendEvents.h"

@interface EXPMatchers_sendEventsTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendEventsTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    RACSignal *expected = [LLReactiveMatchersFixtures values:@[@2, @3]];
    
    assertFail(test_expect(actual).to.sendEvents(expected), @"expected: actual to be a signal or recorder");
    assertFail(test_expect(actual).toNot.sendEvents(expected), @"expected: actual to be a signal or recorder");
}

- (void) test_identicalEventsCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).to.sendEvents(expected));
    assertFail(test_expect(signal).toNot.sendEvents(expected), @"expected: actual foo to not have events that are identical to expected bar");
}

- (void) test_differentEventsCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @2]] setNameWithFormat:@"bar"];

    assertPass(test_expect(signal).toNot.sendEvents(expected));
    assertFail(test_expect(signal).to.sendEvents(expected), @"expected: actual foo to send values (1, 0, 2), got: (1, 0, 5) values sent");
}

- (void) test_identicalEventsIdenticalError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).to.sendEvents(expected));
    assertFail(test_expect(signal).toNot.sendEvents(expected), @"expected: actual foo to not have events that are identical to expected bar");
}

- (void) test_identicalEventsDifferentErrors {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:nil]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.sendEvents(expected));
    assertFail(test_expect(signal).to.sendEvents(expected), @"expected: actual foo to finish in the same way as expected bar");
}

- (void) test_identicalEventsExpectedDidNotComplete {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.sendEvents(expected));
    assertFail(test_expect(signal).to.sendEvents(expected), @"expected: expected bar to finish");
}

- (void) test_identicalValues {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).to.sendEvents(expected));
    assertFail(test_expect(signal).toNot.sendEvents(expected), @"expected: actual foo to not have events that are identical to expected bar");
}

- (void) test_identicalValuesDifferentCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.sendEvents(expected));
    assertFail(test_expect(signal).to.sendEvents(expected), @"expected: actual foo to finish in the same way as expected bar");
}

- (void) test_differentValues {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @1]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.sendEvents(expected));
    assertFail(test_expect(signal).to.sendEvents(expected), @"expected: actual foo to send values (1, 0, 1), got: (1, 0, 5) values sent");
}

- (void) test_differentValuesDifferentCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @1]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.sendEvents(expected));
    assertFail(test_expect(signal).to.sendEvents(expected), @"expected: actual foo to send values (1, 0, 1), got: (1, 0, 5) values sent");
}

- (void) test_identicalValuesOneDidNotComplete {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"foo"] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.sendEvents(expected));
    assertFail(test_expect(signal).to.sendEvents(expected), @"expected: expected bar to finish");
}

@end
