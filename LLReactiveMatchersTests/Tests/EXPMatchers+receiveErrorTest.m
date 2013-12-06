#import "EXPMatchers+receiveError.h"

@interface EXPMatchers_receiveErrorTest : TEST_SUPERCLASS
@end

@implementation EXPMatchers_receiveErrorTest

- (void) test_recieveError {
    RACSignal *signal = [LLReactiveMatchersFixtures signalThatSendsValuesThenErrors];
    
    assertPass(test_expect(signal.testSubscriber).to.receiveError());
    
    signal = [LLReactiveMatchersFixtures signalThatSendsValuesThenCompletes];
    assertFail(test_expect(signal.testSubscriber).to.receiveError(), @"expected: to send error");
}

@end