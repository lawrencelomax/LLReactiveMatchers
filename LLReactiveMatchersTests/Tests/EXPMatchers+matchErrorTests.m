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

- (void) test_nonFinishingSignal {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] concat:RACSignal.never] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to match error, got: did not error";
    
    assertFail(test_expect(signal).to.matchError(^(NSError *error){
        return YES;
    }), failureString);
    assertPass(test_expect(signal).toNot.matchError(^(NSError *error){
        return YES;
    }));
	
	signal = [signal asyncySignal];
	assertFail(test_expect(signal).will.matchError(^(NSError *error){
        return YES;
    }), failureString);
    assertPass(test_expect(signal).willNot.matchError(^(NSError *error){
        return YES;
    }));
	
	assertFail(test_expect(signal).willContinueTo.matchError(^(NSError *error){
        return YES;
    }), failureString);
    assertPass(test_expect(signal).willNotContinueTo.matchError(^(NSError *error){
        return YES;
    }));
}

- (void) test_nonErroringSignal {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]]  setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to match error, got: did not error";
    
    assertFail(test_expect(signal).to.matchError(^(NSError *error){
        return YES;
    }), failureString);
    assertPass(test_expect(signal).toNot.matchError(^(NSError *error){
        return YES;
    }));
	
	signal = [signal asyncySignal];
	assertFail(test_expect(signal).will.matchError(^(NSError *error){
        return YES;
    }), failureString);
    assertPass(test_expect(signal).willNot.matchError(^(NSError *error){
        return YES;
    }));
	
	assertFail(test_expect(signal).willContinueTo.matchError(^(NSError *error){
        return YES;
    }), failureString);
    assertPass(test_expect(signal).willNotContinueTo.matchError(^(NSError *error){
        return YES;
    }));
}

- (void) test_matches {
    RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] concat:[RACSignal error:LLSpecError]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not match error, got: matched error";
    
    assertPass(test_expect(signal).to.matchError(^(NSError *error){
        return YES;
    }));
    assertFail(test_expect(signal).toNot.matchError(^(NSError *error){
		return YES;
    }), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).will.matchError(^(NSError *error){
        return YES;
    }));
    assertPass(test_expect(signal).willNot.matchError(^(NSError *error){
        return YES;
    }));
    
    assertPass(test_expect(signal).willContinueTo.matchError(^(NSError *error){
        return YES;
    }));
    assertFail(test_expect(signal).willNotContinueTo.matchError(^(NSError *error){
        return YES;
    }), failureString);
}

- (void) test_notMatching {
	RACSignal *signal = [[[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] concat:[RACSignal error:LLSpecError]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to match error, got: did not match error";
    
    assertPass(test_expect(signal).toNot.matchError(^(NSError *error){
        return NO;
    }));
    assertFail(test_expect(signal).to.matchError(^(NSError *error){
		return NO;
    }), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).willNot.matchError(^(NSError *error){
        return NO;
    }));
    assertFail(test_expect(signal).will.matchError(^(NSError *error){
        return NO;
    }), failureString);
    
    assertPass(test_expect(signal).willNotContinueTo.matchError(^(NSError *error){
        return NO;
    }));
    assertFail(test_expect(signal).willContinueTo.matchError(^(NSError *error){
        return NO;
    }), failureString);
}

@end
