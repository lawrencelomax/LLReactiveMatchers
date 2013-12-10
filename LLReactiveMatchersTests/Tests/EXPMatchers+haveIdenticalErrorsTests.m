#import "EXPMatchers+haveIdenticalErrors.h"

@interface EXPMatchers_haveIdenticalErrorsTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_haveIdenticalErrorsTests

- (void) test_noErrors {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    
    assertFail(test_expect(signal).to.haveIdenticalErrors(expected), @"Both signals did not error");
}

- (void) test_oneError {
    RACSignal *signal = [[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    
    assertFail(test_expect(signal).to.haveIdenticalErrors(expected), @"Signals have different errors");
}

- (void) test_identicalErrors {
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    
    assertPass(test_expect(signal).to.haveIdenticalErrors(expected));
    assertFail(test_expect(signal).toNot.haveIdenticalErrors(expected), @"Signals have the same errors");
}

- (void) test_differentErrors {
    NSError *anotherError = [NSError errorWithDomain:@"foo" code:1 userInfo:@{}];
    
    RACSignal *signal = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:MI9SpecError]];
    RACSignal *expected = [[[[RACSignal return:@YES] concat:[RACSignal return:@NO]] concat:[RACSignal return:@5]] concat:[RACSignal error:anotherError]];
    
    assertPass(test_expect(signal).toNot.haveIdenticalErrors(expected));
    assertFail(test_expect(signal).to.haveIdenticalErrors(expected), @"Signals have different errors");
}

@end
