//
//  RACSignal+LLSubscriptionCounting.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 10/01/2014.
//
//

#import "RACSignal+LLSubscriptionCounting.h"

#import <objc/runtime.h>

static inline NSMutableSet *swizzledClasses () {
    static NSMutableSet *swizzledClasses = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [NSMutableSet set];
    });
    
    return swizzledClasses;
}

static void *subscriptionCountKey = &subscriptionCountKey;

static void setSubscriptionCount(RACSignal *signal, NSUInteger count) {
    objc_setAssociatedObject(signal, subscriptionCountKey, @(count), OBJC_ASSOCIATION_RETAIN);
}

static NSInteger getSubscriptionCount(RACSignal *signal) {
    NSNumber *count = objc_getAssociatedObject(signal, subscriptionCountKey);
    return count ? count.integerValue : -1;
}

static void *referencedSubscriberKey = &referencedSubscriberKey;

static id<RACSubscriber> getReferencedSubscriber(RACSignal *signal) {
    @synchronized(signal) {
        return objc_getAssociatedObject(signal, referencedSubscriberKey);
    }
}

static void setReferencedSubscriber(RACSignal *signal, id<RACSubscriber> subscriber) {
    objc_setAssociatedObject(signal, referencedSubscriberKey, subscriber, OBJC_ASSOCIATION_ASSIGN);
}

static void *countingSubscriptionsKey = &countingSubscriptionsKey;

static BOOL getCountingSubscriptions(RACSignal *signal) {
    NSNumber *counting = objc_getAssociatedObject(signal, countingSubscriptionsKey);
    return counting ? counting.boolValue : NO;
}

static void setCountingSubscriptions(RACSignal *signal, BOOL counting) {
    objc_setAssociatedObject(signal, countingSubscriptionsKey, @(counting), OBJC_ASSOCIATION_RETAIN);
    if(getSubscriptionCount(signal) == -1) {
        setSubscriptionCount(signal, 0);
    }
}

static void swizzleSubscribeIfNeeded(RACSignal *signal) {
    NSCAssert([signal isKindOfClass:RACSignal.class], @"%@ should be a signal", signal);
    
    NSMutableSet *swizzled = swizzledClasses();
    
    @synchronized(swizzled) {
        Class class = signal.class;
        
        if(![swizzled containsObject:class]) {
            SEL subscribeSelector = @selector(subscribe:);
            
            RACDisposable *(*originalSubscribeImplementation)(id, SEL, id<RACSubscriber>) = NULL;
            originalSubscribeImplementation = (typeof(originalSubscribeImplementation)) class_getMethodImplementation(class, subscribeSelector);
            
            typeof(originalSubscribeImplementation) newImplementation = (typeof(originalSubscribeImplementation)) imp_implementationWithBlock(^(RACSignal *signal, id<RACSubscriber> subscriber){
                
                id<RACSubscriber> previousSubscriber = getReferencedSubscriber(signal);
                if(getCountingSubscriptions(signal) && previousSubscriber != signal) {
                    setSubscriptionCount(signal, getSubscriptionCount(signal) + 1);
                }
                if(previousSubscriber != subscriber) {
                    setReferencedSubscriber(signal, subscriber);
                }
                
                return originalSubscribeImplementation(signal, subscribeSelector, subscriber);
            });
            
            Method method = class_getInstanceMethod(class, subscribeSelector);
            method_setImplementation(method, (IMP) newImplementation);
            
            [swizzled addObject:class];
        }
    }
}

@implementation RACSignal (LLSubscriptionCounting)

- (instancetype) startCountingSubscriptions {
    swizzleSubscribeIfNeeded(self);
    
    setCountingSubscriptions(self, YES);
    return self;
}

- (instancetype) stopCountingSubscriptions {
    setCountingSubscriptions(self, NO);
    return self;
}

- (NSInteger) subscriptionCount {
    return getSubscriptionCount(self);
}


@end
