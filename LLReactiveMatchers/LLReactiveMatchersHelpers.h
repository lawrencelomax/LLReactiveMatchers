#import "LLSignalTestRecorder.h"

extern BOOL __attribute__((overloadable)) LLRMIdenticalErrors(NSError *left, NSError *right);
extern BOOL __attribute__((overloadable)) LLRMIdenticalErrors(LLSignalTestRecorder *left, LLSignalTestRecorder *right);
extern BOOL __attribute__((overloadable)) LLRMIdenticalErrors(LLSignalTestRecorder *recorder, NSError *error);

extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(NSArray *left, NSArray *right);
extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(LLSignalTestRecorder *left, LLSignalTestRecorder *right);
extern BOOL __attribute__((overloadable)) LLRMIdenticalValues(LLSignalTestRecorder *recorder, NSArray *array);

extern BOOL LLRMCorrectClassesForActual(id object);
extern LLSignalTestRecorder *LLRMRecorderForObject(id object);

extern BOOL LLRMContainsAllValuesUnordered(LLSignalTestRecorder *recorder, NSArray *values);
extern BOOL LLRMIdenticalFinishingStatus(LLSignalTestRecorder *leftRecorder, LLSignalTestRecorder *rightRecorder);

extern id LLRMArrayValueForSignalValue(id signalValue);
extern id LLRMSignalValueForArrayValue(id signalValue);
