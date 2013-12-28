//
//  LLReactiveMatchersMessages.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 12/12/2013.
//
//

#import "LLReactiveMatchersMessageBuilder.h"

#import "Expecta.h"

typedef enum  {
    RenderActualValues = 1 << 0,
    RenderExpectedValues = 1 << 1,
    RenderActualError = 1 << 2,
    RenderExpectedError = 1 << 3
} LLReactiveMatchersMessageBuilderRendering;

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
    self.rendering = self.rendering & RenderActualValues;
    return self;
}

- (instancetype) renderActualErrors {
    self.rendering = self.rendering & RenderActualError;
    return self;
}

- (instancetype) expected:(LLSignalTestRecorder *)expected {
    self.expected = expected;
    return self;
}

- (instancetype) renderExpectedValues {
    self.rendering = self.rendering & RenderExpectedValues;
    return self;
}

- (instancetype) renderExpectedErrors {
    self.rendering = self.rendering & RenderExpectedError;
    return self;
}

- (NSString *) build {
    NSMutableString *string = [NSMutableString string];

    [string appendString:@"expected:"];
    NSString *actualString = self.actual.originalSignalDescription;
    if(actualString) {
        [string appendFormat:@" %@", actualString];
    }
    if(LLBitmaskIsOn(self.rendering, RenderExpectedValues)) {
        [string appendFormat:@" to send values %@", self.expected.valuesDescription];
    }
    else if(self.expectedBehaviour) {
        [string appendFormat:@" to %@", self.expectedBehaviour];
    }
    NSString *expectedString = self.expected.originalSignalDescription;
    if(expectedString) {
        [string appendFormat:@" %@", expectedString];
    }
    
    if(self.actualBehaviour || LLBitmaskIsOn(self.rendering, RenderActualValues)) {
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
    return [NSString stringWithFormat:@"exptected: expected %@ to finish", expected.originalSignalDescription];
}

@end
