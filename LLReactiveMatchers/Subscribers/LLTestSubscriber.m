//
//  LLTestSubscriber.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "LLTestSubscriber.h"

@interface LLTestSubscriber ()

@property (nonatomic, weak) RACSignal *signal;
@property (nonatomic, strong) RACDisposable *disposable;

@property (nonatomic, strong) NSMutableArray *valuesReceived;

@property (nonatomic, assign, getter = hasCompleted) BOOL completed;

@property (nonatomic, assign, getter = hasErrored) BOOL errored;
@property (nonatomic, strong) NSError *errorReceived;

@end

@implementation LLTestSubscriber

+ (instancetype) subscribeWithSignal:(RACSignal *)signal {
    LLTestSubscriber *subscriber = [[LLTestSubscriber alloc] init];
    subscriber.signal = signal;
    [signal subscribe:subscriber];
    return subscriber;
}

- (id) init {
    if( (self = [super init]) ) {
        self.valuesReceived = [NSMutableArray array];
    }
    return self;
}

- (void) dealloc {
    [self.disposable dispose];
}

#pragma mark RACSubscriber

- (void)sendNext:(id)value {
    @synchronized(self) {
        [self.valuesReceived addObject:value];
    }
}

- (void)sendError:(NSError *)error {
    @synchronized(self) {
        [self.disposable dispose];
        
        self.errored = YES;
        self.errorReceived = error;
    }
}

- (void)sendCompleted {
    @synchronized(self) {
        [self.disposable dispose];
        
        self.completed = YES;
    }
}

- (void)didSubscribeWithDisposable:(RACDisposable *)disposable {
    @synchronized(self) {
        self.disposable = disposable;
    }
}

@end
