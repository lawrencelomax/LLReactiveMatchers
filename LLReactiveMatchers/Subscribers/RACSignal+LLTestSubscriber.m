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

static BOOL globalShouldHaveSingular = NO;

+ (void) setShouldHaveSingularTestProxyGlobally:(BOOL)singular {
    globalShouldHaveSingular = singular;
}

static void *shouldHaveSingularKey = &shouldHaveSingularKey;

- (BOOL) shouldHaveSingularTestProxy {
    NSNumber *value = objc_getAssociatedObject(self, shouldHaveSingularKey);
    return (value != nil) ? value.boolValue : globalShouldHaveSingular;
}

- (void) setShouldHaveSingularTestProxy:(BOOL)shouldHaveSingularTestProxy {
    objc_setAssociatedObject(self, shouldHaveSingularKey, @(shouldHaveSingularTestProxy), OBJC_ASSOCIATION_COPY);
}

- (LLSignalTestProxy *) testProxy {
    if(self.shouldHaveSingularTestProxy) {
        static const void *singularProxyKey = &singularProxyKey;
        LLSignalTestProxy *subscriber = objc_getAssociatedObject(self, singularProxyKey);
        
        if(!subscriber) {
            subscriber = [LLSignalTestProxy testProxyWithSignal:self];
            objc_setAssociatedObject(self, singularProxyKey, subscriber, OBJC_ASSOCIATION_ASSIGN);
        }
        
        return subscriber;
    }
    
    return [LLSignalTestProxy testProxyWithSignal:self];
}

@end
