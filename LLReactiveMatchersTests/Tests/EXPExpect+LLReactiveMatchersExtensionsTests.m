#import "EXPExpect+LLReactiveMatchersExtensions.h"

@interface EXPExpect_LLReactiveMatchersExtensionsTests : TEST_SUPERCLASS
@end

@implementation EXPExpect_LLReactiveMatchersExtensionsTests

NSString *failureMessage = @"expected: a truthy value, got: 0, which is falsy";
NSString *failureMessageNegative = @"expected: a non-truthy value, got: 1, which is truthy";

- (void) test_swizzle {
    assertPass(test_expect(nil).willContinueTo.beNil());
    assertPass(test_expect(nil).to.beNil());
}

- (void) test_passAlways {
    BOOL pass = YES;
    
    assertPass(test_expect(pass).willContinueTo.beTruthy());
    assertFail(test_expect(pass).willNotContinueTo.beTruthy(), failureMessageNegative);
}

- (void) test_failAlways {
    BOOL pass = NO;
    
    assertFail(test_expect(pass).willContinueTo.beTruthy(), failureMessage);
    assertPass(test_expect(pass).willNotContinueTo.beTruthy());
}

- (void) test_passThenFail {
    __block BOOL pass = YES;
    
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        pass = NO;
    });
    
    assertPass(test_expect(pass).willNotContinueTo.beTruthy());
    assertFail(test_expect(pass).willContinueTo.beTruthy(), failureMessage);
}

- (void) test_failThenPass {
    __block BOOL pass = NO;

    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        pass = YES;
    });

    assertPass(test_expect(pass).willContinueTo.beTruthy());
    assertFail(test_expect(pass).willNotContinueTo.beTruthy(), failureMessageNegative);
}

- (void) test_passThenFailThenPass {
    __block BOOL pass = YES;
    
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        pass = NO;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            pass = YES;
        });
    });

    assertPass(test_expect(pass).willContinueTo.beTruthy());
    assertFail(test_expect(pass).willNotContinueTo.beTruthy(), failureMessageNegative);
}

@end
