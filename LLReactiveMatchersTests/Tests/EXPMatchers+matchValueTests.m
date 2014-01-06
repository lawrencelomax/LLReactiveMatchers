#import "EXPMatchers+matchValue.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EXPMatchers_matchValueTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_matchValueTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.matchValue(0, ^(id value){
        return YES;
    }), failureString);
    
    assertFail(test_expect(signal).toNot.matchValue(0, ^(id value){
        return YES;
    }), failureString);
}

- (void) test_emptySignal {
    RACSignal *signal = [RACSignal.empty setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to to match value at index 0, got: only 0 values sent";
    
    assertPass(test_expect(signal).toNot.matchValue(0, ^(id value){
        return NO;
    }));
    assertFail(test_expect(signal).to.matchValue(0, ^(id value){
        return NO;
    }), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).willNot.matchValue(0, ^(id value){
        return NO;
    }));
    assertFail(test_expect(signal).will.matchValue(0, ^(id value){
        return NO;
    }), failureString);
}

- (void) test_matchIndexToDamnHigh {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to to match value at index 10, got: only 4 values sent";
    
    assertPass(test_expect(signal).toNot.matchValue(10, ^(id value){
        return NO;
    }));
    assertFail(test_expect(signal).to.matchValue(10, ^(id value){
        return NO;
    }), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).willNot.matchValue(10, ^(id value){
        return NO;
    }));
    assertFail(test_expect(signal).will.matchValue(10, ^(id value){
        return NO;
    }), failureString);
}

- (void) test_matchPassIndex {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to to not match value at index 2, got: matched value at index 2";
    
    assertPass(test_expect(signal).to.matchValue(2, ^(id value){
        assertEqualObjects(@2, value);
        return YES;
    }));
    assertFail(test_expect(signal).toNot.matchValue(2, ^(id value){
        assertEqualObjects(@2, value);
        return YES;
    }), failureString);
    
    signal = [signal asyncySignal];
    assertPass(test_expect(signal).will.matchValue(2, ^(id value){
        assertEqualObjects(@2, value);
        return YES;
    }));
    assertPass(test_expect(signal).willNot.matchValue(2, ^(id value){
        assertEqualObjects(@2, value);
        return YES;
    }));
}


@end
