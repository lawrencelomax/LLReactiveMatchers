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

- (void) test_subscriberReferencesSignal {
    RACSignal *signal = [LLReactiveMatchersFixtures signalThatSendsValuesThenCompletes];
    LLTestSubscriber *subscriber = [LLTestSubscriber subscribeWithSignal:signal];
    
    assertEquals(subscriber.signal, signal);
}

@end