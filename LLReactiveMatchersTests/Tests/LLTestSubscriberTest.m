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

- (void) test_subscriberErrors {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    expect(subject.events.hasErrored).to.beFalsy();
    expect(subject.events.errorReceived).to.beNil();
    
    [subject sendError:MI9SpecError];
    
    expect(subject.events.errorReceived).to.equal(MI9SpecError);
    expect(subject.events.hasErrored).to.beTruthy();
}

- (void) test_subscriberCompletes {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    expect(subject.events.hasCompleted).to.beFalsy();
    
    [subject sendCompleted];
    
    expect(subject.events.hasCompleted).to.beTruthy();
}


- (void) test_subscriberAccumilatesNextValuesBeforeErroring {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendError:MI9SpecError];
    
    expect(subject.events.valuesReceived).to.contain(@0);
    expect(subject.events.valuesReceived).to.contain(@1);
    expect(subject.events.valuesReceived).to.contain(@2);
    expect(subject.events.valuesReceived).to.haveCountOf(3);
    
    expect(subject.events.errorReceived).to.equal(MI9SpecError);
    expect(subject.events.hasErrored).to.beTruthy();
}

- (void) test_subscriberAccumilatesNextValuesBeforeCompleting {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendCompleted];
    
    expect(subject.events.valuesReceived).to.contain(@0);
    expect(subject.events.valuesReceived).to.contain(@1);
    expect(subject.events.valuesReceived).to.contain(@2);
    expect(subject.events.valuesReceived).to.haveCountOf(3);
    expect(subject.events.hasCompleted).to.beTruthy();
}


@end