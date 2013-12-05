#import "EXPMatchers+receiveError.h"

EXPMatcherImplementationBegin(receiveError, (EXPRACSubscriber *subscriber)) {
    match(^BOOL{
        return subscriber.hasError;
    });
    
    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected: the signal %@ to send an error", EXPDescribeObject(subscriber.signal)];
    });
    
    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: the signal %@ to not send an error", EXPDescribeObject(subscriber.signal)];
    });
}
EXPMatcherImplementationEnd
