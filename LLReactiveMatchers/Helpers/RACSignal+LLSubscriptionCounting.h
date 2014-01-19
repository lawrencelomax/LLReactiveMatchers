//
//  RACSignal+LLSubscriptionCounting.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 10/01/2014.
//
//

#import "RACSignal.h"

// Starts and Stops counting the subscriptions to a Signal.
@interface RACSignal (LLSubscriptionCounting)

// Starts counting subscriptions to this signal. Returns the receiver for chaining.
- (instancetype) startCountingSubscriptions;

// Stops counting subscriptions to this signal. Returns the receiver for chaining.
- (instancetype) stopCountingSubscriptions;

// The number of subscriptions to this Signal since counting started.
// Returns -1 when recording has not yet taken place.
@property (nonatomic, readonly) NSInteger subscriptionCount;

@end
