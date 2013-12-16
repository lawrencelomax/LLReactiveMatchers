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

extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(NSArray *left, NSArray *right) {
    return [left isEqualToArray:right];
}

extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder) {
    return [leftRecorder.values isEqualToArray:rightRecorder.values];
}

extern BOOL LLRMCorrectClassesForActual(id object) {
    return [object isKindOfClass:RACSignal.class] || [object isKindOfClass:LLSignalTestRecorder.class];
}

extern LLSignalTestRecorder *LLRMRecorderForObject(id object) {
    return [object isKindOfClass:RACSignal.class] ? [LLSignalTestRecorder recordWithSignal:object] : ([object isKindOfClass:LLSignalTestRecorder.class] ? object : nil);
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
