#import "EXPMatchers+matchError.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EXPMatchers_matchErrorTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_matchErrorTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.matchError(^(NSError *error){
        return YES;
    }), failureString);
    assertFail(test_expect(signal).toNot.matchError(^(NSError *error){
        return YES;
    }), failureString);
}

@end
