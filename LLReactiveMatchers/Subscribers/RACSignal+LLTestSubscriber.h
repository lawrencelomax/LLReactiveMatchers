//
//  RACSignal+LLTestSubscriber.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 6/12/2013.
//
//

#import "RACSignal.h"
#import "LLSignalTestProxy.h"

@interface RACSignal (LLTestSubscriber)

/// Sets the global default for all Signals to whether a Signal has the same
/// test proxy returned. Defaults to NO.
+ (void) setShouldHaveSingularTestProxyGlobally:(BOOL)singular;

/// Returns YES if this signal should provide the same test proxy.
/// This may need to be YES, if the same Signal needs to have its side effects
/// tested multiple times.
@property (nonatomic, assign) BOOL shouldHaveSingularTestProxy;

/// Returns the test proxy for this signal which will subscribe to the receiver.
/// If this is the proxy
- (LLSignalTestProxy *) testProxy;

@end
