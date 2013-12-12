//
//  LLSignalTestRecorder.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 10/12/2013.
//
//

#import "LLSignalTestRecorder.h"

@interface LLSignalTestRecorder ()

@property (nonatomic, strong) RACSignal *signal;
@property (nonatomic, strong) RACDisposable *subscriptionDisposable;

@property (nonatomic, assign) BOOL receivedCompletedEvent;
@property (nonatomic, assign) BOOL receivedErrorEvent;

@property (nonatomic, strong) NSMutableArray *receivedEvents;
@property (nonatomic, strong) NSError *receivedError;

@end

@implementation LLSignalTestRecorder

- (id) init {
    if( (self = [super init]) ) {
        self.receivedEvents = [NSMutableArray array];
    }
    return self;
}

+ (instancetype) recordWithSignal:(RACSignal *)signal {
    LLSignalTestRecorder *recorder = [[LLSignalTestRecorder alloc] init];
    [recorder subscribeToSignal:signal];
    return recorder;
}

- (void) dealloc {
    [self.subscriptionDisposable dispose];
}

- (void) subscribeToSignal:(RACSignal *)signal {
    self.signal = signal;
    
    // No need to break a cycle here, we want self to live as long
    // as the signal sends events
    self.subscriptionDisposable = [signal subscribeNext:^(id x) {
        @synchronized(self) {
            [self.receivedEvents addObject:x];
        }
    } error:^(NSError *error) {
        @synchronized(self) {
            self.receivedErrorEvent = YES;
            self.receivedError = error;
        }
    } completed:^{
        @synchronized(self) {
            self.receivedCompletedEvent = YES;
        }
    }];
}

#pragma mark Getters

- (NSArray *) values {
    @synchronized(self) {
        return [self.receivedEvents copy];
    }
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
