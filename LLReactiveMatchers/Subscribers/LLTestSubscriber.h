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
/// Can only ever subscribe to one signal
@interface LLTestSubscriber : NSObject <RACSubscriber>

+ (instancetype) subscribeWithSignal:(RACSignal *)signal;

/// The Signal this Subscriber has subscribed to
@property (nonatomic, readonly) RACSignal *signal;

/// An Array of all the values the Subscriber has received up to this point
@property (nonatomic, readonly) NSMutableArray *valuesReceived;

/// Whether the Signal has completed
@property (nonatomic, readonly, getter = hasCompleted) BOOL completed;

// The error, if one has been received
@property (nonatomic, readonly) NSError *errorReceived;

/// Whether the Signal has errored
@property (nonatomic, readonly, getter = hasErrored) BOOL errored;

@end


