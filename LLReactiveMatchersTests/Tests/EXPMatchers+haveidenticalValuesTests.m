#import "EXPMatchers+haveIdenticalValues.h"

@interface EXPMatchers_haveIdenticalValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_haveIdenticalValuesTests

- (void) test_identicalValues {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    
    assertPass(test_expect(signal).haveIdenticalValues(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalValues(expected), @"Values (1, 0, 5) are the same as (1, 0, 5)");
}

- (void) test_identicalValuesDifferentCompletion {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).haveIdenticalValues(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalValues(expected), @"Values (1, 0, 5) are the same as (1, 0, 5)");
}

- (void) test_differentValues {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@1]];
    
    assertPass(test_expect(signal).toNot.haveIdenticalValues(expected));
    assertFail(test_expect(signal).haveIdenticalValues(expected), @"Values (1, 0, 5) are not the same as (1, 0, 1)");
}

- (void) test_differentValuesDifferentCompletion {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@1]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).toNot.haveIdenticalValues(expected));
    assertFail(test_expect(signal).haveIdenticalValues(expected), @"Values (1, 0, 5) are not the same as (1, 0, 1)");
}

- (void) test_identicalValuesOneDidNotComplete {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@1]] concat:RACSignal.never];

    assertPass(test_expect(signal).toNot.haveIdenticalValues(expected));
    assertFail(test_expect(signal).haveIdenticalValues(expected), @"Both Signals have not finished");
}

@end
