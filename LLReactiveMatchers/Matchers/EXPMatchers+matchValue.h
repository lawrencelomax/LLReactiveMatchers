#import "Expecta.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

EXPMatcherInterface(matchValue, (NSUInteger valueIndex, BOOL(^matchBlock)(id value)) )

#define sendValue(valueIndex, expectedValue) matchValue(valueIndex, ^(id value){ return [value isEqual:EXPObjectify(expectedValue)]; })
