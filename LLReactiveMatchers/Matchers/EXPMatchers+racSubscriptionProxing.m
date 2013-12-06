//
//  EXPMatchers+racSubscriptionProxing.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "EXPMatchers+racSubscriptionProxing.h"

@implementation LLTestSubscriber (RACSubscriptionProxying)

- (NSArray *) values {
    return self.valuesReceived;
}

- (BOOL) haveErrored {
    return self.hasErrored;
}

- (NSError *) error {
    return self.errorReceived;
}

- (BOOL) haveCompleted {
    return self.hasCompleted;
}

@end


@implementation RACSignal (RACSubscriptionProxying)

- (NSArray *) values {
    return self.testSubscriber.values;
}

- (BOOL) haveErrored {
    return self.testSubscriber.haveErrored;
}

- (NSError *) error {
    return self.testSubscriber.error;
}

- (BOOL) haveCompleted {
    return self.testSubscriber.haveCompleted;
}

@end
