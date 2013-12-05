#import "TestHelper.h"
#import "EXPRACSubscriber.h"
#import "LLReactiveMatchersFixtures.h"

@interface EXPRACSubscriberTests : TEST_SUPERCLASS
@end

@implementation EXPRACSubscriberTests

- (void) test_signalCategoryIdempotence {
    RACSignal *signal = [LLReactiveMatchersFixtures signalThatSendsValuesThenErrors];
    
    id firstSubscriber = [signal events];
    id secondSubscriber = [signal events];
    assertEquals(firstSubscriber, secondSubscriber);
}

@end