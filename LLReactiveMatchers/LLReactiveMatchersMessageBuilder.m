//
//  LLReactiveMatchersMessages.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 12/12/2013.
//
//

#import "LLReactiveMatchersMessageBuilder.h"

#import "Expecta.h"

typedef NS_OPTIONS(NSUInteger, LLReactiveMatchersMessageBuilderRendering) {
    RenderActualValues = 1 << 1,
    RenderExpectedValues = 1 << 2,
    RenderActualError = 1 << 3,
    RenderExpectedError = 1 << 4,
    RenderExpectedNot = 1 << 5
};

#ifndef LLBitmaskIsOn
#define LLBitmaskIsOn(enum, mask) ( (enum & mask) == mask )
#endif

@interface LLReactiveMatchersMessageBuilder ()

@property (nonatomic, strong) LLSignalTestRecorder *actual;
@property (nonatomic, strong) LLSignalTestRecorder *expected;

@property (nonatomic, assign) LLReactiveMatchersMessageBuilderRendering rendering;

@property (nonatomic, strong) NSString *expectedBehaviour;
@property (nonatomic, strong) NSString *actualBehaviour;

@end

@implementation LLReactiveMatchersMessageBuilder

+ (instancetype) message {
    return [[self alloc] init];
}

- (instancetype) actual:(LLSignalTestRecorder *)actual {
    self.actual = actual;
    return self;
}

- (instancetype) renderActualValues {
    self.rendering = (self.rendering | RenderActualValues);
    return self;
}

- (instancetype) renderActualError {
    self.rendering = (self.rendering | RenderActualError);
    return self;
}

- (instancetype) expected:(LLSignalTestRecorder *)expected {
    self.expected = expected;
    return self;
}

- (instancetype) renderExpectedValues {
    self.rendering = (self.rendering | RenderExpectedValues);
    return self;
}

- (instancetype) renderExpectedNot {
    self.rendering = (self.rendering | RenderExpectedNot);
    return self;
}

- (instancetype) renderExpectedError {
    self.rendering = (self.rendering | RenderExpectedError);
    return self;
}

- (NSString *) build {
    NSMutableString *string = [NSMutableString string];

    [string appendString:@"expected:"];
    NSString *actualString = self.actual.originalSignalDescription;
    if(actualString) {
        [string appendFormat:@" actual %@", actualString];
    }
    
    BOOL renderedExpected = NO;
    if(LLBitmaskIsOn(self.rendering, RenderExpectedValues)) {
        renderedExpected = YES;
        
        if(LLBitmaskIsOn(self.rendering, RenderExpectedNot)) {
            [string appendFormat:@" to not send values %@", self.expected.valuesDescription];
        } else {
            [string appendFormat:@" to send values %@", self.expected.valuesDescription];
        }
    }
    else if(LLBitmaskIsOn(self.rendering, RenderExpectedError)) {
        renderedExpected = YES;
        
        if(LLBitmaskIsOn(self.rendering, RenderExpectedNot)) {
            [string appendFormat:@" to not send error %@", self.expected.errorDescription];
        } else {
            [string appendFormat:@" to send error %@", self.expected.errorDescription];
        }
    }

    NSString *expectedString = self.expected.originalSignalDescription;
    if(self.expectedBehaviour) {
        [string appendFormat:@" to %@", self.expectedBehaviour];
    }
    if (expectedString && !renderedExpected) {
        [string appendFormat:@" expected %@", expectedString];
    }
    
    if(self.actualBehaviour || LLBitmaskIsOn(self.rendering, RenderActualValues) || LLBitmaskIsOn(self.rendering, RenderActualError)) {
        [string appendString:@", got:"];
        if(LLBitmaskIsOn(self.rendering, RenderActualValues)) {
            [string appendFormat:@" %@ values sent", self.actual.valuesDescription];
        }
        else {
            [string appendFormat:@" %@", self.actualBehaviour];
        }
    }
    
    return [string copy];
}

- (instancetype) expectedBehaviour:(NSString *)behaviour {
    self.expectedBehaviour = behaviour;
    return self;
}

- (instancetype) actualBehaviour:(NSString *)behaviour {
    self.actualBehaviour = behaviour;
    return self;
}

+ (NSString *) actualNotCorrectClass:(id)actual {
    return [NSString stringWithFormat:@"expected: actual to be a signal or recorder"];
}

+ (NSString *) expectedNotCorrectClass:(id)expected {
    return [NSString stringWithFormat:@"expected: expected to be a signal or recorder"];
}

+ (NSString *) actualNotFinished:(LLSignalTestRecorder *)actual {
    return [NSString stringWithFormat:@"expected: actual %@ to finish", actual.originalSignalDescription];
}

+ (NSString *) expectedNotFinished:(LLSignalTestRecorder *)expected {
    return [NSString stringWithFormat:@"expected: expected %@ to finish", expected.originalSignalDescription];
}

+ (NSString *) expectedSignalDidNotRecordSubscriptions:(RACSignal *)signal {
    return [NSString stringWithFormat:@"expected: actual %@ to start recording subscriptions", signal.name];
}

+ (NSString *) expectedSignal:(RACSignal *)signal toBeSubscribedTo:(NSInteger)expected actual:(NSInteger)actual {
    return [NSString stringWithFormat:@"expected: actual %@ to be subscribed to %@ times, got: %@ times", signal.name, @(expected), @(actual)];
}

+ (NSString *) expectedSignal:(RACSignal *)signal toNotBeSubscribedTo:(NSInteger)expected {
    return [NSString stringWithFormat:@"expected: actual %@ to not be subscribed to %@ times", signal.name, @(expected)];
}

@end
