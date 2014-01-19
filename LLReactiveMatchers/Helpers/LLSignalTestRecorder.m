//
//  LLSignalTestRecorder.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 10/12/2013.
//
//

#import "LLSignalTestRecorder.h"

#import "Expecta.h"
#import "RACSignal+LLSubscriptionCounting.h"
#import "LLReactiveMatchersHelpers.h"

@interface LLSignalTestRecorder ()

@property (nonatomic, strong) RACSignal *originalSignal;

@property (nonatomic, strong) RACReplaySubject *passthrough;
@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, assign) BOOL receivedCompletedEvent;
@property (nonatomic, assign) BOOL receivedErrorEvent;

@property (nonatomic, strong) NSMutableArray *receivedEvents;
@property (nonatomic, strong) NSError *receivedError;

@end

@implementation LLSignalTestRecorder

- (id) init {
    if( (self = [super init]) ) {
        self.receivedEvents = [NSMutableArray array];
        self.passthrough = [RACReplaySubject replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
        [self startCountingSubscriptions];
    }
    return self;
}

+ (instancetype) recordWithSignal:(RACSignal *)signal {
    NSAssert(signal != nil, @"Signal should not be nil");
    
    LLSignalTestRecorder *recorder = [[LLSignalTestRecorder alloc] init];
    [recorder subscribeToSignal:signal];
    return recorder;
}

+ (instancetype) recorderThatSendsValuesThenCompletes:(id)values {
    NSAssert(values != nil, @"Values should not be nil");
    
    LLSignalTestRecorder *recorder = [[LLSignalTestRecorder alloc] init];
    recorder.receivedEvents = [values mutableCopy];
    recorder.receivedCompletedEvent = YES;
    return recorder;
}

+ (instancetype) recorderThatSendsValues:(id)values thenErrors:(NSError *)error {
    NSAssert(values != nil, @"Values should not be nil");
    
    LLSignalTestRecorder *recorder = [[LLSignalTestRecorder alloc] init];
    recorder.receivedEvents = [values mutableCopy];
    recorder.receivedErrorEvent = YES;
    recorder.receivedError = error;
    return recorder;
}

- (void) dealloc {
    [self.disposable dispose];
}

- (void) subscribeToSignal:(RACSignal *)signal {
    [self setNameWithFormat:@"TestRecorder [%@]", signal.name];
    [signal startCountingSubscriptions];
    
    self.originalSignal = signal;
    
    RACSignal *locallyRecordingSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [signal subscribeNext:^(id x) {
            @synchronized(self) {
                [self.receivedEvents addObject:LLRMArrayValueForSignalValue(x)];
            }
            
            [subscriber sendNext:x];
        } error:^(NSError *error) {
            @synchronized(self) {
                self.receivedErrorEvent = YES;
                self.receivedError = error;
            }
            
            [subscriber sendError:error];
        } completed:^{
            @synchronized(self) {
                self.receivedCompletedEvent = YES;
            }
            
            [subscriber sendCompleted];
        }];
    }];
    
    self.disposable = [locallyRecordingSignal subscribe:self.passthrough];
}

#pragma mark RACSignal

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber {
    return [self.passthrough subscribe:subscriber];
}

#pragma mark Getters

- (NSArray *) values {
    @synchronized(self) {
        return [self.receivedEvents copy];
    }
}

- (NSUInteger) valuesSentCount {
    return self.values.count;
}

- (BOOL) haveErrored {
    @synchronized(self) {
        return self.receivedErrorEvent;
    }
}

- (BOOL) hasErrored {
    @synchronized(self) {
        return self.receivedErrorEvent;
    }
}

- (NSError *) error {
    @synchronized(self) {
        return self.receivedError;
    }
}

- (BOOL) hasCompleted {
    @synchronized(self) {
        return self.receivedCompletedEvent;
    }
}

- (BOOL) haveCompleted {
    @synchronized(self) {
        return self.receivedCompletedEvent;
    }
}

- (BOOL) hasFinished {
    @synchronized(self) {
        return self.receivedCompletedEvent || self.receivedErrorEvent;
    }
}

- (BOOL) haveFinished {
    @synchronized(self) {
        return self.receivedCompletedEvent || self.receivedErrorEvent;
    }
}

#pragma mark Descriptions

- (NSString *) description {
    return self.originalSignalDescription;
}

- (NSString *) originalSignalDescription {
    return self.originalSignal.name;
}

- (NSString *) valuesDescription {
    return EXPDescribeObject(self.values);
}

- (NSString *) errorDescription {
    return EXPDescribeObject(self.error);
}

@end

@implementation RACSignal(LLSignalTestRecorder)

- (LLSignalTestRecorder *) testRecorder {
    return [LLSignalTestRecorder recordWithSignal:self];
}

@end

