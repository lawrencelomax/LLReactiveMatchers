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

- (LLTestSubscriber *) events {
    static const char *key;
    
    LLTestSubscriber *subscriber = objc_getAssociatedObject(self, key);
    if(!subscriber) {
        subscriber = [LLTestSubscriber subscribeWithSignal:self];
        objc_setAssociatedObject(self, key, subscriber, OBJC_ASSOCIATION_ASSIGN);
    }
    
    return subscriber;
}

- (void) attatchToTestSubscriber {
    // Using getter purely for side effects *yuck*, but it makes tests clearer in the tests
    [self events];
}

@end
