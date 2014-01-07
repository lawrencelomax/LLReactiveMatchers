#import "EXPMatchers+beSubscribedTo.h"

#import <objc/runtime.h>

static void *subscriptionCountKey = &subscriptionCountKey;

static void setSubscriptionCount(RACSignal *signal, NSUInteger count) {
    objc_setAssociatedObject(signal, subscriptionCountKey, @(count), OBJC_ASSOCIATION_COPY);
}

static NSUInteger getSubscriptionCount(RACSignal *signal) {
    NSNumber *subscriptionCount = objc_getAssociatedObject(signal, subscriptionCountKey);
    return subscriptionCount ? subscriptionCount.integerValue : 0;
}

static void swizzleSubscribeIfNeeded() {
    static BOOL hasSwizzledSubscribe = NO;

    @synchronized(RACSignal.class) {
        if(!hasSwizzledSubscribe) {
            SEL subscribeSelector = @selector(subscribe:);
            
            static RACDisposable *(*originalSubscribeImplementation)(id, SEL, id<RACSubscriber>) = NULL;
            originalSubscribeImplementation = (typeof(originalSubscribeImplementation)) class_getMethodImplementation(RACSignal.class, subscribeSelector);
            
            typeof(originalSubscribeImplementation) newImplementation = (typeof(originalSubscribeImplementation)) imp_implementationWithBlock(^(RACSignal *signal, id<RACSubscriber> subscriber){
                
                setSubscriptionCount(signal, getSubscriptionCount(signal) + 1);
                
                return originalSubscribeImplementation(signal, subscribeSelector, subscriber);
            });
            
            Method method = class_getInstanceMethod(RACSignal.class, subscribeSelector);
            method_setImplementation(method, (IMP) newImplementation);
            
            hasSwizzledSubscribe = YES;
        }
    }
}

EXPMatcherImplementationBegin(beSubscribedTo, (NSInteger times))

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual);
});

match(^BOOL{
    swizzleSubscribeIfNeeded();
    
    @synchronized(actual) {
        return (getSubscriptionCount(actual) == times);
    }
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    @synchronized(actual) {
        NSInteger subscriptionCount = getSubscriptionCount(actual);
        return [LLReactiveMatchersMessageBuilder expectedSignal:actual toBeSubscribedTo:times actual:subscriptionCount];
    }
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    @synchronized(actual) {
        return [LLReactiveMatchersMessageBuilder expectedSignal:actual toNotBeSubscribedTo:times];
    }
});

EXPMatcherImplementationEnd
