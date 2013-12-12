#import "LLReactiveMatchersHelpers.h"

extern BOOL __attribute__((overloadable)) identicalErrors(NSError *leftError, NSError *rightError) {
    // Succeeds if errors are both nil
    if(leftError == rightError) {
        return YES;
    }
    return [leftError isEqual:rightError];
}

extern BOOL __attribute__((overloadable)) identicalErrors(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    return identicalErrors(leftProxy.error, rightProxy.error);
}

extern BOOL identicalValues(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    return [leftProxy.values isEqualToArray:rightProxy.values];
}

extern BOOL identicalFinishingStatus(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    return (leftProxy.hasCompleted == rightProxy.hasCompleted) && (leftProxy.hasErrored == rightProxy.hasErrored);
}
