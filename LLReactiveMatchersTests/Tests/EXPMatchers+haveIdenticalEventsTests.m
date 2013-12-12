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
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] ;
    RACSignal *expected = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] ;
    
    assertPass(test_expect(signal).haveIdenticalEvents(expected));
}

- (void) test_identicalEventsCompletionAsync {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] ;
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] subscribeOn:RACScheduler.scheduler];
    
    assertPass(test_expect(signal).will.haveIdenticalEvents(expected));
}

- (void) test_differentEventsCompletion {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [LLReactiveMatchersFixtures values:@[@YES, @NO, @2]];

    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Values (1, 0, 5) are not the same as (1, 0, 2)");
}

- (void) test_differentEventsCompletionAsync {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] ;
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @2]] subscribeOn:RACScheduler.scheduler];
    
    assertPass(test_expect(signal).willNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).will.haveIdenticalEvents(expected), @"Values (1, 0, 5) are not the same as (1, 0, 2)");
}

- (void) test_identicalEventsIdenticalError {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).haveIdenticalEvents(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalEvents(expected), @"Signals have the same errors");
}

- (void) test_identicalEventsIdenticalErrorAsync {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]] subscribeOn:RACScheduler.scheduler];
    
    assertPass(test_expect(signal).will.haveIdenticalEvents(expected));
}

- (void) test_identicalEventsDifferentErrors {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:nil]];
    
    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).haveIdenticalEvents(expected), @"Signals do not have the same errors");
}

- (void) test_identicalEventsDifferentErrorsAsync {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:[RACSignal error:nil]] subscribeOn:RACScheduler.scheduler];
    
    assertPass(test_expect(signal).willNot.haveIdenticalEvents(expected));
}

- (void) test_identicalEventsExpectedDidNotComplete {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [[[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    
    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Expected foo has not finished");
}

@end
