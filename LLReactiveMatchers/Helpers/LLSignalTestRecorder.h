//
//  LLSignalTestRecorder.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 10/12/2013.
//
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

/// This class is used to record the events sent by a Signal for asserting against procedurall
/// It will behave similarly to RACReplaySubject, it will send all events that the
/// Signal passed through has sent. It is not a subclass of RACReplaySubject
/// the events it sends are determined purely by the passed through Signal
///
/// This class provides additional public properties for obtaining the events that have
/// been sent by the passed through Signal.
/// These public properties are intended for usage in Matchers, or for writing tests
/// in a more procedural way. As such they are contrary to the spirit of FRP,
/// and should not be used in production code. Additionally, there is no concept
/// of a capacity like there is with RACReplaySubject, so this class can
/// indefinately accumilate values.
///
/// The passed through Signal is subscribed to only once, so side effects will
/// occur only once, regardless of how many times this class is subscribed to
@interface LLSignalTestRecorder : RACSignal

/// The designated initializer, will subscribe and record to the events sent by ```Signal```
+ (instancetype) recordWithSignal:(RACSignal *)signal;

+ (instancetype) recorderThatSendsValues:(id)values thenErrors:(NSError *)error;
+ (instancetype) recorderThatSendsValuesThenCompletes:(id)values;

@property (nonatomic, readonly) RACSignal *originalSignal;

@property (nonatomic, readonly) NSArray *values;
@property (nonatomic, readonly) NSUInteger valuesSentCount;

@property (nonatomic, readonly) BOOL haveErrored;
@property (nonatomic, readonly) BOOL hasErrored;
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) BOOL hasCompleted;
@property (nonatomic, readonly) BOOL haveCompleted;

@property (nonatomic, readonly) BOOL hasFinished;
@property (nonatomic, readonly) BOOL haveFinished;

@property (nonatomic, readonly) NSString *originalSignalDescription;
@property (nonatomic, readonly) NSString *valuesDescription;
@property (nonatomic, readonly) NSString *errorDescription;

@end

// Convenience for creating a test recorder for chainging purposes
@interface RACSignal(LLSignalTestRecorder)

- (LLSignalTestRecorder *) testRecorder;

@end
