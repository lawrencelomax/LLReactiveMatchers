#import "EXPMatchers+haveIdenticalEvents.h"

@interface EXPMatchers_haveIdenticalEventsTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_haveIdenticalEventsTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    RACSignal *expected = [LLReactiveMatchersFixtures values:@[@2, @3]];
    
    assertFail(test_expect(actual).to.haveIdenticalEvents(expected), @"Actual (1, 2, 3) is not a Signal");
    assertFail(test_expect(actual).toNot.haveIdenticalEvents(expected), @"Actual (1, 2, 3) is not a Signal");
}

- (void) test_identicalEventsCompletion {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).to.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalEvents(expected), @"Actual foo has all the same events as bar");
}

- (void) test_differentEventsCompletion {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [LLReactiveMatchersFixtures values:@[@YES, @NO, @2]];

    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Values (1, 0, 5) are not the same as (1, 0, 2)");
}

- (void) test_identicalEventsIdenticalError {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).to.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalEvents(expected), @"Actual foo has all the same events as bar");
}

- (void) test_identicalEventsDifferentErrors {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] setNameWithFormat:@"foo"];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:nil]] setNameWithFormat:@"bar"];
    
    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Actual foo does not have the same finishing event as bar");
}

- (void) test_identicalEventsExpectedDidNotComplete {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Expected foo has not finished");
}

@end
