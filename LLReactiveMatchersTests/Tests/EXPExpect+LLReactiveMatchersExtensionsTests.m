#import "EXPExpect+LLReactiveMatchersExtensions.h"

@interface EXPExpect_LLReactiveMatchersExtensionsTests : TEST_SUPERCLASS
@end

@implementation EXPExpect_LLReactiveMatchersExtensionsTests

- (void) test_swizzle {
    NSString *failureMessage = @"willContinueTo is not yet supported";
    
    assertFail(test_expect(nil).willContinueTo.beNil(), failureMessage);
    assertPass(test_expect(nil).beNil());
}

@end
