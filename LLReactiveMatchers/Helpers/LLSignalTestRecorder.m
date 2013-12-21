//
//  LLSignalTestRecorder.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 10/12/2013.
//
//

#import "LLSignalTestRecorder.h"

#import "LLReactiveMatchersHelpers.h"

@interface LLSignalTestRecorder ()

@property (nonatomic, strong) RACSignal *originalSignal;
@property (nonatomic, strong) RACDisposable *subscriptionDisposable;

@property (nonatomic, assign) BOOL receivedCompletedEvent;
@property (nonatomic, assign) BOOL receivedErrorEvent;

@property (nonatomic, strong) NSMutableArray *receivedEvents;
@property (nonatomic, strong) NSError *receivedError;

@property (nonatomic, strong) RACReplaySubject *relaySubject;

@end

@implementation LLSignalTestRecorder

- (id) init {
    if( (self = [super init]) ) {
        self.receivedEvents = [NSMutableArray array];
        self.relaySubject = [RACReplaySubject subject];
    }
    return self;
}

+ (instancetype) recordWithSignal:(RACSignal *)signal {
    LLSignalTestRecorder *recorder = [[LLSignalTestRecorder alloc] init];
    [recorder subscribeToSignal:signal];
    return recorder;
}

+ (instancetype) recorderThatSendsValuesThenCompletes:(id)values {
    LLSignalTestRecorder *recorder = [[LLSignalTestRecorder alloc] init];
    recorder.receivedEvents = [values mutableCopy];
    recorder.receivedCompletedEvent = YES;
    return recorder;
}

+ (instancetype) recorderThatSendsValues:(id)values thenErrors:(NSError *)error {
    LLSignalTestRecorder *recorder = [[LLSignalTestRecorder alloc] init];
    recorder.receivedEvents = [values mutableCopy];
    recorder.receivedErrorEvent = YES;
    recorder.receivedError = error;
    return recorder;
    
}

- (void) dealloc {
    [self.subscriptionDisposable dispose];
}

- (void) subscribeToSignal:(RACSignal *)signal {
    self.originalSignal = signal;
    
    // No need to break a cycle here, we want self to live as long
    // as the signal sends events
    self.subscriptionDisposable = [signal subscribeNext:^(id x) {
        @synchronized(self) {
            [self.receivedEvents addObject:LLRMArrayValueForSignalValue(x)];
            [self.relaySubject sendNext:x];
        }
    } error:^(NSError *error) {
        @synchronized(self) {
            self.receivedErrorEvent = YES;
            self.receivedError = error;
            [self.relaySubject sendError:error];
        }
    } completed:^{
        @synchronized(self) {
            self.receivedCompletedEvent = YES;
            [self.relaySubject sendCompleted];
        }
    }];
}

#pragma mark Getters

- (RACSignal *) relayedSignal {
    @synchronized(self) {
        return self.relaySubject;
    }
}

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

@end
