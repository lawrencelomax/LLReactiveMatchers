#import "EXPMatchers+sendValuesWithCount.h"

@interface EXPMatchers_sendValuesWithCountTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_sendValuesWithCountTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    NSArray *expected = @[@1, @2];
    
    assertFail(test_expect(actual).to.sendValues(expected), @"Actual (1, 2, 3) is not a Signal");
    assertFail(test_expect(actual).toNot.sendValues(expected), @"Actual (1, 2, 3) is not a Signal");
}

- (void) test_noValues {
    RACSignal *actual = [RACSignal.empty setNameWithFormat:@"foo"];
    
    assertPass(test_expect(actual).to.sendValuesWithCount(0));
    assertFail(test_expect(actual).toNot.sendValuesWithCount(0), @"Actual foo sent 0 next events");
}

@end
