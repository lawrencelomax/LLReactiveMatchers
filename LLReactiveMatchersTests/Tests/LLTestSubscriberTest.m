#import "LLTestSubscriber.h"

@interface LLTestSubscriberTests : TEST_SUPERCLASS
@end

@implementation LLTestSubscriberTests

- (void) test_signalCategoryIdempotence {
    RACSignal *signal = [LLReactiveMatchersFixtures signalThatSendsValuesThenErrors];
    
    id firstSubscriber = [signal testSubscriber];
    id secondSubscriber = [signal testSubscriber];
    assertEquals(firstSubscriber, secondSubscriber);
}

- (void) test_subscriberReferencesSignal {
    RACSignal *signal = [LLReactiveMatchersFixtures signalThatSendsValuesThenCompletes];
    LLTestSubscriber *subscriber = [LLTestSubscriber subscribeWithSignal:signal];
    
    assertEquals(subscriber.signal, signal);
}

- (void) test_subscriberAccumilatesNextValues {
    RACSubject *subject = [RACSubject subject];
    
    expect(subject.values).to.haveCountOf(0);
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];

    expect(subject.values).to.contain(@0);
    expect(subject.values).to.contain(@1);
    expect(subject.values).to.contain(@2);
    expect(subject.values).to.haveCountOf(3);
}

- (void) test_subscriberErrors {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    expect(subject).toNot.haveErrored();
    expect(subject.error).to.beNil();
    
    [subject sendError:MI9SpecError];
    
    expect(subject.error).to.equal(MI9SpecError);
    expect(subject).to.haveErrored();
}

- (void) test_subscriberCompletes {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    expect(subject).toNot.haveCompleted();
    
    [subject sendCompleted];
    
    expect(subject).to.haveCompleted();
}

- (void) test_subscriberAccumilatesNextValuesBeforeErroring {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendError:MI9SpecError];
    
    expect(subject.values).to.contain(@0);
    expect(subject.values).to.contain(@1);
    expect(subject.values).to.contain(@2);
    expect(subject.values).to.haveCountOf(3);
    
    expect(subject.error).to.equal(MI9SpecError);
    expect(subject).to.haveErrored();
}

- (void) test_subscriberAccumilatesNextValuesBeforeCompleting {
    RACSubject *subject = [[RACSubject subject] attatchToTestSubscriber];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendCompleted];
    
    expect(subject.values).to.contain(@0);
    expect(subject.values).to.contain(@1);
    expect(subject.values).to.contain(@2);
    expect(subject.values).to.haveCountOf(3);
    expect(subject).to.haveCompleted();
}


@end