#import "LLSignalTestRecorder.h"

@interface LLSignalTestRecorderTests : TEST_SUPERCLASS
@end

@implementation LLSignalTestRecorderTests

- (void) test_recorderReferencesSignal {
    RACSignal *signal = [LLReactiveMatchersFixtures values:@[@1, @2, @3]];
    LLSignalTestRecorder *subscriber = [LLSignalTestRecorder recordWithSignal:signal];
    
    assertEquals(subscriber.originalSignal, signal);
}

- (void) test_recorderAccumilatesNextValues {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    expect(recorder.values).to.haveCountOf(0);
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];

    expect(recorder.values[0]).to.equal(@0);
    expect(recorder.values[1]).to.equal(@1);
    expect(recorder.values[2]).to.equal(@2);
    expect(recorder.values).to.haveCountOf(3);
}

- (void) test_recorderErrors {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    expect(recorder.hasErrored).to.beFalsy();
    expect(recorder.error).to.beNil();
    
    [subject sendError:MI9SpecError];
    
    expect(recorder.error).to.equal(MI9SpecError);
    expect(recorder.hasErrored).to.beTruthy();
}

- (void) test_recorderCompletes {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    expect(recorder.hasCompleted).to.beFalsy();
    
    [subject sendCompleted];
    
    expect(recorder.hasCompleted).to.beTruthy();
}

- (void) test_recorderAccumilatesNextValuesBeforeErroring {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendError:MI9SpecError];
    
    expect(recorder.values[0]).to.equal(@0);
    expect(recorder.values[1]).to.equal(@1);
    expect(recorder.values[2]).to.equal(@2);
    expect(recorder.values).to.haveCountOf(3);
    
    expect(recorder.error).to.equal(MI9SpecError);
    expect(recorder.hasErrored).to.beTruthy();
}

- (void) test_recorderAccumilatesNextValuesBeforeCompleting {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendCompleted];
    
    expect(recorder.values[0]).to.equal(@0);
    expect(recorder.values[1]).to.equal(@1);
    expect(recorder.values[2]).to.equal(@2);
    expect(recorder.values).to.haveCountOf(3);
    expect(recorder.hasCompleted).to.beTruthy();
}

- (void) test_recorderChangesNilToNSNull {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    [subject sendNext:@0];
    [subject sendNext:nil];
    [subject sendNext:@2];
    [subject sendCompleted];
    
    expect(recorder.values[0]).to.equal(@0);
    expect(recorder.values[1]).to.equal(NSNull.null);
    expect(recorder.values[2]).to.equal(@2);
    expect(recorder.values).to.haveCountOf(3);
    expect(recorder.hasCompleted).to.beTruthy();
}

- (void) test_recorderRelays {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    expect(recorder.relayedSignal).toNot.complete();
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
 
    expect(recorder.hasCompleted).to.beFalsy();
    expect(recorder.values).to.equal( (@[@0, @1, @2]) );

    [subject sendNext:@3];
    [subject sendNext:@4];
    [subject sendCompleted];
    
    expect(recorder.hasCompleted).to.beTruthy();
    expect(recorder.values).to.equal( (@[@0, @1, @2, @3, @4]) );
}

@end
