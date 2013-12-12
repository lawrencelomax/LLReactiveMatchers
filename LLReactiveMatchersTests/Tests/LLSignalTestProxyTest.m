#import "LLSignalTestProxy.h"

@interface LLSignalTestProxyTests : TEST_SUPERCLASS
@end

@implementation LLSignalTestProxyTests

- (void) test_proxyReferencesSignal {
    RACSignal *signal = [LLReactiveMatchersFixtures signalThatSendsValuesThenCompletes];
    LLSignalTestProxy *subscriber = [LLSignalTestProxy testProxyWithSignal:signal];
    
    assertEquals(subscriber.signal, signal);
}

- (void) test_proxyAccumilatesNextValues {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestProxy *proxy = [LLSignalTestProxy testProxyWithSignal:subject];
    
    expect(proxy.values).to.haveCountOf(0);
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];

    expect(proxy.values).to.contain(@0);
    expect(proxy.values).to.contain(@1);
    expect(proxy.values).to.contain(@2);
    expect(proxy.values).to.haveCountOf(3);
}

- (void) test_proxyErrors {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestProxy *proxy = [LLSignalTestProxy testProxyWithSignal:subject];
    
    expect(proxy.hasErrored).to.beFalsy();
    expect(proxy.error).to.beNil();
    
    [subject sendError:MI9SpecError];
    
    expect(proxy.error).to.equal(MI9SpecError);
    expect(proxy.hasErrored).to.beTruthy();
}

- (void) test_proxyCompletes {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestProxy *proxy = [LLSignalTestProxy testProxyWithSignal:subject];
    
    expect(proxy.hasCompleted).to.beFalsy();
    
    [subject sendCompleted];
    
    expect(proxy.hasCompleted).to.beTruthy();
}

- (void) test_proxyAccumilatesNextValuesBeforeErroring {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestProxy *proxy = [LLSignalTestProxy testProxyWithSignal:subject];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendError:MI9SpecError];
    
    expect(proxy.values).to.contain(@0);
    expect(proxy.values).to.contain(@1);
    expect(proxy.values).to.contain(@2);
    expect(proxy.values).to.haveCountOf(3);
    
    expect(proxy.error).to.equal(MI9SpecError);
    expect(proxy.hasErrored).to.beTruthy();
}

- (void) test_proxyAccumilatesNextValuesBeforeCompleting {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestProxy *proxy = [LLSignalTestProxy testProxyWithSignal:subject];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendCompleted];
    
    expect(proxy.values).to.contain(@0);
    expect(proxy.values).to.contain(@1);
    expect(proxy.values).to.contain(@2);
    expect(proxy.values).to.haveCountOf(3);
    expect(proxy.hasCompleted).to.beTruthy();
}

@end
