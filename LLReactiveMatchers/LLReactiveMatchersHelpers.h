#import "LLSignalTestRecorder.h"

extern BOOL __attribute__((overloadable)) identicalErrors(NSError *leftError, NSError *rightError);
extern BOOL __attribute__((overloadable)) identicalErrors(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder);

extern BOOL __attribute__((overloadable)) identicalValues(NSArray *left, NSArray *right);
extern BOOL __attribute__((overloadable)) identicalValues(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder);

extern BOOL containsAllValuesUnordered(LLSignalTestRecorder *recorder, NSArray *values);
extern BOOL identicalFinishingStatus(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder);
