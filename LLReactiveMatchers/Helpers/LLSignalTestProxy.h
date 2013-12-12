//
//  LLSignalTestProxy.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 10/12/2013.
//
//

#import <Foundation/Foundation.h>

/// This class is used to provide dynamic predicate matchers for Signals without
/// polluting the Signal class lots of categories
@interface LLSignalTestProxy : NSObject

/// The designated initializer, will subscribe to the Signal passed through
+ (instancetype) testProxyWithSignal:(RACSignal *)signal;

@property (nonatomic, readonly) RACSignal *signal;

@property (nonatomic, readonly) NSArray *values;

@property (nonatomic, readonly) BOOL haveErrored;
@property (nonatomic, readonly) BOOL hasErrored;
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) BOOL hasCompleted;
@property (nonatomic, readonly) BOOL haveCompleted;

@property (nonatomic, readonly) BOOL hasFinished;
@property (nonatomic, readonly) BOOL haveFinished;

@end
