#import "EXPMatchers+matchValues.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EXPMatchers_matchValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_matchValuesTests

- (void) test_nonSignalActual {
    NSArray *signal = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(signal).to.matchValues(^(NSUInteger index, id value){
        return YES;
    }), failureString);
    assertFail(test_expect(signal).toNot.matchValues(^(NSUInteger index, id value){
        return YES;
    }), failureString);
}

- (void) test_emptySignal {
    RACSignal *signal = [RACSignal.empty setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not match all values";
    
    assertPass(test_expect(signal).to.matchValues(^(NSUInteger index, id value){
        return NO;
    }));
    assertFail(test_expect(signal).toNot.matchValues(^(NSUInteger index, id value){
        return NO;
    }), failureString);
}

- (void) test_passAll {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not match all values";
    
    NSArray *expected = @[RACTuplePack(@0, @0), RACTuplePack(@1, @1), RACTuplePack(@2, @2), RACTuplePack(@3, @3)];
    NSMutableArray *values = [NSMutableArray array];
    
    assertPass(test_expect(signal).to.matchValues(^(NSUInteger index, id value){
        [values addObject:RACTuplePack(@(index), value)];
        return YES;
    }));
    assertFail(test_expect(signal).toNot.matchValues(^(NSUInteger index, id value){
        return YES;
    }), failureString);
    assertTrue([values isEqualToArray:expected]);
}

- (void) test_fail {
    RACSignal *signal = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to match value 2 at index 2";
    
    NSArray *expected = @[RACTuplePack(@0, @0), RACTuplePack(@1, @1), RACTuplePack(@2, @2) ];
    NSMutableArray *values = [NSMutableArray array];
    
    assertPass(test_expect(signal).toNot.matchValues(^(NSUInteger index, id value){
        return NO;
    }));
    assertFail(test_expect(signal).to.matchValues(^(NSUInteger index, id value){
        [values addObject:RACTuplePack(@(index), value)];
        
        if(index == 2) {
            return NO;
        }
        return YES;
    }), failureString);
    assertTrue([values isEqualToArray:expected]);
}

@end
