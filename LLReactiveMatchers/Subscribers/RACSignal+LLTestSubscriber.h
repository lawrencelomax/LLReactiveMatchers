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

/// Returns the test subsciber for this signal. Subscribed to only once, results
/// will be the same regardless of how many matchers are used for the same Signal
- (LLTestSubscriber *) events;

@end
