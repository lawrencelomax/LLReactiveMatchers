#import "LLSignalTestRecorder.h"

extern BOOL __attribute__((overloadable)) LLRMIdenticalErrors(NSError *leftError, NSError *rightError);
extern BOOL __attribute__((overloadable)) LLRMIdenticalErrors(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder);

extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(NSArray *left, NSArray *right);
extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder);

extern BOOL LLRMCorrectClassesForActual(id object);
extern LLSignalTestRecorder *LLRMRecorderForObject(id object);

extern BOOL LLRMContainsAllValuesUnordered(LLSignalTestRecorder *recorder, NSArray *values);
extern BOOL LLRMIdenticalFinishingStatus(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder);
