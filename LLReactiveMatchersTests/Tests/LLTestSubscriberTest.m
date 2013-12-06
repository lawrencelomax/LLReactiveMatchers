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

- (void) test_subscriberAccumilatesNextValues {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    expect(subject.events.valuesReceived).to.haveCountOf(0);
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];

    expect(subject.events.valuesReceived).to.contain(@0);
    expect(subject.events.valuesReceived).to.contain(@1);
    expect(subject.events.valuesReceived).to.contain(@2);
    expect(subject.events.valuesReceived).to.haveCountOf(3);
}

@end