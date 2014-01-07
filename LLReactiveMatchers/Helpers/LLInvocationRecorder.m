//
//  LLInvocationRecorder.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 7/01/2014.
//
//

#import "LLInvocationRecorder.h"

@interface LLInvocationRecorder()

@property (nonatomic, strong) NSCountedSet *invocations;
@property (nonatomic, strong) NSObject *object;

@end

@implementation LLInvocationRecorder

+ (instancetype) invocationRecorderWithObject:(NSObject *)object {
    LLInvocationRecorder *recorder = [LLInvocationRecorder alloc];
    recorder.object = object;
    return recorder;
}

- (void) forwardInvocation:(NSInvocation *)invocation {
    [self.invocations addObject:NSStringFromSelector(invocation.selector)];
    
    [invocation invokeWithTarget:self.object];
}

@end
