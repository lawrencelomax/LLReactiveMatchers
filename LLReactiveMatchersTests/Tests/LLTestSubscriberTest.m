#import "LLTestSubscriber.h"

@interface LLTestSubscriberTests : TEST_SUPERCLASS
@end

@implementation LLTestSubscriberTests

- (void) test_signalCategoryIdempotence {
    RACSignal *signal = [LLReactiveMatchersFixtures signalThatSendsValuesThenErrors];
    
    id firstSubscriber = [signal events];
    id secondSubscriber = [signal events];
    assertEquals(firstSubscriber, secondSubscriber);
}

@end