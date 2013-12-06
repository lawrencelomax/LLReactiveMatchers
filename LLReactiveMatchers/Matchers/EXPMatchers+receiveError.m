#import "EXPMatchers+receiveError.h"

EXPMatcherImplementationBegin(receiveError, (void)) {
    LLTestSubscriber *subscriber = actual;
    
    prerequisite(^BOOL{
        return [subscriber isKindOfClass:LLTestSubscriber.class];;
    });
    
    match(^BOOL{
        return subscriber.hasError;
    });
    
    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected: to send error"];
    });
    
    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: to not send error"];
    });
}
EXPMatcherImplementationEnd
