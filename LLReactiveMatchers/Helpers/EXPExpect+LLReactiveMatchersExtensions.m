//
//  EXPExpect+LLReactiveMatchersExtensions.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 5/01/2014.
//
//

#import "EXPExpect+LLReactiveMatchersExtensions.h"

#import "Expecta.h"

#import <libkern/OSAtomic.h>
#import <objc/objc-runtime.h>

@implementation EXPExpect (LLReactiveMatchersExtensions)

static void *continousAsyncKey = &continousAsyncKey;

- (void) setContinuousAsync:(BOOL)continuousAsync {
    objc_setAssociatedObject(self, continousAsyncKey, @(continuousAsync), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL) continuousAsync {
    NSNumber *value = objc_getAssociatedObject(self, continousAsyncKey);
    return value ? value.boolValue : NO;
}

- (EXPExpect *) willContinueTo {
    self.continuousAsync = YES;
    
    [self.class swizzleApplyMatcherIfNeeded];
    
    return self;
}

- (EXPExpect *) willNotContinueTo {
    self.continuousAsync = YES;
    self.negative = YES;
    
    [self.class swizzleApplyMatcherIfNeeded];
    
    return self;
}

+ (void) swizzleApplyMatcherIfNeeded {
    static BOOL hasSwizzledMethod = NO;
    
    @synchronized(EXPExpect.class) {
        if(!hasSwizzledMethod) {
            SEL originalSelector = @selector(applyMatcher:to:);
            
            void (*originalImplementation)(id, SEL, id<EXPMatcher>, NSObject **) = NULL;
            originalImplementation = (typeof(originalImplementation)) class_getMethodImplementation(EXPExpect.class, originalSelector);
            
            IMP newImplementation = imp_implementationWithBlock(^(id blockSelf, id<EXPMatcher>matcher, NSObject *__autoreleasing* actual){
                [blockSelf applyMatcherLLRMTrampoline:matcher to:actual originalImplementation:originalImplementation];
            });
            
            Method method = class_getInstanceMethod(EXPExpect.class, originalSelector);
            IMP previousImplementation = method_setImplementation(method, newImplementation);
            NSAssert(previousImplementation != NULL, @"Could not Swizzle %@", NSStringFromSelector(originalSelector));
            
            hasSwizzledMethod = YES;
        }
    }
}

- (void) applyMatcherLLRMTrampoline:(id<EXPMatcher>)matcher to:(NSObject *__autoreleasing *)actual originalImplementation:(void (*)(id, SEL, id<EXPMatcher>, NSObject **) )originalIMP {
    if(self.continuousAsync) {
        [self applyMatcherLLRMContinousAsync:matcher to:actual];
    } else {
        __strong NSObject *originalObject = *actual;
        originalIMP(self, _cmd, matcher, &originalObject);
    }
}

- (void) applyMatcherLLRMContinousAsync:(id<EXPMatcher>)matcher to:(NSObject *__autoreleasing *)actual {
    BOOL failed = YES;
    
    if([matcher respondsToSelector:@selector(meetsPrerequesiteFor:)] && ![matcher meetsPrerequesiteFor:*actual]) {
        failed = YES;
    } else {
        BOOL matchResult = NO;
        
        NSTimeInterval timeOut = [Expecta asynchronousTestTimeout];
        NSDate *expiryDate = [NSDate dateWithTimeIntervalSinceNow:timeOut];
    
        while(1) {
            matchResult = [matcher matches:*actual];
            failed = self.negative ? matchResult : !matchResult;
            if([[NSDate date] compare:expiryDate] == NSOrderedDescending) {
                break;
            }
            
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
            OSMemoryBarrier();
            *actual = self.actual;
        }
        
        failed = self.negative ? matchResult : !matchResult;
    }
    if(failed) {
        NSString *message = nil;
        
        if(self.negative) {
            if ([matcher respondsToSelector:@selector(failureMessageForNotTo:)]) {
                message = [matcher failureMessageForNotTo:*actual];
            }
        } else {
            if ([matcher respondsToSelector:@selector(failureMessageForTo:)]) {
                message = [matcher failureMessageForTo:*actual];
            }
        }
        if (message == nil) {
            message = @"Match Failed.";
        }
        
        EXPFail(self.testCase, self.lineNumber, self.fileName, message);
    }
}

@end
