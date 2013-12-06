//
//  LLTestSubscriber.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "LLTestSubscriber.h"

#import <objc/runtime.h>

@interface LLTestSubscriber ()

@property (nonatomic, weak) RACSignal *signal;

@end

@implementation LLTestSubscriber

+ (instancetype) subscribeWithSignal:(RACSignal *)signal {
    LLTestSubscriber *subscriber = [LLTestSubscriber replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    subscriber.signal = signal;
    [signal subscribe:subscriber];
    return subscriber;
}

@end

@implementation RACSignal (EXPRACSubscriber)

- (LLTestSubscriber *) events {
    static const char *key;
    
    LLTestSubscriber *subscriber = objc_getAssociatedObject(self, key);
    if(!subscriber) {
        subscriber = [LLTestSubscriber subscribeWithSignal:self];
        objc_setAssociatedObject(self, key, subscriber, OBJC_ASSOCIATION_ASSIGN);
    }
    
    return subscriber;
}

@end
