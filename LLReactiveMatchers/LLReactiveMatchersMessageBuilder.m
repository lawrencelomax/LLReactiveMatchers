//
//  LLReactiveMatchersMessages.m
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 12/12/2013.
//
//

#import "LLReactiveMatchersMessageBuilder.h"

#import "Expecta.h"

extern NSString *LLReactiveMatchersDescribeObject(id object) {
    if([object isKindOfClass:RACSignal.class]) {
        return [object name];
    }
    return EXPDescribeObject(object);
}

@interface LLReactiveMatchersMessageBuilder ()

@property (nonatomic, strong) id expected;
@property (nonatomic, assign) BOOL expectedProvided;

@property (nonatomic, strong) NSString *expectedBehaviour;

@property (nonatomic, strong) id actual;
@property (nonatomic, assign) BOOL actualProvided;

@property (nonatomic, strong) NSString *actualBehaviour;

@end

@implementation LLReactiveMatchersMessageBuilder

+ (instancetype) messageWithActual:(id)actual {
    LLReactiveMatchersMessageBuilder *builder = [[LLReactiveMatchersMessageBuilder alloc] init];
    builder.actual = actual;
    builder.actualProvided = YES;
    return builder;
}

+ (instancetype) messageWithActual:(id)actual expected:(id)expected {
    LLReactiveMatchersMessageBuilder *builder = [[LLReactiveMatchersMessageBuilder alloc] init];
    builder.actual = actual;
    builder.actualProvided = YES;
    builder.expected = expected;
    builder.expectedProvided = YES;
    return builder;
}

- (NSString *) build {
    NSMutableString *string = [NSMutableString string];
    
    if(self.expectedBehaviour || self.expectedProvided) {
        [string appendString:@"expected:"];
    }
    if(self.expectedProvided) {
        [string appendFormat:@" %@", LLReactiveMatchersDescribeObject(self.expected)];
        if(self.expectedBehaviour) {
            [string appendString:@","];
        }
    }
    if(self.expectedBehaviour) {
        [string appendFormat:@" %@", self.expectedBehaviour];
    }
    
    if(self.actualBehaviour || self.expectedProvided) {
        [string appendFormat:@" got:"];
    }
    if(self.actualProvided) {
        [string appendFormat:@" %@", LLReactiveMatchersDescribeObject(self.actual)];
        if(self.actualBehaviour) {
            [string appendString:@","];
        }
    }
    if(self.actualBehaviour) {
        [string appendFormat:@" %@", self.actualBehaviour];
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

+ (NSString *) actualNotSignal:(id)actual {
    return [[[self messageWithActual:actual] expectedBehaviour:@"to be a Signal"] build];
}

+ (NSString *) actualNotFinished:(RACSignal *)actual {
    return [[[self messageWithActual:actual] expectedBehaviour:@"to have finished"] build];
}

+ (NSString *) expectedNotFinished:(RACSignal *)actual {
    return [NSString stringWithFormat:@"Expected %@ has not finished", LLReactiveMatchersDescribeObject(actual)];
}

@end
