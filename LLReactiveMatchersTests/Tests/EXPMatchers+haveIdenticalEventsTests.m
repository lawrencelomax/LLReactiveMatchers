#import "EXPMatchers+haveIdenticalEvents.h"

@interface EXPMatchers_haveIdenticalEventsTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_haveIdenticalEventsTests

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

- (void) test_identicalEventsOneDidNotComplete {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@YES, @NO, @5]];
    RACSignal *expected = [[LLReactiveMatchersFixtures values:@[@YES, @NO, @5]] concat:RACSignal.never];
    
    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Both Signals have not finished");
}

@end
