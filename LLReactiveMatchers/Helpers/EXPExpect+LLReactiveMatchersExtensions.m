//
//  EXPExpect+LLReactiveMatchersExtensions.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 5/01/2014.
//
//

#import "EXPExpect+LLReactiveMatchersExtensions.h"

#import "Expecta.h"

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

+ (void) swizzleApplyMatcherIfNeeded {
    static BOOL hasSwizzledMethod = NO;
    
    @synchronized(EXPExpect.class) {
        if(!hasSwizzledMethod) {
            SEL originalSelector = @selector(applyMatcher:to:);
            IMP originalImplementation = class_getMethodImplementation(EXPExpect.class, originalSelector);
            IMP newImplementation = imp_implementationWithBlock(^(id blockSelf, id<EXPMatcher>matcher, NSObject *__autoreleasing* actual){
                [blockSelf applyMatcherLLRMTrampoline:matcher to:actual originalImplementation:originalImplementation];
            });
            
            Method method = class_getInstanceMethod(EXPExpect.class, originalSelector);
            BOOL swizzleSuccess = method_setImplementation(method, newImplementation);
            NSAssert(swizzleSuccess, @"Could not Swizzle %@", NSStringFromSelector(originalSelector));
            
            hasSwizzledMethod = YES;
        }
    }
}

- (void) applyMatcherLLRMTrampoline:(id<EXPMatcher>)matcher to:(NSObject *__autoreleasing *)actual originalImplementation:(IMP)originalIMP {
    if(self.willContinueTo) {
        [self applyMatcherLLRMContinousAsync:matcher to:actual];
    } else {
        originalIMP(self, _cmd, matcher, actual);
    }
}

- (void) applyMatcherLLRMContinousAsync:(id<EXPMatcher>)matcher to:(NSObject *__autoreleasing *)actual {
    EXPFail(self.testCase, self.lineNumber, self.fileName, @"willContinueTo is not yet supported");
}

@end
