//
//  LLTestSubscriber.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import <ReactiveCocoa/ReactiveCocoa.h>

/// The TestSubscriber is used by matchers and stores all of the events that it
/// receives. The TestSubscriber will continue to consume events until completion
/// or error.
@interface LLTestSubscriber : RACReplaySubject

+ (instancetype) subscribeWithSignal:(RACSignal *)signal;

/// The Signal this Subscriber has subscribed to
@property (nonatomic, readonly) RACSignal *signal;

/// An Array of all the values the Subscriber has received up to this point
@property (nonatomic, strong, readonly) NSMutableArray *valuesReceived;

/// Whether the Signal has completed
@property (nonatomic, assign) BOOL hasCompleted;

/// Whether the Signal has errored
@property (nonatomic, assign) BOOL hasError;

@end


/// A Category on RACSignal to easily extract all the events
@interface RACSignal (LLTestSubscriber)

/// Returns the test subsciber for this signal. Subscribed to only once, results
/// will be the same regardless of how many matchers are used for the same Signal
- (LLTestSubscriber *) events;

@end
