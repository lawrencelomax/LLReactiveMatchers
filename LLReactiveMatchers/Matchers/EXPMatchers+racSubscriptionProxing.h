//
//  EXPMatchers+racSubscriptionProxing.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "Expecta.h"

/// Contains category methods for hooking up to expecta's dynamic predicate matchers

EXPMatcherInterface(haveErrored, (void))
EXPMatcherInterface(haveCompleted, (void))

@interface LLTestSubscriber (RACSubscriptionProxying)

@property (nonatomic, readonly) NSArray *values;

@property (nonatomic, readonly) BOOL haveErrored;
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) BOOL haveCompleted;

@end

@interface RACSignal (RACSubscriptionProxying)

@property (nonatomic, readonly) NSArray *values;

@property (nonatomic, readonly) BOOL haveErrored;
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) BOOL haveCompleted;

@end
