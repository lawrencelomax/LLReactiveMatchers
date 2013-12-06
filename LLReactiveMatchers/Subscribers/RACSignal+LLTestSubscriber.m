//
//  RACSignal+LLTestSubscriber.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "RACSignal+LLTestSubscriber.h"

#import <objc/runtime.h>

@implementation RACSignal (LLTestSubscriber)

- (LLTestSubscriber *) testSubscriber {
    static const char *key;
    
    LLTestSubscriber *subscriber = objc_getAssociatedObject(self, key);
    if(!subscriber) {
        subscriber = [LLTestSubscriber subscribeWithSignal:self];
        objc_setAssociatedObject(self, key, subscriber, OBJC_ASSOCIATION_ASSIGN);
    }
    
    return subscriber;
}

- (instancetype) attatchToTestSubscriber {
    // Using getter purely for side effects *yuck*, but chaining.
    [self testSubscriber];
    
    return self;
}

@end
