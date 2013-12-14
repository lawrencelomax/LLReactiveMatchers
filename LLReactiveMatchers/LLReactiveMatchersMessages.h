//
//  LLReactiveMatchersMessages.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 12/12/2013.
//
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

extern NSString *LLDescribeSignal(RACSignal *signal);

@interface LLReactiveMatchersMessages : NSObject

+ (NSString *) actualNotSignal:(id)actual;
+ (NSString *) actualNotFinished:(RACSignal *)actual;
+ (NSString *) expectedNotFinished:(RACSignal *)actual;

@end
