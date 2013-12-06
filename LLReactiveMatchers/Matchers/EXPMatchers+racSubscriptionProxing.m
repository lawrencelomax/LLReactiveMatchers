//
//  EXPMatchers+racSubscriptionProxing.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "EXPMatchers+racSubscriptionProxing.h"

@implementation LLTestSubscriber (RACSubscriptionProxying)

- (BOOL) haveErrored {
    return self.hasErrored;
}

- (BOOL) haveCompleted {
    return self.hasCompleted;
}

@end


@implementation RACSignal (RACSubscriptionProxying)

- (BOOL) haveErrored {
    return self.events.haveErrored;
}

- (BOOL) haveCompleted {
    return self.events.haveCompleted;
}

@end
