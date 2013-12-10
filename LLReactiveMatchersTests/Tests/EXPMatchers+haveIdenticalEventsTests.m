#import "EXPMatchers+haveIdenticalEvents.h"

@interface EXPMatchers_haveIdenticalEventsTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_haveIdenticalEventsTests

- (void) test_identicalEventsCompletionSynchronous {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    
    assertPass(test_expect(signal).haveIdenticalEvents(expected));
}

- (void) test_identicalEventsCompletionAsynchronous {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = @[@YES, @NO, @5].rac_sequence.signal;
    
    assertPass(test_expect(signal).will.haveIdenticalEvents(expected));
}

- (void) test_differentEventsCompletionSynchronous {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@2]];

    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Events (1, 0, 5) are not the same as (1, 0, 2)");
}

- (void) test_differentEventsCompletionAsynchronous {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = @[@YES, @NO, @2].rac_sequence.signal;
    
    assertPass(test_expect(signal).willNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).will.haveIdenticalEvents(expected), @"Events (1, 0, 5) are not the same as (1, 0, 2)");
}

- (void) test_identicalEventsIdenticalErrorSynchronous {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).haveIdenticalEvents(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalEvents(expected), @"Signals have the same errors");
}

- (void) test_identicalEventsIdenticalErrorAsynchronous {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [@[@YES, @NO, @5].rac_sequence.signal concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).will.haveIdenticalEvents(expected));
}

- (void) test_identicalEventsDifferentErrorsSynchronous {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:nil]];
    
    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).haveIdenticalEvents(expected), @"Signals did not have the same errors");
}

- (void) test_identicalEventsDifferentErrorsAsynchronous {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [@[@YES, @NO, @5].rac_sequence.signal concat:[RACSignal error:nil]];
    
    assertPass(test_expect(signal).willNot.haveIdenticalEvents(expected));
}

@end
