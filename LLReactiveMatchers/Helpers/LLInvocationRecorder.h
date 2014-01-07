//
//  LLInvocationRecorder.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 7/01/2014.
//
//

#import <Foundation/Foundation.h>

// A Class that records the presence of a message send on any object
// This is not intended as a replacement for true mock object, minimally aims to record the number of invocations per method
@interface LLInvocationRecorder : NSProxy

+ (id) invocationRecorderWithObject:(NSObject *)object;

- (NSInteger) invocationCountForSelector:(SEL)selector;

@property (nonatomic, readonly) NSObject *object;

@end
