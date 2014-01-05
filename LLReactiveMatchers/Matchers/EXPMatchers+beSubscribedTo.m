#import "EXPMatchers+beSubscribedTo.h"

#import <objc/runtime.h>

static void *subscriptionCountKey = &subscriptionCountKey;

static void setSubscriptionCount(RACSignal *signal, NSUInteger count) {
    objc_setAssociatedObject(signal, subscriptionCountKey, @(count), OBJC_ASSOCIATION_COPY);
}

static NSUInteger getSubscriptionCount(RACSignal *signal) {
    NSNumber *subscriptionCount = objc_getAssociatedObject(signal, subscriptionCountKey);
    return subscriptionCount ? subscriptionCount.integerValue : -1;
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
__block NSInteger subscriptionCount = 0;
__block BOOL hasSubscribed = NO;

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    swizzleSubscribeIfNeeded();
    
    @synchronized(actual) {
        return (times == subscriptionCount);
    }
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    @synchronized(actual) {
        NSInteger subscriptionCount = getSubscriptionCount(actual);
        return [NSString stringWithFormat:@"Signal %@ subscribed to %d times instead of %d", LLDescribeSignal(actual), subscriptionCount, times];
    }
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    @synchronized(actual) {
        NSInteger subscriptionCount = getSubscriptionCount(actual);

        return [NSString stringWithFormat:@"Signal %@ subscribed to %d times", LLDescribeSignal(actual), subscriptionCount];
    }
});

EXPMatcherImplementationEnd
