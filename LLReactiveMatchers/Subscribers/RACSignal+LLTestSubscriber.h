//
//  RACSignal+LLTestSubscriber.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "RACSignal.h"
#import "LLTestSubscriber.h"

/// A Category on RACSignal to easily extract all the events
@interface RACSignal (LLTestSubscriber)

/// Returns the test subscriber for this signal, subscribing if not already done so.
/// This will only be subscribed to once, so this is similar to muticasting.
/// Results will be the same regardless of how many matchers are added.
- (LLTestSubscriber *) events;

/// Attatches to the Test Subscriber, purely a side effect.
/// Returns self for chaining.
/// The test subscriber can be obtained at any point with ```-events```.
- (instancetype) attatchToTestSubscriber;

@end
