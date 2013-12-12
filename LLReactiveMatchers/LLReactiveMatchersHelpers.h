
extern BOOL __attribute__((overloadable)) identicalErrors(NSError *leftError, NSError *rightError);
extern BOOL __attribute__((overloadable)) identicalErrors(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy);

extern BOOL containsAllValuesUnordered(LLSignalTestProxy *proxy, NSArray *values);

extern BOOL identicalValues(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy);
extern BOOL identicalFinishingStatus(LLSignalTestProxy *leftProxy, LLSignalTestProxy *rightProxy);
