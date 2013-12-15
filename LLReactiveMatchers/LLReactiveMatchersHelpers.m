#import "LLReactiveMatchersHelpers.h"

extern BOOL __attribute__((overloadable)) identicalErrors(NSError *leftError, NSError *rightError) {
    // Succeeds if errors are both nil
    if(leftError == rightError) {
        return YES;
    }
    return [leftError isEqual:rightError];
}

extern BOOL __attribute__((overloadable)) identicalErrors(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder) {
    return identicalErrors(leftRecorder.error, rightRecorder.error);
}

extern BOOL __attribute__((overloadable)) identicalValues(NSArray *left, NSArray *right) {
    return [left isEqualToArray:right];
}

extern BOOL __attribute__((overloadable)) identicalValues(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder) {
    return [leftRecorder.values isEqualToArray:rightRecorder.values];
}

extern BOOL containsAllValuesUnordered(LLSignalTestRecorder *recorder, NSArray *values) {
    NSSet *receievedSet = [NSSet setWithArray:recorder.values];
    NSSet *expectedSet = [NSSet setWithArray:values];
    NSMutableSet *intersectionSet = [NSMutableSet setWithSet:receievedSet];
    [intersectionSet intersectSet:expectedSet];
    
    return [intersectionSet isEqualToSet:expectedSet];
}

extern BOOL identicalFinishingStatus(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder) {
    return (leftRecorder.hasCompleted == rightRecorder.hasCompleted) && (leftRecorder.hasErrored == rightRecorder.hasErrored);
}
