#import "EXPMatchers+matchValues.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EXPMatchers_matchValuesTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_matchValuesTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSString *failureString = @"expected: actual to be a signal or recorder";
    
    assertFail(test_expect(actual).to.matchValues(^(NSUInteger index, id value){
        return YES;
    }), failureString);
    assertFail(test_expect(actual).toNot.matchValues(^(NSUInteger index, id value){
        return YES;
    }), failureString);
}

- (void) test_emptySignal {
    RACSignal *actual = [RACSignal.empty setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not match all values";
    
    assertPass(test_expect(actual).to.matchValues(^(NSUInteger index, id value){
        return NO;
    }));
    assertFail(test_expect(actual).toNot.matchValues(^(NSUInteger index, id value){
        return NO;
    }), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:actual];
    assertPass(test_expect(recorder).to.matchValues(^(NSUInteger index, id value){
        return NO;
    }));
    assertFail(test_expect(recorder).toNot.matchValues(^(NSUInteger index, id value){
        return NO;
    }), failureString);
}

- (void) test_passAll {
    RACSignal *actual = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to not match all values";
    
    NSArray *expected = @[RACTuplePack(@0, @0), RACTuplePack(@1, @1), RACTuplePack(@2, @2), RACTuplePack(@3, @3)];
    NSMutableArray *values = [NSMutableArray array];
    assertPass(test_expect(actual).to.matchValues(^(NSUInteger index, id value){
        [values addObject:RACTuplePack(@(index), value)];
        return YES;
    }));
    assertTrue([values isEqualToArray:expected]);
    assertFail(test_expect(actual).toNot.matchValues(^(NSUInteger index, id value){
        return YES;
    }), failureString);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:actual];
    [values removeAllObjects];
    assertPass(test_expect(recorder).to.matchValues(^(NSUInteger index, id value){
        [values addObject:RACTuplePack(@(index), value)];
        return YES;
    }));
    assertFail(test_expect(recorder).toNot.matchValues(^(NSUInteger index, id value){
        return YES;
    }), failureString);
    assertTrue([values isEqualToArray:expected]);
}

- (void) test_fail {
    RACSignal *actual = [[LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]] setNameWithFormat:@"foo"];
    NSString *failureString = @"expected: actual foo to match value 2 at index 2";
    
    NSArray *expected = @[RACTuplePack(@0, @0), RACTuplePack(@1, @1), RACTuplePack(@2, @2) ];
    NSMutableArray *values = [NSMutableArray array];
    assertPass(test_expect(actual).toNot.matchValues(^(NSUInteger index, id value){
        return NO;
    }));
    assertFail(test_expect(actual).to.matchValues(^(NSUInteger index, id value){
        [values addObject:RACTuplePack(@(index), value)];
        
        if(index == 2) {
            return NO;
        }
        return YES;
    }), failureString);
    assertTrue([values isEqualToArray:expected]);
    
    LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:actual];
    [values removeAllObjects];
    assertPass(test_expect(recorder).toNot.matchValues(^(NSUInteger index, id value){
        return NO;
    }));
    assertFail(test_expect(recorder).to.matchValues(^(NSUInteger index, id value){
        [values addObject:RACTuplePack(@(index), value)];
        
        if(index == 2) {
            return NO;
        }
        return YES;
    }), failureString);
    assertTrue([values isEqualToArray:expected]);
}

@end
