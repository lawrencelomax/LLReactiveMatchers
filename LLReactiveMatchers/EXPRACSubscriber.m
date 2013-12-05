//
//  EXPRACSubscriber.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "EXPRACSubscriber.h"

#import <objc/runtime.h>

@interface EXPRACSubscriber ()

@property (nonatomic, weak) RACSignal *signal;

@end

@implementation EXPRACSubscriber

+ (instancetype) subscribeWithSignal:(RACSignal *)signal {
    EXPRACSubscriber *subscriber = [EXPRACSubscriber replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    [signal subscribe:subscriber];
    return subscriber;
}

@end

@implementation RACSignal (EXPRACSubscriber)

- (EXPRACSubscriber *) events {
    static const char *key;
    
    EXPRACSubscriber *subscriber = objc_getAssociatedObject(self, key);
    if(!subscriber) {
        subscriber = [EXPRACSubscriber subscribeWithSignal:self];
        objc_setAssociatedObject(self, key, subscriber, OBJC_ASSOCIATION_ASSIGN);
    }
    
    return subscriber;
}

@end
