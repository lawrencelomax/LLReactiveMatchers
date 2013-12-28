#import "LLReactiveMatchersHelpers.h"

extern BOOL __attribute__((overloadable)) LLRMIdenticalErrors(NSError *leftError, NSError *rightError) {
    // Succeeds if errors are both nil
    if(leftError == rightError) {
        return YES;
    }
    return [leftError isEqual:rightError];
}

extern BOOL __attribute__((overloadable)) LLRMIdenticalErrors(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder) {
    return LLRMIdenticalErrors(leftRecorder.error, rightRecorder.error);
}

extern BOOL __attribute__((overloadable)) LLRMIdenticalErrors(LLSignalTestRecorder *recorder, NSError *error) {
    return LLRMIdenticalErrors(recorder.error, error);
}

extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(NSArray *left, NSArray *right) {
    return [left isEqualToArray:right];
}

extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder) {
    return LLRMIdenticalValues(leftRecorder.values, rightRecorder.values);
}

extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(LLSignalTestRecorder *recorder, NSArray *array) {
    return LLRMIdenticalValues(recorder.values, array);
}

extern BOOL LLRMCorrectClassesForActual(id object) {
    return [object isKindOfClass:RACSignal.class] || [object isKindOfClass:LLSignalTestRecorder.class];
}

extern LLSignalTestRecorder *LLRMRecorderForObject(id object) {
    if([object isKindOfClass:LLSignalTestRecorder.class]) {
        return object;
    } else if([object isKindOfClass:RACSignal.class]){
        return [LLSignalTestRecorder recordWithSignal:object];
    } else if([object isKindOfClass:NSArray.class]) {
        return [LLSignalTestRecorder recorderThatSendsValuesThenCompletes:object];
    } else if([object isKindOfClass:NSError.class]) {
        return [LLSignalTestRecorder recorderThatSendsValues:@[] thenErrors:object];
    }
    return nil;
}

extern BOOL LLRMContainsAllValuesUnordered(LLSignalTestRecorder *recorder, NSArray *values) {
    NSSet *receievedSet = [NSSet setWithArray:recorder.values];
    NSSet *expectedSet = [NSSet setWithArray:values];
    NSMutableSet *intersectionSet = [NSMutableSet setWithSet:receievedSet];
    [intersectionSet intersectSet:expectedSet];
    
    return [intersectionSet isEqualToSet:expectedSet];
}

extern BOOL LLRMIdenticalFinishingStatus(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder) {
    return (leftRecorder.hasCompleted == rightRecorder.hasCompleted) && (leftRecorder.hasErrored == rightRecorder.hasErrored);
}

extern id LLRMArrayValueForSignalValue(id signalValue) {
    if(signalValue == nil) {
        return NSNull.null;
    }
    return signalValue;
}

extern id LLRMSignalValueForArrayValue(id signalValue) {
    if([signalValue isKindOfClass:NSNull.class]) {
        return nil;
    }
    return signalValue;
}
