#import "EXPMatchers+haveIdenticalEvents.h"

@interface EXPMatchers_haveIdenticalEventsTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_haveIdenticalEventsTests

- (void) test_identicalEventsCompletion {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    
    assertPass(test_expect(signal).haveIdenticalEvents(expected));
}

- (void) test_identicalEventsCompletionAsync {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = @[@YES, @NO, @5].rac_sequence.signal;
    
    assertPass(test_expect(signal).will.haveIdenticalEvents(expected));
}

- (void) test_differentEventsCompletion {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@2]];

    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Values (1, 0, 5) are not the same as (1, 0, 2)");
}

- (void) test_differentEventsCompletionAsync {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = @[@YES, @NO, @2].rac_sequence.signal;
    
    assertPass(test_expect(signal).willNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).will.haveIdenticalEvents(expected), @"Values (1, 0, 5) are not the same as (1, 0, 2)");
}

- (void) test_identicalEventsIdenticalError {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).haveIdenticalEvents(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalEvents(expected), @"Signals have the same errors");
}

- (void) test_identicalEventsIdenticalErrorAsync {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [@[@YES, @NO, @5].rac_sequence.signal concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).will.haveIdenticalEvents(expected));
}

- (void) test_identicalEventsDifferentErrors {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:nil]];
    
    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).haveIdenticalEvents(expected), @"Signals do not have the same errors");
}

- (void) test_identicalEventsDifferentErrorsAsync {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [@[@YES, @NO, @5].rac_sequence.signal concat:[RACSignal error:nil]];
    
    assertPass(test_expect(signal).willNot.haveIdenticalEvents(expected));
}

- (void) test_identicalEventsOneDidNotComplete {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:RACSignal.never];
    
    assertPass(test_expect(signal).toNot.haveIdenticalEvents(expected));
    assertFail(test_expect(signal).to.haveIdenticalEvents(expected), @"Both Signals have not finished");
}

@end
