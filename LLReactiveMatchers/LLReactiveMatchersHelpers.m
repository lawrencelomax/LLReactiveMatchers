#import "LLReactiveMatchersHelpers.h"

extern BOOL identicalErrors(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    if(leftProxy.error == rightProxy.error) {
        return YES;
    }
    return [leftProxy.error isEqual:rightProxy.error];
}

extern BOOL identicalValues(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    return [leftProxy.values isEqualToArray:rightProxy.values];
}

extern BOOL identicalFinishingStatus(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy) {
    return (leftProxy.hasCompleted == rightProxy.hasCompleted) && (leftProxy.hasErrored == rightProxy.hasErrored);
}
