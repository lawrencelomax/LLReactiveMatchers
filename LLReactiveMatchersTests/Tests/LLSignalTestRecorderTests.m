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
    
    [subject sendError:LLSpecError];
    
    expect(recorder.error).to.equal(LLSpecError);
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
    [subject sendError:LLSpecError];
    
    expect(recorder.values[0]).to.equal(@0);
    expect(recorder.values[1]).to.equal(@1);
    expect(recorder.values[2]).to.equal(@2);
    expect(recorder.values).to.haveCountOf(3);
    
    expect(recorder.error).to.equal(LLSpecError);
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

- (void) test_recorderRelaysValuesAndCompletion {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    NSMutableArray *values = [NSMutableArray array];
    __block BOOL hasCompleted = NO;
    [recorder subscribeNext:^(id x) {
        [values addObject:x];
    } completed:^{
        hasCompleted = YES;
    }];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
 
    expect(hasCompleted).to.beFalsy();
    expect(values).to.equal( (@[@0, @1, @2]) );

    [subject sendNext:@3];
    [subject sendNext:@4];
    [subject sendCompleted];
    
    expect(hasCompleted).to.beTruthy();
    expect(values).to.equal( (@[@0, @1, @2, @3, @4]) );
}

- (void) test_recorderRelaysValuesAndError {
    RACSubject *subject = [RACSubject subject];
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:subject];
    
    NSMutableArray *values = [NSMutableArray array];
    __block NSError *errorReceived = nil;
    [recorder subscribeNext:^(id x) {
        [values addObject:x];
    } error:^(NSError *error) {
        errorReceived = error;
    }];
    
    [subject sendNext:@0];
    [subject sendNext:@1];
    [subject sendNext:@2];
    
    expect(errorReceived).to.beNil();
    expect(values).to.equal( (@[@0, @1, @2]) );
    
    [subject sendNext:@3];
    [subject sendNext:@4];
    [subject sendError:LLSpecError];
    
    expect(errorReceived).to.equal(LLSpecError);
    expect(values).to.equal( (@[@0, @1, @2, @3, @4]) );
}

@end
