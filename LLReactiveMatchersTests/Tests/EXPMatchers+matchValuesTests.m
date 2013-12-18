#import "EXPMatchers+matchValues.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EXPMatchers_matchValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_matchValuesTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    
    assertFail(test_expect(actual).to.matchValues(^(NSUInteger index, id value){
        return YES;
    }), @"Actual (1, 2, 3) is not a Signal");
    
    assertFail(test_expect(actual).toNot.matchValues(^(NSUInteger index, id value){
        return YES;
    }), @"Actual (1, 2, 3) is not a Signal");
}

- (void) test_emptySignal {
    RACSignal *actual = RACSignal.empty;
    
    assertPass(test_expect(actual).to.matchValues(^(NSUInteger index, id value){
        return NO;
    }));
    
    assertFail(test_expect(actual).toNot.matchValues(^(NSUInteger index, id value){
        return NO;
    }), @"Signal matched all available values");
}

- (void) test_passAll {
    RACSignal *actual = [LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]];
    
    NSMutableArray *values = [NSMutableArray array];
    assertPass(test_expect(actual).to.matchValues(^(NSUInteger index, id value){
        [values addObject:RACTuplePack(@(index), value)];
        return YES;
    }));
    NSArray *expected = @[RACTuplePack(@0, @0), RACTuplePack(@1, @1), RACTuplePack(@2, @2), RACTuplePack(@3, @3)];
    assertTrue([values isEqualToArray:expected]);
    
    assertFail(test_expect(actual).toNot.matchValues(^(NSUInteger index, id value){
        return YES;
    }), @"Signal matched all available values");
}

- (void) test_fail {
    RACSignal *actual = [LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]];
    
    assertPass(test_expect(actual).toNot.matchValues(^(NSUInteger index, id value){
        return NO;
    }));
    
    NSMutableArray *values = [NSMutableArray array];
    assertFail(test_expect(actual).to.matchValues(^(NSUInteger index, id value){
        [values addObject:RACTuplePack(@(index), value)];
        
        if(index == 2) {
            return NO;
        }
        return YES;
    }), @"Failed to match value 2 at index 2");
    NSArray *expected = @[RACTuplePack(@0, @0), RACTuplePack(@1, @1), RACTuplePack(@2, @2) ];
    assertTrue([values isEqualToArray:expected]);
}

@end
