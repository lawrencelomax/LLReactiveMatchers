#import "EXPMatchers+beSubscribedTo.h"

#import <objc/runtime.h>

EXPMatcherImplementationBegin(beSubscribedTo, (NSInteger times))

static void LLSwizzleSubscribe(Class class, (void)(^subscriptionBlock)(RACSignal *signal, id<RACSubscriber> subscriber) ) {
	SEL subscribeSelector = @selector(subscribe:);

    static RACDisposable *(*originalSubscribeMethod)(id, SEL, id<RACSubscriber>) = NULL;
    if(originalSubscribeMethod) {
        Method method = class_getInstanceMethod(class, subscribeSelector);
        originalSubscribeMethod = (__typeof__(forwardInvocationMethod))method_getImplementation(subscribeMethod);
    }
    id replacedImplementation = ^(RACSignal *signal, id<RACSubscriber> subscriber){
        subscriptionBlock(signal, subscriber);
        return originalSubscribeMethod(signal, subscribeSelector, subscriber);
    };
    
	class_replaceMethod(class, forwardInvocationSEL, imp_implementationWithBlock(newForwardInvocation), "v@:@");
}

BOOL correctClasses = [actual isKindOfClass:RACSignal.class];
__block NSInteger subscriptionCount = 0;
__block BOOL hasSubscribed = NO;

void (^subscribe)(void) = ^{
    if(!hasSubscribed) {
        objc_getMeth
        

        [self.rac_deallocDisposable addDisposable:[injected subscribeCompleted:^{}]];
        subscriptionCount--; //We just subscribed to it above
        hasSubscribed = YES;
    }
};

prerequisite(^BOOL{
    return correctClasses;
});

match(^BOOL{
    subscribe();
    
    @synchronized(actual) {
        return (times == subscriptionCount);
    }
});

failureMessageForTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    @synchronized(actual) {
        return [NSString stringWithFormat:@"Signal %@ subscribed to %d times instead of %d", LLDescribeSignal(actual), subscriptionCount, times];
    }
});

failureMessageForNotTo(^NSString *{
    if(!correctClasses) {
        return [LLReactiveMatchersMessages actualNotSignal:actual];
    }
    
    @synchronized(actual) {
        return [NSString stringWithFormat:@"Signal %@ subscribed to %d times", LLDescribeSignal(actual), subscriptionCount];
    }
});

EXPMatcherImplementationEnd
